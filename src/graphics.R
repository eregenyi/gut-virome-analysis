##############################
# Why to use multiple tools? #
##############################
"
Why is it advantegous to use metaphinder2 and virsorter additionally to diamond and blastn
for identification of our viral shotgun data?
Since many of the existing phages are not yet administered in databases, blastn and diamond
(which are database search algorithms) misses these. However, the other softwares are capable
of making an 'educated guess', so incorporating their results helps us find more phage contigs. 
"
# At a contig level
pdf(file.path(location, "img", "venn.pdf"), height = 8, width = 8)
grid.newpage()
draw.quad.venn(area1 = sum(final_cleaned_df$phage_blastn), 
               area2 = sum(final_cleaned_df$phage_diamond), 
               area3 = sum(final_cleaned_df$phage_metaphinder),
               area4 = sum(final_cleaned_df$phage_virsorter), 
               n12 = nrow(final_cleaned_df[which(final_cleaned_df$phage_blastn == 1 & final_cleaned_df$phage_diamond == 1),]), 
               n13 = nrow(final_cleaned_df[which(final_cleaned_df$phage_blastn == 1 & final_cleaned_df$phage_metaphinder == 1),]), 
               n14 = nrow(final_cleaned_df[which(final_cleaned_df$phage_blastn == 1 & final_cleaned_df$phage_virsorter == 1),]), 
               n23 = nrow(final_cleaned_df[which(final_cleaned_df$phage_diamond == 1 & final_cleaned_df$phage_metaphinder == 1),]), 
               n24 = nrow(final_cleaned_df[which(final_cleaned_df$phage_diamond == 1 & final_cleaned_df$phage_virsorter == 1),]), 
               n34 = nrow(final_cleaned_df[which(final_cleaned_df$phage_metaphinder == 1 & final_cleaned_df$phage_virsorter == 1),]),  
               n123 = nrow(final_cleaned_df[which(final_cleaned_df$phage_blastn == 1 & final_cleaned_df$phage_diamond == 1 & final_cleaned_df$phage_metaphinder == 1),]), 
               n124 = nrow(final_cleaned_df[which(final_cleaned_df$phage_blastn == 1 & final_cleaned_df$phage_diamond == 1 & final_cleaned_df$phage_virsorter == 1),]), 
               n134 = nrow(final_cleaned_df[which(final_cleaned_df$phage_blastn == 1 & final_cleaned_df$phage_metaphinder == 1 & final_cleaned_df$phage_virsorter == 1),]), 
               n234 = nrow(final_cleaned_df[which(final_cleaned_df$phage_diamond == 1 & final_cleaned_df$phage_metaphinder == 1 & final_cleaned_df$phage_virsorter == 1),]),
               n1234 = nrow(final_cleaned_df[which(final_cleaned_df$phage_blastn == 1 & final_cleaned_df$phage_diamond == 1 & final_cleaned_df$phage_metaphinder == 1 & final_cleaned_df$phage_virsorter == 1),]),
               
               category = c("BLASTn", "DIAMOND", "Metaphinder2", "VIRSorter"),
               fill = c("dodgerblue", "darkorange1", "orchid3", "seagreen3"),
               cat.col = c("dodgerblue", "darkorange1", "orchid3", "seagreen3"),
               cat.cex = 1.2,
               margin = 0.01,
               ind = TRUE,
               cat.pos = c(0.001, 10, 1.0, 1.0),
               cat.dist = c(0.21, 0.21, 0.1, 0.1)
               )
dev.off()

# At a read level (?)

##################
# Contig lengths #
##################
"
Contig lengths can be important: short contigs might not correspond to full virus (usually more hard to guess if phage) genomes; 
In that case, it might be a fragmented virus, or the genome got chopped up during sample preparation, for example.
"

# boxplot
pdf(file.path(location, "img", "box_plot.pdf"), height = 10, width = 7)
p2 <- ggplot(data = final_cleaned_df, aes(y = as.numeric(contig_lengths), x = 1)) +
  geom_boxplot(width = 1, outlier.colour="steelblue", outlier.shape=1,
               outlier.size=4, coef = 2, fill = "steelblue")  + xlim(c(0,2))
p2 + labs(title = "Quartiles of the contig length", y = "Contig length") +
  theme_gdocs() +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

dev.off()
