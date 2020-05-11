#reading in Age of onset data
library(tidyverse)
path <- "~/ukb_phen_fid.phen"
data <- read_tsv(path, col_names = FALSE)
#theme for graph
my_theme <- theme(panel.grid = element_blank(), axis.line = element_line(color = "black"),
                  panel.background = element_blank(), axis.text.x = element_text(color = "black"), 
                  axis.text.y = element_text(color = "black"))
data
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
  

clean %>% 
  summary() %>% 
clean <- clean %>% 
  arrange(AgeOfOnst)
view(clean)
  
  