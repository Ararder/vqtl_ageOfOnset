##For the interaction model, genetic data on the 68,311 individuals are needed.
#We need number of alleles, for 10 SNPS.
#Genetic data was extracted with plink2.

library(tidyverse)


#reading in .raw data
chr7 <- read_delim("7chr_topsnp.txt.raw", delim = " ")
chr3 <- read_delim("3chr_topsnp.txt.raw", delim = " ")
chr16 <- read_delim("16chr_topsnp.txt.raw", delim = " ")
chr12 <- read_delim("12chr_topsnp.txt.raw", delim = " ")
chr19 <- read_delim("19chr_topsnp.txt.raw", delim = " ")
chr11 <- read_delim("11chr_topsnp.txt.raw", delim = " ")
chr18 <- read_delim("18chr_topsnp.txt.raw", delim = " ")
chr9 <- read_delim("9chr_topsnp.txt.raw", delim = " ")
chr2 <- read_delim("2chr_topsnp.txt.raw", delim = " ")
#### 
chr7 <- chr7 %>% select(FID, IID, 7:8)
chr3 <- chr3 %>% select(7:8)
chr16 <- chr16 %>% select(7:8)
chr12 <- chr12 %>% select(7:8)
chr19 <- chr19 %>% select(7:8)
chr11 <- chr11 %>% select(7:8)
chr18 <- chr18 %>% select(7:10)
chr9 <- chr9 %>% select(7:8)
chr2 <- chr2 %>% select(7:8)

genetic_data <- bind_cols(chr7,chr3,chr16,chr12,chr19,chr11, chr18, chr9, chr2)

write_tsv(genetic_data, "top10snps_final.txt", col_names = TRUE)