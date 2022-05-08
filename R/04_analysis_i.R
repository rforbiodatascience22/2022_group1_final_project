
#Libraries:
library("tidyverse")
library("patchwork")

#load data 
df1_long <- read.csv("data/03_env_filtered1_aug.csv")
df4 <- read.csv("data/03_env_filtered2_aug.csv")

#LABELS
#labels plot 1 
new_labels <- c("Bacteria" = "Bacteria[106 cells/mL]",
                "Nanoalgae" = "Nanoalgae[103 cells/mL]",
                "PAR.avg10" = "PAR[mol/m2/day]",
                "Picoalgae" = "Picoalgae[103 cells/mL]",
                "Total.virus" = "Virus[107 part./mL]")

#labels plot 2 
new_labels2 <- c("Chla" = "Chl a [Î¼g/L]", "Fluo" = "Fluorescence [RFU]", "Nitr" ="Nitrite+Nitrate [Î¼M]", "Phos"= "Phosphate [Î¼M]", "Sal"= "Salinity [PSU]", "Si"= "Silicate [Î¼M]", "Temp"= "Temperature [Â°C]")

#PLOTTING 
#plot 1 
p1<-ggplot(df1_long, aes(x = dates, y = values, group = 1)) +
  geom_line(data = df1_long %>% filter(is.na(values) == FALSE),
            linetype = "dashed",
            color = "grey",
            size = 0.3) +
  geom_line(color = "black",
            size = 0.5) +
  geom_point(color = "black",
             size = 0.3) +
  facet_wrap(~ data, 
             ncol = 3,
             scales = "free",
             strip.position = "left",
             labeller = as_labeller(new_labels)) +
  theme_classic() +
  theme(axis.title = element_blank(),
        axis.text = element_text(size = 3.5),
        strip.background = element_blank(),
        strip.placement = "outside",
        strip.text.y = element_text(size = 10),
        panel.grid.major.y = element_line(color = "gainsboro",
                                          size = 0.2,
                                          linetype = 1))

#plot 2 
p2<-ggplot(df4, aes(x = dates, y = values, group = 1)) +
  geom_line(data = df4 %>% filter(is.na(values) == FALSE),
            linetype = "dashed",
            color = "grey",
            size = 0.3) +
  geom_line(aes(color = type),
            size = 0.5)+
  scale_colour_manual(values = c(mean = "black",
                                 one.m = "darkred")) +
  geom_point(color = "black",
             size = 0.3) +
  facet_wrap(~ parameter, 
             ncol = 3, 
             scales = "free", 
             strip.position = "left",
             labeller = as_labeller(new_labels2)) +
  theme_classic() +
  theme(legend.title = element_blank(), 
        axis.title = element_blank(),
        axis.text = element_text(size = 3),
        strip.background = element_blank(),
        strip.placement = "outside",
        strip.text.y = element_text(size = 8),
        panel.grid.major.y = element_line(color = "gainsboro",
                                          size = 0.2,
                                          linetype = 1))

#COMBINING Final plot  
p1+plot_annotation(title = "Environmental conditions at station OF-2 in the Skagerrak", 
                   theme = theme(plot.title = element_text(size = 10)))
p2 + plot_annotation(title = "Environmental conditions at station OF-2 in the Skagerrak", 
                     theme = theme(plot.title = element_text(size = 10)))

#save plot 
ggsave("results/04_analysis_i.png",
       plot = p1,
       width = 30,
       height = 20,
       unit = "cm")

ggsave("results/04_analysis_ii.png",
       plot = p2,
       width = 30,
       height = 20,
       unit = "cm")



