###make manhanattan plot
library(tidyverse)
library(qqman)
#the dataframe with SNPS with pval < 0.05
data <- read_tsv("~/uppmax/final_sampled.txt")



clabs = c("1", 2:22)
mhplot <- manhattan(data, chr = "Chr", bp = "bp", snp = "SNP", p = "P", 
          ylim =c(0,10), annotatePval = 0.000001, chrlabs = clabs, cex.axis = 0.6)


  