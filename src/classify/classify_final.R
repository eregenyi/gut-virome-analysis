
#########################
# Prepare the dataframe #
#########################

final_df <- map_mph_vs_blastn_diamond_df 

# Which tools identify the contigs as phage?

final_df$phage_metaphinder <- ifelse(final_df$mph_ani >= 10, 1, 0)
final_df$phage_virsorter <- ifelse(final_df$vs_category %in% c(1,2), 1, 0)
final_df$phage_blastn <- ifelse(final_df$blastn_virus_type == "Phage", 1, 0)
final_df$phage_diamond <- ifelse(final_df$diamond_virus_type == "Phage", 1, 0)

final_df$phage_final <- ifelse((final_df$phage_blastn + final_df$phage_diamond + final_df$phage_metaphinder + final_df$phage_virsorter) > 0, 1, 0 )

# Create new columns for the final taxonomy

final_df$final_organism <- NA
final_df$final_order <- NA
final_df$final_family <- NA
final_df$final_genus <- NA
final_df$final_virus_type <- NA

#######################
# First assign phages #
#######################

# 1) what diamond says is a phage
# 2) on top of that, what diamond does not find, but blastn says is a phage
# 3) on top of that, what has cat 1 or 2 in VS or ANI > 10 in MPH
# 4) if blastn or diamond classification is available, assign that

# if diamond says its phage, it is a phage
final_df$final_organism[which(final_df$diamond_virus_type == "Phage")] <- "Vira"
final_df$final_order[which(final_df$diamond_virus_type == "Phage")] <- as.character(final_df$diamond_order[which(final_df$diamond_virus_type == "Phage")])
final_df$final_family[which(final_df$diamond_virus_type == "Phage")] <- as.character(final_df$diamond_family[which(final_df$diamond_virus_type == "Phage")])
final_df$final_genus[which(final_df$diamond_virus_type == "Phage")] <- as.character(final_df$diamond_genus[which(final_df$diamond_virus_type == "Phage")])
final_df$final_virus_type[which(final_df$diamond_virus_type == "Phage")] <- as.character(final_df$diamond_virus_type[which(final_df$diamond_virus_type == "Phage")])

# if blastn says its a phage, and diamond has not already found it, it is also a phage
index_only_bp <- which((final_df$blastn_virus_type == "Phage") & (final_df$diamond_virus_type != "Phage"))
final_df$final_organism[index_only_bp] <- "Vira"
final_df$final_order[index_only_bp ] <- as.character(final_df$blastn_order[index_only_bp])
final_df$final_family[index_only_bp ] <- as.character(final_df$blastn_family[index_only_bp])
final_df$final_genus[index_only_bp ] <- as.character(final_df$blastn_genus[index_only_bp]) 
final_df$final_virus_type[index_only_bp] <- as.character(final_df$blastn_virus_type[index_only_bp])

# classification in the intersection: I trust diamond more, but if it gives no hit by: take blast
index_bd_p <- which((final_df$phage_blastn + final_df$phage_diamond) == 2)
check <- final_df[index_bd_p,]
#does the order always match? 
sum(as.character(check$blastn_order) != as.character(check$diamond_order)) # now yes
disc_order <- which(as.character(check$blastn_order) != as.character(check$diamond_order))
check[disc_order,] #THIS DOES NOT APPLY TO THE DUMMY DATASET (diamond was always better, except for one case: row 45227 
# change that one entry    
# final_df[45227, "final_order"] <- as.character(final_df[45227, "blastn_order"])
# final_df[45227, "final_family"] <- as.character(final_df[45227, "blastn_family"])
# final_df[45227, "final_genus"] <- as.character(final_df[45227, "blastn_genus"])
#does the family always match?
sum(as.character(check$blastn_family) != as.character(check$diamond_family)) # == 0
disc_family <- which(as.character(check$blastn_family) != as.character(check$diamond_family))
check[disc_family,] #diamond is always better, except for one case: row 45227, but that was already handled
#does the genus always match?
sum(as.character(check$blastn_genus) != as.character(check$diamond_genus)) # == 0
disc_genus <- which(as.character(check$blastn_genus) != as.character(check$diamond_genus))
check[disc_genus,c(11, 17, 22)] #diamond is always better, except for one case: row 45227, but that was already handled
# it's never discordant, but sometimes its 'No hit' by one tool

final_df[index_bd_p,"final_genus"] <- ifelse(final_df[index_bd_p,"diamond_genus"] == "No hit", 
                                            as.character(final_df[index_bd_p,"blastn_genus"]), 
                                            as.character(final_df[index_bd_p,"diamond_genus"]))

#if metaphinder or virsorter also finds it, assign phage
final_df$final_virus_type[which(final_df$phage_final == 1)] <- "Phage"
final_df$final_organism[which(final_df$phage_final == 1)] <- "Vira"

##################################
# Then assign eukaryotic viruses #
##################################

# Is there discordance between diamond and blastn?
sum(final_df$blastn_virus_type == "Virus_eukaryotic" & final_df$diamond_virus_type != "Virus_eukaryotic" & final_df$diamond_virus_type != "Phage") # 1
sum(final_df$blastn_virus_type != "Virus_eukaryotic"& final_df$diamond_virus_type == "Virus_eukaryotic" & final_df$blastn_virus_type != "Phage" ) # 2, yeah :(

# Would this overwrite any phages?
final_df[which(final_df$blastn_virus_type == "Phage" & final_df$diamond_virus_type == "Virus_eukaryotic"),] # Yes 
final_df[which(final_df$blastn_virus_type == "Virus_eukaryotic" & final_df$diamond_virus_type == "Phage"),] # no 

#assign diamond
index_d_euk <- which(final_df$diamond_virus_type == "Virus_eukaryotic")
final_df$final_organism[index_d_euk] <- "Vira"
final_df$final_order[index_d_euk] <- as.character(final_df$diamond_order[index_d_euk])
final_df$final_family[index_d_euk] <- as.character(final_df$diamond_family[index_d_euk])
final_df$final_genus[index_d_euk] <- as.character(final_df$diamond_genus[index_d_euk])
final_df$final_virus_type[index_d_euk] <- as.character(final_df$diamond_virus_type[index_d_euk])

#assign only blastn
index_only_b_euk <- which(final_df$blastn_virus_type == "Virus_eukaryotic" & final_df$diamond_virus_type != "Virus_eukaryotic" & final_df$diamond_virus_type != "Phage")
final_df$final_organism[index_only_b_euk] <- "Vira"
final_df$final_order[index_only_b_euk] <- as.character(final_df$blastn_order[index_only_b_euk])
final_df$final_family[index_only_b_euk] <- as.character(final_df$blastn_family[index_only_b_euk])
final_df$final_genus[index_only_b_euk] <- as.character(final_df$blastn_genus[index_only_b_euk]) 
final_df$final_virus_type[index_only_b_euk] <- as.character(final_df$blastn_virus_type[index_only_b_euk])

#intersection
index_db_euk <- which(final_df$blastn_virus_type == "Virus_eukaryotic" & final_df$diamond_virus_type == "Virus_eukaryotic")
check2 <- final_df[index_db_euk,]
#does the order always match? 
sum(as.character(check2$blastn_order) != as.character(check2$diamond_order)) # == 0, so they always match
#does the family always match?
sum(as.character(check2$blastn_family) != as.character(check2$diamond_family)) # == 0, so they always match
#does the genus always match?
sum(as.character(check2$blastn_genus) != as.character(check2$diamond_genus)) # == 115, so we have to check
disc_genus_euk <- which(as.character(check2$blastn_genus) != as.character(check2$diamond_genus))
check2[disc_genus_euk,c(11, 17, 22)] #it seems to be always no hit for one of the tools when the results are discordant.
# So lets make it if its no hit for diamond, assign blast, otherwise the diamond one.
final_df[index_db_euk,"final_genus"] <- ifelse(final_df[index_db_euk,"diamond_genus"] == "No hit", 
                                              as.character(final_df[index_db_euk,"blastn_genus"]), 
                                              as.character(final_df[index_db_euk,"diamond_genus"]))
#is it fine?

#################
# Then the rest #
#################

#I don't really care about the rest 'cause its probably contamination, or just not recognized, so assign blast classification when available, and blast if not 
# to check what is up after: unique(), levels(), sum(is.na())

# organism
final_df$final_organism[which(final_df$final_organism == "No hit")] <- as.character(final_df$diamond_organism[which(final_df$final_organism == "No hit")])
final_df$final_organism[which(final_df$final_organism == "No hit")] <- as.character(final_df$blastn_organism[which(final_df$final_organism == "No hit")])

# order
final_df$final_order[which(is.na(final_df$final_order))] <- "No hit"

# family
final_df$final_family[which(is.na(final_df$final_family))] <- "No hit"

# genus
final_df$final_genus[which(is.na(final_df$final_genus))] <- "No hit"

# virus_type
final_df$final_virus_type[which(final_df$final_virus_type == "Not_viral")] <- as.character(final_df$diamond_virus_type[which(final_df$final_virus_type == "Not_viral")])
final_df$final_virus_typem[which(final_df$final_virus_type == "Not_viral")] <- as.character(final_df$blastn_virus_type[which(final_df$final_virus_type == "Not_viral")])

#View(final_df[,])
names(final_df)
colSums(is.na(final_df))

#one last thing: if metaphinder found something but it was identified as eukaryotic virus by blast, then metaphinder's opinion does not matter!

idx_mph_euk <- which(final_df$phage_metaphinder == 1 & final_df$final_virus_type == "Virus_eukaryotic")
final_df[idx_mph_euk, "phage_final"] <- 0

