# Alternatively, taxonomic classification could be done using the R package 'taxize' (in that case, the local data file of taxids do not have to be updated), 
# but that would be really slow for larger datasets.

# Make a copy
diamond_df <- diamond_raw

# List of phage families
phage_family_list <- c("Myoviridae", "Siphoviridae", "Podoviridae", "Lipothrixviridae", 
                       "Rudiviridae", "Bicaudaviridae", "Clavaviridae", "Corticoviridae", 
                       "Cystoviridae", "Cystoviridae", "Fuselloviridae", "Globuloviridae", 
                       "Guttaviridae", "Inoviridae", "Leviviridae", "Microviridae", 
                       "Tectiviridae", "bacterial virus", "unclassified Caudovirales") 

# Assign taxonomy

diamond_df$organism <- NA
diamond_df$order <- NA
diamond_df$family <- NA
diamond_df$genus <- NA
diamond_df$virus_type <- NA

diamond_df$organism <- lapply(as.character(diamond_df$V2), get_organism)
diamond_df$order <- lapply(as.character(diamond_df$V2), get_order, order_nn = taxids_ord)
diamond_df$family <- lapply(as.character(diamond_df$V2), get_family, family_nn = taxids_fam)
diamond_df$genus <- lapply(as.character(diamond_df$V2), get_genus, genus_nn = taxids_gen)
diamond_df$virus_type <- apply(diamond_df[,c('organism', 'order', 'family')], 1, function(x) get_virus_type(organism_name = x['organism'], 
                                                                                                          order_name = x['order'], family_name = x['family'], phage_family_list = phage_family_list))

# You always want to check manually, if everything is assigned properly!

#if the order is empty but the family is not, (for viruses) put it into unassigned.
diamond_df$order[diamond_df$organism == "Vira" & diamond_df$order == "No hit" & diamond_df$family != "No hit"] <- "Unassigned"
#if the order is unassigned, and the virus_type is not phage, make it "To check"! Also if the order is "No hit", also!
diamond_df$virus_type[diamond_df$organism == "Vira" & diamond_df$order == "Unassigned"  & diamond_df$virus_type != "Phage"] <- "To check"
diamond_df$virus_type[diamond_df$organism == "Vira" & diamond_df$order == "No hit"  & diamond_df$virus_type != "Phage"] <- "To check"

# How many do I have to check manually?

nrow(diamond_df[diamond_df$virus_type == "To check",]) 
diamond_df[diamond_df$virus_type == "To check",]

# Rewrite entries that needed to be checked

diamond_df$virus_type[which(grepl("$1868660$", diamond_df$V2, fixed=TRUE))] <- "Phage" # 1868660 is an unidentified phage id (Mediterranian phage) according to ncbi
diamond_df$order[which(grepl("$1868660$", diamond_df$V2, fixed=TRUE))] <- "Unassigned"

diamond_df$virus_type[which(diamond_df$family == "Parvoviridae")] <- "Virus_eukaryotic" #Host: vertebrates (Dependoparvovirus, Bocaparvovirus, Protoparvovirus)
diamond_df$order[diamond_df$family == "Parvoviridae"] <- "Unassigned"

diamond_df$virus_type[which(diamond_df$family == "Anelloviridae")] <- "Virus_eukaryotic"
diamond_df$order[diamond_df$family == "Anelloviridae"] <- "Unassigned"

diamond_df$virus_type[which(diamond_df$family == "Retroviridae")] <- "Virus_eukaryotic" 
diamond_df$order[diamond_df$family == "Retroviridae"] <- "Unassigned"

# Rename rows
names(diamond_df) <- c("contig_name", "diamond_taxid_path", "diamond_organism", "diamond_order", "diamond_family", "diamond_genus", "diamond_virus_type")

