
# 
# Contains the code to visualize the results of linear interaction model
# Reqyuires the script LinearModelWithInteractions to be run.



my_theme <- theme(panel.grid = element_blank(), axis.line = element_line(color = "black"),
                  panel.background = element_blank(), axis.text.x = element_text(color = "black"), 
                  axis.text.y = element_text(color = "black"))




plot <- final_results %>% 
  mutate(phenotype = case_when(phenotype == "hated_by_Family" ~ "Felt hated by a family member",
                               phenotype == "loved_as_child" ~ "Felt loved as a child",
                               phenotype == "sexual_abuse" ~ "Sexually abused"))

plot %>% 
  arrange(p.value) %>% 
  filter(p.value < 0.05) %>% 
  ggplot(aes(y = -log10(p.value), x = snp, color = phenotype)) +
  geom_hline(aes(yintercept = -log10(0.05/50)), color = "red", linetype = 5) +
  geom_point() +
  my_theme +
  scale_y_continuous(limits = c(-log10(0.05) ,-log10(0.05/100)) ) +
  theme(legend.key = element_blank(), legend.title = element_blank()) +
  theme(axis.text.x = element_text(angle = 45)) +
  theme( axis.text.x = element_text(size = 7)) +
  labs( x = "", y = "-log10(P)")


    





