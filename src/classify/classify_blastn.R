# Make a copy
blastn_df <- blastn_raw

# List of phage families
phage_family_list <- c("Myoviridae", "Siphoviridae", "Podoviridae", "Lipothrixviridae", 
                       "Rudiviridae", "Bicaudaviridae", "Clavaviridae", "Corticoviridae", 
                       "Cystoviridae", "Cystoviridae", "Fuselloviridae", "Globuloviridae", 
                       "Guttaviridae", "Inoviridae", "Leviviridae", "Microviridae", 
                       "Tectiviridae", "bacterial virus", "unclassified Caudovirales") 

# Assign taxonomy

blastn_df$organism <- NA
blastn_df$order <- NA
blastn_df$family <- NA
blastn_df$genus <- NA
blastn_df$virus_type <- NA

blastn_df$organism <- lapply(as.character(blastn_df$V2), get_organism)
blastn_df$order <- lapply(as.character(blastn_df$V2), get_order, order_nn = taxids_ord)
blastn_df$family <- lapply(as.character(blastn_df$V2), get_family, family_nn = taxids_fam)
blastn_df$genus <- lapply(as.character(blastn_df$V2), get_genus, genus_nn = taxids_gen)
blastn_df$virus_type <- apply(blastn_df[,c('organism', 'order', 'family')], 1, function(x) get_virus_type(organism_name = x['organism'], 
                                                                                                      order_name = x['order'], family_name = x['family'], phage_family_list = phage_family_list))

# You always want to check manually, if everything is assigned properly!

#if the order is empty but the family is not, (for viruses) put it into unassigned.
blastn_df$order[blastn_df$organism == "Vira" & blastn_df$order == "No hit" & blastn_df$family != "No hit"] <- "Unassigned"
#if the order is unassigned, and the virus_type is not phage, make it "To check"! Also if the order is "No hit", also!
blastn_df$virus_type[blastn_df$organism == "Vira" & blastn_df$order == "Unassigned"  & blastn_df$virus_type != "Phage"] <- "To check"
blastn_df$virus_type[blastn_df$organism == "Vira" & blastn_df$order == "No hit"  & blastn_df$virus_type != "Phage"] <- "To check"

# How many do I have to check manually?

nrow(blastn_df[blastn_df$virus_type == "To check",]) 
blastn_df[blastn_df$virus_type == "To check",]

# Rewrite entries that needed to be checked

blastn_df$virus_type[which(grepl("$1868660$", blastn_df$V2, fixed=TRUE))] <- "Phage" # 1868660 is an unidentified phage id (Mediterranian phage) according to ncbi
blastn_df$order[which(grepl("$1868660$", blastn_df$V2, fixed=TRUE))] <- "Unassigned"

blastn_df$virus_type[which(blastn_df$family == "Parvoviridae")] <- "Virus_eukaryotic" #Host: vertebrates (Dependoparvovirus, Bocaparvovirus, Protoparvovirus)
blastn_df$order[blastn_df$family == "Parvoviridae"] <- "Unassigned"

blastn_df$virus_type[which(blastn_df$family == "Anelloviridae")] <- "Virus_eukaryotic"
blastn_df$order[blastn_df$family == "Anelloviridae"] <- "Unassigned"

blastn_df$virus_type[which(blastn_df$family == "Retroviridae")] <- "Virus_eukaryotic" 
blastn_df$order[blastn_df$family == "Retroviridae"] <- "Unassigned"

names(blastn_df) <- c("contig_name", "blastn_taxid_path", "balstn_organism", "blastn_order", "blastn_family", "blastn_genus", "blastn_virus_type")
