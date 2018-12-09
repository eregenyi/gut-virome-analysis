"
Module:
- reads and parses nblast, diamond, metaphinder2 and VirSorter
"

# Clear the terminal
cat("\014")

# Get masterscript location
location <- (rstudioapi::getActiveDocumentContext()$path)
location <- gsub("master.R", "", location)

# Load data from the intermediate folder (In case you have already had some work done)
intermediate_data_files <- dir(path = paste(location, "/data/intermediate/", sep =""), pattern = "(?i)[.]", recursive = TRUE, full.names = TRUE, all.files = TRUE)
lapply(intermediate_data_files,  load, .GlobalEnv)

# Source subscripts
#source(file.path(location, "src", "install.R"))
source(file.path(location, "src", "setup.R"))
source(file.path(location, "src", "functions.R"))
source(file.path(location, "src", "parse.R"))
source(file.path(location, "src", "graphics.R"))

# ToDo
"

///- Set up dummy datasets
  ///-> make blastn and diamond dummy dataset more virus-i /diverse --> make something that I have to assidn manually
  ///-> make a dummy metadata set
///- Only for 2 baby (Also dont call it baby, call it children)
- Modify and structure code (too wide description, must break down to smaller tasks)
  -> go through the functions: is everything annotated properly, is there anything that could be done easier?
///- Parse phylosec and save R object as well as text file of the whole dataset


- Visualizations
  //- Tools for phages (read and contig lvl)
  - Annotation level: what proportion of the contigs were annotated as what?
  - Diversity and richness: longitudinal for the two subjects
  - stacked area plots for both children
  - mention: additional sanctions can be introduced: e.g. contigs with less than 100 reads in a sample should be considered to be not present in that sample
               contigts that have less than 100 reads in all samples should be deleted from the dataset

- Maybe I can upload my thesis too?
- clustering part
- Wish: dummy datasets

"