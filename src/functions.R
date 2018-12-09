############################
# Classification functions #
############################


get_order <- function(taxid_path, order_nn){
  '
  @param taxid_path: string value containing taxid numbers separated by $. Example: $123$12344$2$1$1$1$
  @param order_nn: data.frame object, thats first column contains taxids, the second the name correspoding to that, and the third the rank: order (all taxids in this dataframe should be order level)
  @return: returns the order name for the given taxid path, or "No hit"
  '
  
  # assign the input to new variables, so the function does not accidentally modify the input.
  taxid_path_infun <- taxid_path
  # get the order
  taxids <- strsplit(taxid_path_infun, "$", fixed = TRUE)[[1]][-1]
  idx <- which(order_nn[,1] %in% taxids)
  if (length(idx) != 0) {
    order <- as.character(order_nn[idx,2])
  } else {
    order <- "No hit"
  }
  return(order)
}

get_family <- function(taxid_path, family_nn){
  '
  @param taxid_path: string value containing taxid numbers separated by $. Example: $123$12344$2$1$1$1$
  @param family_nn: data.frame object, thats first column contains taxids, the second the name correspoding to that, and the third the rank: family (all taxids in this dataframe should be family level)
  @return: returns the family name for the given taxid path, or "No hit"
  '
  
  # assign the input to new variables, so the function does not accidentally modify the input.
  taxid_path_infun <- taxid_path
  # get the family
  taxids <- strsplit(taxid_path_infun, "$", fixed = TRUE)[[1]][-1]
  idx <- which(family_nn[,1] %in% taxids)
  if (length(idx) != 0) {
    family <- as.character(family_nn[idx,2])
  } else {
    family <- "No hit"
  }
  return(family)
}

get_genus <- function(taxid_path, genus_nn){
  '
  @param taxid_path: string value containing taxid numbers separated by $. Example: $123$12344$2$1$1$1$
  @param genus_nn: data.frame object, thats first column contains taxids, the second the name correspoding to that, and the third the rank: genus (all taxids in this dataframe should be genus level)
  @return: returns the genus name for the given taxid path, or "No hit"
  '
  
  # assign the input to new variables, so the function does not accidentally modify the input.
  taxid_path_infun <- taxid_path
  # get the genus
  taxids <- strsplit(taxid_path_infun, "$", fixed = TRUE)[[1]][-1]
  idx <- which(genus_nn[,1] %in% taxids)
  if (length(idx) != 0) {
    genus <- as.character(genus_nn[idx,2])
  } else {
    genus <- "No hit"
  }
  return(genus)
}

get_organism <- function(taxid_path){
  '
  @param taxid_path: string value containing taxid numbers separated by $. Example: $123$12344$2$1$1$1$
  @return: returns either "Vira", "Bacteria", "Theria" (stands for mammals, these hits are most likely human), "Eukaryota" or "No hit".
  '
  
  taxid_path_infun <- taxid_path
  taxids <- strsplit(taxid_path_infun, "$", fixed = TRUE)[[1]][-1]
  if (2 %in% taxids){
    organism <- "Bacteria"
  } else if (10239 %in% taxids){
    organism <- "Vira"
  } else if (32525 %in% taxids){
    organism <- "Theria"
  } else if (2759 %in% taxids){
    organism <- "Eukaryota"
  } else {
    organism <- "No hit"
  }
  return(organism)
}

get_virus_type <- function(organism_name, order_name, family_name, phage_family_list){
  '
  @param taxid_path: string value containing taxid numbers separated by $. Example: $123$12344$2$1$1$1$
  @return: returns either "Phage", "Virus_unknown", "Virus_eukaryotic" or "Not_viral".
  '
  
  organism_name_infun <- organism_name
  order_name_infun <- order_name
  family_name_infun <- family_name
  
  if (family_name_infun %in% phage_family_list){
    virus_type <- "Phage"
  } else if (order_name_infun == "Caudovirales"){
    virus_type <- "Phage"
  } else if (organism_name_infun == "Vira" & 
             (order_name_infun == "Unassigned" | order_name_infun == "No hit")){
    virus_type <- "Virus_unknown"
  } else if (organism_name_infun == "Vira"){
    virus_type <- "Virus_eukaryotic"
  } else {
    virus_type <- "Not_viral"
  }
  
  return(virus_type)
}