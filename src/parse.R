# Parse the mappings files
list_of_files <-  dir(path = file.path(location, "data", "input", "mappings"), pattern =  "*.csv", full.names = TRUE)
list_of_mappings <- lapply(list_of_files, read.csv)
mappings_df <- Reduce(function(...) merge(..., all = TRUE, by = "X"), list_of_mappings) 

# Add contig length
mappings_df$contig_length <- sapply(mappings_df$X, function(x) strsplit(as.character(x), "_", fixed = TRUE)[[1]][4])

# Add metaphinder ANI
mph_df <- read.csv(file = file.path(location, "data", "input", "metaphinder2.csv"), header = TRUE)
names(mph_df)[2] <- "mph_ani"
map_mph_df <- merge(mappings_df, mph_df[,1:2], by.x = "X", by.y = "contigID", all = TRUE)

# Add VirSorter Category
vs_df <- read.table(file = file.path(location, "data", "input", "virsorter.csv"), header = FALSE, sep = ",") # VirSorter adds some characters in the raw output to the contig names. These characters were removed prior to processing here
names(vs_df)[5] <- "vs_category"
map_mph_vs_df <- merge(map_mph_df, vs_df[,c(1,5)], by.x = "X", by.y = "V1", all = TRUE)

# Read blastn and Diamond results, + files for classification
taxids_ord <- read.csv(file = file.path(location, "data", "input", "taxids_order.csv")) # this file, and the following two had been created from the nodes and names files (containing the current taxonomy) fetched from ncbi
taxids_fam <- read.csv(file = file.path(location, "data", "input", "taxids_family.csv"))
taxids_gen <- read.csv(file = file.path(location, "data", "input", "taxids_genus.csv"))
blastn_raw <- read.table(text = gsub("#", "$", readLines(file.path(location, "data", "input", "blastn_taxidpaths.txt")))) # the results of a blastn search after using kt_classify_blast to get the taxid paths
diamond_raw <- read.table(text = gsub("#", "$", readLines(file.path(location, "data", "input", "diamond_taxidpaths.txt")))) # the results of a diamond search after using kt_classify_blast to get the taxid paths

# Add Blastn classification
source(file.path(location, "src", "classify", "classify_blastn.R")) #constructs blastn_df
map_mph_vs_blastn_df <- merge(map_mph_vs_df, blastn_df[,-2], by.x = "X", by.y = "contig_name", all = TRUE)

# Add DIAMOND classification
source(file.path(location, "src", "classify", "classify_blastn.R")) #constructs diamond_df
map_mph_vs_blastn_diamond_df <- merge(map_mph_vs_blastn_df, diamond_df[,-2], by.x = "X", by.y = "contig_name", all = TRUE)

# Assign final classification
source(file.path(location, "src", "classify", "classify_final.R")) # assigns final classification to each contig

# Clean data: Considering details from the lab and going through the results of classification, you will probably have to remove some entries
  # The present dummy sets are imitating human faecal samples. During the lab analysis, Feline Protoparvovirus was used as a skpike-in control (to keep track of amplification). It is highly unlikely to find this virus in a healthy human's guts. Before analysis, this entry has to be removed.
lines_to_remove <- which(final_df$X %in% c("NODE_150_length_5307_cov_4.290440","NODE_157_length_5244_cov_3.709890"))
  # There are retrovirus flanks identified by blastn and diamond. We know, that our "dummy patients" were healthy, these flanks are misclassified, and in fact are (most likely) fractions of human DNA. 
lines_to_remove <- c(lines_to_remove, which(final_df$final_family == "Retroviridae"))
  # This is shotgun data, after viral enrichment, we are only curoius about the viruses. 
lines_to_remove <- c(lines_to_remove, which(is.na(final_df$final_organism)))
  # Remove unwanted entries
final_cleaned_df <- final_df[-lines_to_remove,]

# Create a phylosec object
metadata_df <- read.csv(file = file.path(location, "data", "input", "metadata.csv"))
metadata_df$sample <- paste("Sample_", metadata_df$sample, sep = "")
OTU <- otu_table(as.matrix(data.frame(final_cleaned_df[,c(3:11,2)], row.names = final_cleaned_df$X)), taxa_are_rows = TRUE)
TAX <-tax_table(as.matrix(data.frame(final_cleaned_df[,25:34], row.names = final_cleaned_df$X)))
meta <- sample_data(data.frame(metadata_df[,2:20], row.names = metadata_df$sample))

vir_ps <- phyloseq(OTU, TAX, meta)

# Save
write.table(as.matrix(final_cleaned_df), file.path(location, "data", "output", "classification_table.txt"), append = FALSE)
save("vir_ps", file = file.path(location, "data", "output", "vir_ps.RData"))
