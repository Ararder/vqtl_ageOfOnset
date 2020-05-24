#reading in Age of onset data
library(tidyverse)
path <- "~/ukb_phen_fid.phen"
data <- read_tsv(path, col_names = FALSE)
#theme for graph


#filtering NA
clean <- data %>% 
  select(AgeOfOnst = X3) %>% 
  filter(AgeOfOnst != "NA")
#Density graph
clean %>% 
  ggplot(aes(x = AgeOfOnst)) +
  geom_density() +
  my_theme
#histogram
clean %>% 
  ggplot(aes(x = AgeOfOnst)) +
  geom_histogram( color = "#e9ecef", alpha=0.6, position = 'identity', bin = 32) +
  my_theme +
  labs(title = "Age at first depressive episode.",
      x = "Age of Onset",
      y = "Number of individuals")
  


##### joining other data with age of onset.
#Purpose; join age of onset with 

data <- read_delim("ukb22140_180524_f20487-20490.csv", delim = " ")
#reading in data,
data <- data %>% select( IID = eid, hated_by_Family = `20487-0.0`, physical_abuse = `20488-0.0`, 
                                    loved_as_child = `20489-0.0`, sexual_abuse = `20490-0.0`)

#reading in adoption data
adoption <- read_delim("ukb21472_180427_f1767.csv", delim = " ")
#selecting data from first visit. an
adoption <- adoption %>% select( IID = eid, adopted = `1767-0.0`)
join  <- left_join(data, adoption, by = "IID")

#reading in onset data
onset <- read_delim("ukb22140_180524_f20433.csv", delim = " ")
onset <- onset %>% select(IID = eid, onset = `20433-0.0`)
join <- left_join( join, onset, by = "IID")
#writing out the file
?write_tsv
write_tsv(join, "~/phenotype_data" ,col_names = TRUE)
####
## Now i will filter the oringinal dataset to only people with british ancestry.
###
#reading in british ancestry
british <- read_delim("ukb2222_cal_v2_s488364.whiteBrits.ids", delim = " ", col_names = FALSE)

#changing column names
british <- british %>% select( FID = X1, IID = X2)
#reading in the dataset with phenotypes
pheno <- read_tsv("~/phenotype_data")
brit <- british %>% select(IID)
#rows with matching IID in british sample are kept.
joined <- inner_join(pheno, brit, by = "IID")

# rows in british set : 409,703
#rows in joied dataset : 409,692
#i loose 11 observations. i do not know why.
data <- read_tsv("~/uppmax/brit_final.txt")
data







  