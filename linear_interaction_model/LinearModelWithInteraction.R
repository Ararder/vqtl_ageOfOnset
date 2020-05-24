
# In this script i clean up some features of the phenotype data from UKB, and then i run
# the 50 linear models

library(tidyverse)
library(broom)
library(naniar)




data <- read_tsv("~/uppmax/gei_joined_data.txt")
genetic_data <- read_tsv("~/uppmax/top10snps_final.txt")
genetic_data <- genetic_data %>% select(-FID)

#the first dataframe has information about individual ID, sex, 4 trauma measures and adoption.
#genetic data of allele count for 10 snps



#binding together the dataframe by individual ID

gei_data <- inner_join(genetic_data, data, by = "IID")




#remove the HET columns
gei_data <- gei_data %>% 
  select(1,2,4,6,8,10,12,14,16,18,20,22:28)

colnames(gei_data)

#cleaning up non-answers from trauma measures

gei_data <- gei_data  %>%
 replace_with_na(replace = list(hated_by_Family = -818,
                                physical_abuse = -818,
                                loved_as_child = -818,
                                sexual_abuse = -818,
                                adopted = c(-3, -1)))
#score loved as child the reversed way, so the interpretation is the same as the other trauma
# measures.
gei_data <- gei_data %>% 
  mutate(loved_as_child= case_when(loved_as_child  == 0 ~ 4,
                               loved_as_child  == 1 ~ 3,
                               loved_as_child  == 2 ~ 2,
                               loved_as_child  == 3 ~ 1,
                               loved_as_child  == 4 ~ 0))


#normalizing the age of onset data,to mean = 0 and sd = 1

data <- gei_data %>% mutate(onset = scale(onset))


data
             
## The code for the linear models start here.
#Extract two vectors of SNPs, and covariaties, to loop over.
phenotypes <- data %>% 
  select(12:16) %>% 
  colnames()

snps <- data %>% 
  select(2:11) %>% 
  colnames()


#initializing a counting variable, a tibble to store infrormation about which snp and covariate is used
# and list to store each model

c <- 0
tracking <- tibble()
results <- vector("list")

##a nested loop.
#The outer loop is over the 10 SNPs.
#the inner loop fits the model for each of the give environmental measures.
#the tracking variable keeps track of the snp and covariate used in the model

for(i in 1:length(snps)) {
  snp <- snps[i]
  for(f in 1:length(phenotypes)) {
    pheno <- phenotypes[f]
    coefs <- tibble()
    c <- c+1
    model <- lm(data[[17]] ~ data[[snp]] + data[[pheno]] + data[[snp]] * data[[pheno]])
    results[[c]] <- model
    tracking[c,1] <- snp
    tracking[c,2] <- pheno
  }
}



#the results are extracted by looping over the 50 linear models, and for each model extracts the p-value
#of the interaction term.
pvals <- tibble()
for(i in 1:length(results)){

    pvals[i,1:4] <- tidy(results[[i]]) %>% 
    filter(term == "data[[snp]]:data[[pheno]]") %>% 
    select(estimate, std.error, statistic, p.value)

}



#i tidy up the pvalues and add the information about SNP and covariate

final_results <- bind_cols(pvals,tracking)
final_results <- final_results %>% 
  rename(snp = "...1", phenotype = "...2")

plot <- final_results %>% 
  mutate(phenotype = case_when(phenotype == "hated_by_Family" ~ "Felt hated by a family member",
                              phenotype == "loved_as_child" ~ "Felt loved as a child",
                              phenotype == "sexual_abuse" ~ "Sexually abused"))

# A look at the p-value of the interation terms. 

final_results %>% 
  filter(p.value < 0.05) %>% 
  arrange(p.value)




