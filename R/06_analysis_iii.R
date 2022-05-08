library(tidyverse)
library(tibble)
library(RColorBrewer)
library(ggpubr)
library(ggh4x)
library(forcats)

#Open data set
data = read_csv("./data/03_otu_counts_long_aug.csv")

#Order data
data_ordered = data %>% 
  mutate(OTU_id = str_replace(OTU_id, "OTU\\_", "")) %>% 
  mutate(OTU_id = as.integer(OTU_id)) %>% 
  arrange(OTU_id) %>% 
  mutate(OTU_id = as.factor(OTU_id))

#Split data set in two for plotting
data_p1 = data_ordered %>% 
  filter(Group %in% c("Chrysochromulinaceae", "Prymnesiaceae", "Clade D")) %>%
  select(OTU_id, Month, Group, Frequency)

data_p2 = data_ordered %>% 
  filter(Group %in% c("Calcihaptophycidae", "Phaeocystales", "HAP-3-4-5", "Pavlovales", "Prymnesiophyceae")) %>% 
  select(OTU_id, Month, Group, Frequency)

##DATA VISUALIZATION
##Plot 1
#Peronalised strip
perStrip1 = strip_themed(
  #Modify angles of strips
  text_y = elem_list_text(angle = c(270, 0, 270)),
  by_layer_y = "TRUE")

p1 = data_p1 %>%
  ggplot(aes(x = Month,
             y = OTU_id,
             fill = Frequency)) +
  geom_tile(colour = "grey") +
  scale_fill_gradient2(low = "white",
                       mid = "cadetblue",
                       high = "dodgerblue4",
                       midpoint = 0.35,
                       name = "Proportional read abundance",
                       breaks = c(0, 0.2, 0.4, 0.6, 0.8),
                       limits= c(0 ,0.8)) +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, 
                                   hjust = 1,
                                   size = 12),
        axis.text.y = element_text(size = 12),
        legend.position = "bottom",
        panel.grid.minor = element_line(size = 0.25,
                                        linetype = 'solid',
                                        colour = "white"),
        strip.text.y = element_text(angle = 270)) +
  facet_grid2(vars(Group),
              scales = "free",
              space = "free",
              strip = perStrip1) +
  scale_x_discrete(limits = c("Sep09", "Oct09", "Nov09", "Dec09",
                              "Jan10", "Feb10", "Mars10", "Apr10", 
                              "May10", "June10", "Aug10","Sep10",
                              "Oct10", "Nov10", "Dec10", "Jan11",
                              "Feb11", "Mars11", "Apr11", "May11",
                              "June11")) +
  labs(y = "OTU ID")


##Plot 2
#Peronalised strip
perStrip2 = strip_themed(
  #Modify angles of strips
  text_y = elem_list_text(angle = c(270, 270, 0, 270, 270)),
  by_layer_y = "TRUE")

p2 = data_p2 %>%
  ggplot(aes(x = Month,
             y = OTU_id,
             fill = Frequency)) +
  geom_tile(colour = "grey") +
  scale_fill_gradient2(low = "white",
                       mid = "cadetblue",
                       high = "dodgerblue4",
                       midpoint = 0.35,
                       name = "Proportional read abundance",
                       breaks = c(0, 0.2, 0.4, 0.6, 0.8),
                       limits = c(0, 0.8)) +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, 
                                   hjust = 1,
                                   size = 12),
        axis.text.y = element_text(size = 12),
        legend.position = "bottom",
        panel.grid.minor = element_line(size = 0.3,
                                        linetype = 'solid',
                                        colour = "white"),
        strip.text.y = element_text(angle = 270),
        axis.title.y = element_blank()) +
  facet_grid2(vars(Group),
              scales = "free",
              space = "free",
              strip = perStrip2) +
  scale_x_discrete(limits = c("Sep09", "Oct09", "Nov09", "Dec09",
                              "Jan10", "Feb10", "Mars10", "Apr10", 
                              "May10", "June10", "Aug10","Sep10",
                              "Oct10", "Nov10", "Dec10", "Jan11",
                              "Feb11", "Mars11", "Apr11", "May11",
                              "June11"))

#Join plots
heatmap = ggarrange(p1, p2, ncol=2, common.legend = TRUE, legend="bottom")

ggsave("results/06_heatmap.png",
       plot = heatmap,
       width = 30,
       height = 35,
       unit = "cm")
