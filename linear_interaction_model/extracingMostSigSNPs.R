#The 10 most significant SNPs are extracted, and SNPs from from similar clusters are removed,
#so only 1 SNP per cluster.
# "~/uppmax/final_sampled.txt" is a dataframe containing all snps that have a p-value < 0.05

library(tidyverse)
data <- read_tsv("~/uppmax/final_sampled.txt")


#All the most significant SNPs are from the chr 7 cluster, so we grab the top one and remove the others
#getting the top snp from the chr 7 cluster

tp <- data %>% 
  arrange(P)
tp <- tp[1,]


# Exclude chr 7, since we have extracted the top SNP from that cluster.

extraction <- data %>% 
  arrange(P) %>% 
  filter(Chr != 7)


#bind the top snp from chr 7 to the dataset.

extraction <- extraction[1:15,]
extraction <- bind_rows(extraction,tp)
extraction <- extraction %>% arrange(P)


#snp6 is clumped with snp 5, so its removed
extraction <- extraction[-6,]
#SNP on row 9 is close to row 8
extraction <- extraction[-8,]
#row 9 is very close to row 2
extraction <- extraction[-9,]
#done, we got the 10 independant snps 
top10 <- extraction[1:10,]







