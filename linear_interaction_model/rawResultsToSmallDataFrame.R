
#I read the raw output from OSCA. Bind together into one frame of all snps with pval < 0.05
library(tidyverse)

chr1 <- read_tsv("brit_chr1_vqtl.vqtl")
chr2 <- read_tsv("brit_chr2_vqtl.vqtl")
chr3 <- read_tsv("brit_chr3_vqtl.vqtl")
chr4 <- read_tsv("brit_chr4_vqtl.vqtl")
chr5 <- read_tsv("brit_chr5_vqtl.vqtl")
chr6<- read_tsv("brit_chr6_vqtl.vqtl")
chr7 <- read_tsv("brit_chr7_vqtl.vqtl")
chr8 <- read_tsv("brit_chr8_vqtl.vqtl")
chr9 <- read_tsv("brit_chr9_vqtl.vqtl")
chr10 <- read_tsv("brit_chr10_vqtl.vqtl")
chr11 <- read_tsv("brit_chr11_vqtl.vqtl")
chr12 <- read_tsv("brit_chr12_vqtl.vqtl")
chr13 <- read_tsv("brit_chr13_vqtl.vqtl")
chr14 <- read_tsv("brit_chr14_vqtl.vqtl")
chr15 <- read_tsv("brit_chr15_vqtl.vqtl")
chr16 <- read_tsv("brit_chr16_vqtl.vqtl")
chr17 <- read_tsv("brit_chr17_vqtl.vqtl")
chr18 <- read_tsv("brit_chr18_vqtl.vqtl")
chr19 <- read_tsv("brit_chr19_vqtl.vqtl")
chr20 <- read_tsv("brit_chr20_vqtl.vqtl")
chr21 <- read_tsv("brit_chr21_vqtl.vqtl")
chr22 <- read_tsv("brit_vqtl_chr22.vqtl")

genome <- bind_rows(chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,
                    chr16,chr17,chr18,chr19,chr20,chr21,chr22)

#chunk 1
chr1 <- read_tsv("brit_chr1_vqtl.vqtl")
chr2 <- read_tsv("brit_chr2_vqtl.vqtl")
chr3 <- read_tsv("brit_chr3_vqtl.vqtl")
ch1 <- bind_rows(chr1,chr2,chr3)
final1 <- filter(ch1, P < 0.05)

#chunk2
chr4 <- read_tsv("brit_chr4_vqtl.vqtl")
chr5 <- read_tsv("brit_chr5_vqtl.vqtl")
chr6<- read_tsv("brit_chr6_vqtl.vqtl")
chr7 <- read_tsv("brit_chr7_vqtl.vqtl")
ch2 <- bind_rows(chr4,chr5,chr6,chr7)
final2 <- filter(ch2, P < 0.05)
#chunk 3
chr8 <- read_tsv("brit_chr8_vqtl.vqtl")
chr9 <- read_tsv("brit_chr9_vqtl.vqtl")
chr10 <- read_tsv("brit_chr10_vqtl.vqtl")
chr11 <- read_tsv("brit_chr11_vqtl.vqtl")
chr12 <- read_tsv("brit_chr12_vqtl.vqtl")
ch3 <- bind_rows(chr8,chr9,chr10,chr11,chr12)
final3 <- filter(ch3, P < 0.05)
# chunk4
chr13 <- read_tsv("brit_chr13_vqtl.vqtl")
chr14 <- read_tsv("brit_chr14_vqtl.vqtl")
chr15 <- read_tsv("brit_chr15_vqtl.vqtl")
chr16 <- read_tsv("brit_chr16_vqtl.vqtl")
chr17 <- read_tsv("brit_chr17_vqtl.vqtl")
ch4 <- bind_rows(chr13, chr14, chr15, chr16, chr17)
final4 <- filter(ch4, P < 0.05)
#chunk5

chr18 <- read_tsv("brit_chr18_vqtl.vqtl")
chr19 <- read_tsv("brit_chr19_vqtl.vqtl")
chr20 <- read_tsv("brit_chr20_vqtl.vqtl")
chr21 <- read_tsv("brit_chr21_vqtl.vqtl")
chr22 <- read_tsv("brit_vqtl_chr22.vqtl")

ch5 <- bind_rows(chr18,chr19,chr20,chr21,chr22)
final5 <- filter(ch5, P < 0.05)


###binding together chunks
nal <- bind_rows(final1,final2,final3,final4,final5)


# write_tsv (nal,"~/uppmax/top10snps_final.txt")


