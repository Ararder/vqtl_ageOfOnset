##This script creats graphs for the four measures of trauma used in the linear interaction models



#packages that will be used.
library(tidyverse)
library(broom)
library(naniar)
my_theme <- theme(panel.grid = element_blank(), axis.line = element_line(color = "black"),
                  panel.background = element_blank(), axis.text.x = element_text(color = "black"), 
                  axis.text.y = element_text(color = "black"))


#
data <- read_tsv("~/uppmax/gei_joined_data.txt")

### calculating the average reduction in age of onset per step of trauma severity.
#for individuals that felt that atleast one family member hated them.
data %>% 
  group_by(hated_by_Family) %>% 
  filter(hated_by_Family != "NA") %>% 
  summarise(mean(onset)) %>% 
  mutate(avg =`mean(onset)` - lag(`mean(onset)`)) %>% 
  summarise(mean(avg, na.rm = TRUE))


#Score felt loved as child in reverse - so that a 4 corresponds to not feeling loved at all.
data <- data %>% 
  mutate(rev_loved = case_when(loved_as_child  == 0 ~ 4,
                               loved_as_child  == 1 ~ 3,
                               loved_as_child  == 2 ~ 2,
                               loved_as_child  == 3 ~ 1,
                               loved_as_child  == 4 ~ 0))



#see http://biobank.ndph.ox.ac.uk/showcase/field.cgi?id=20487 for more info about the codes
#cleaning up non-answers from environmnetal covariates.
data <- data %>%
  replace_with_na(replace = list(hated_by_Family = -818,
                                 physical_abuse = -818,
                                 loved_as_child = -818,
                                 sexual_abuse = -818,
                                 adopted = c(-3, -1)))


#---------
# In this part i visualize each of the trauma measures, and how age of onset decreases
# for each step in trauma severity.
#---------
#labels for the x axis.
my_x_labs <- scale_x_discrete(labels = c("Never true", "Rarely true", "Somestimes true", "Often", "Very often true"))
y_scale <-scale_y_continuous(limits = c(0,70))


# graph for feeling hated by family

#calculates mean onset and standard deivation for each step of trauma severity

viz_hated <- data %>% 
  group_by(hated_by_Family) %>% 
  summarise(mean(onset),sd(onset)) %>% 
  rename(hated = hated_by_Family, mean = `mean(onset)`, std = `sd(onset)`)

p_hated <- viz_hated %>% 
  filter(hated != "NA") %>% 
  ggplot(aes(x = factor(hated), y = mean)) +
  geom_point() +
  geom_line(group = 1) +
  geom_errorbar(aes(ymin = (mean-std), ymax = (mean + std) ))



  p_hated <- p_hated +
  my_theme +
  my_x_labs +
  labs(title = "When I was growing up... 
       I felt that someone in my family hated me",
       y = "Mean Age of Onset",
       x = " ")

#
# Physical abuse
#
  
viz_physical <- data %>% 
  group_by(physical_abuse) %>% 
  summarise(mean(onset),sd(onset)) %>% 
  rename(mean = `mean(onset)`, std = `sd(onset)`)

p_physical <- viz_physical %>% 
  filter(physical_abuse != "NA") %>% 
  ggplot(aes(x = factor(physical_abuse), y = mean)) +
  geom_point() +
  geom_line(group = 1) +
  geom_errorbar(aes(ymin = (mean-std), ymax = (mean + std) ))

p_physical <- p_physical +
  my_theme +
  my_x_labs +
  labs(title = "When I was growing up... People in my family 
       hit me so hard that it left me with bruises or marks",
       y = "Mean Age of Onset",
       x = " ")


#
# Sexual abuse
#


viz_sexual_abuse <- data %>% 
  group_by(sexual_abuse) %>% 
  summarise(mean(onset),sd(onset)) %>% 
  rename(mean = `mean(onset)`, std = `sd(onset)`)


p_sexual_abuse <- viz_sexual_abuse %>% 
  filter(sexual_abuse != "NA") %>% 
  ggplot(aes(x = factor(sexual_abuse), y = mean)) +
  geom_point() +
  geom_line(group = 1) +
  geom_errorbar(aes(ymin = (mean-std), ymax = (mean + std) ))

p_sexual_abuse <- p_sexual_abuse +
  my_theme +
  my_x_labs +
  labs(title = "When I was growing up... Someone molested me (sexually)",
       y = "Mean Age of Onset",
       x = " ")


#
#felt loved as child
#



viz_felt_loved <- data %>% 
  group_by(loved_as_child) %>% 
  summarise(mean(onset),sd(onset)) %>% 
  rename(mean = `mean(onset)`, std = `sd(onset)`)


p_felt_loved <- viz_felt_loved %>% 
  filter( loved_as_child != "NA") %>% 
  ggplot(aes(x = factor(loved_as_child), y = mean)) +
  geom_point() +
  geom_line(group = 1) +
  geom_errorbar(aes(ymin = (mean-std), ymax = (mean + std) ))

p_felt_loved <- p_felt_loved +
  my_theme +
  my_x_labs +
  labs(title = "When I was growing up... I felt loved",
       y = "Mean Age of Onset",
       x = "")



# adoption
## graph was not included in the thesis, because barely any difference in age of onset.

viz_adopt <- data %>% 
  group_by(adopted) %>% 
  summarise(mean(onset),sd(onset)) %>% 
  rename(mean = `mean(onset)`, std = `sd(onset)`)

viz_adopt %>% 
  filter( adopted != "NA") %>% 
  ggplot(aes(x = factor(adopted), y = mean)) +
  geom_point() +
  geom_line(group = 1) +
  geom_errorbar(aes(ymin = (mean-std), ymax = (mean + std) ))

