# Zizi
#Libraries:
library(tidyverse)
library(tibble)
library(RColorBrewer)
library(ggrepel)
library(vegan)

#nmds data analysis
OTU.zeroReplaced <- read.csv("data/03_otu_counts_zeroReplaced_aug.csv")
OTU_meta <- read.csv("data/02_otu_meta_clean.csv")
envDat <- read.csv("data/02_env_clean.csv")
m_com = as.matrix(OTU.zeroReplaced)
set.seed(123)
nmds = metaMDS(m_com, k = 2, distance = "bray")

nmscore <- as.data.frame(do.call(rbind, scores(nmds)))

nmsites <- nmscore %>% 
  slice(1:156)
sites_group <- OTU_meta %>% select(Group)
nmsites <- cbind(nmsites, sites_group)
nmsites <- nmsites %>%
  mutate(Group = str_replace(Group, "Haptophyta[\\s\\S]+", "HAP\\-4")) %>% 
  mutate(Group = str_replace(Group, "HAP\\-[345]", "HAP\\-3\\-4\\-5")) %>% 
  mutate(Group = str_replace(Group, "Prymnesiales[\\s\\S]+", "Prymnesiophyceae")) %>%
  mutate(Group = str_replace(Group, "Prymnesiophyceae[\\s\\S]+", "Prymnesiophyceae"))

nmspecies <- nmscore %>% 
  slice(157:177) %>%
  mutate(oeder = 1:21)
#nmds plot
p1 <- ggplot() + 
  geom_point(data = nmsites,
             mapping = aes(x = NMDS1, y = NMDS2,
                           color = Group)) +
  ggplot2::geom_path(data = nmspecies,
                     aes(x = NMDS1, y = NMDS2, linetype = "dashed"),
                     alpha = 0.3,
                     show.legend = F) +
  geom_text(data = nmspecies,
            aes(x = NMDS1, y = NMDS2, label = row.names(nmspecies)),
            size = 2.5) +
  labs(x = 'NMDS1',
       y = 'NMDS2') +
  theme_bw() +
  theme(legend.title=element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_rect(colour = "black", size=1))

ggsave("results/07_nmds.png",
       plot = p1,
       width = 20,
       height = 14,
       units = "cm")

#annual light–temperature cycle data analysis
temp_par = envDat %>% 
  select(dates,PAR.avg10, Temp.mean) %>% 
  mutate(month = c("09","10","11","12","01","02","03","04","05","06","08",'09','10','11','12','01','02','03','04','05','06'),
         year = c('2009','2009','2009','2009','2010','2010','2010','2010','2010','2010','2010','2010','2010','2010','2010','2011','2011','2011','2011','2011','2011'))

#annual light–temperature cycle plot
p2 <- ggplot(temp_par, aes(x = PAR.avg10, y = Temp.mean, linetype = year)) +
  geom_point(aes(color = year), size = 3, show.legend = F) +
  geom_label_repel(aes(label = month),
                   box.padding   = 0.35, 
                   point.padding = 0.5,
                   segment.color = 'grey50',
                   show.legend = F) +
  geom_path(aes(group = year)) +
  labs(x = expression('Photosynthetically active radiation [mol/m'^2*'/day]'),
       y = 'Temperature in mixed layer [ °C]') +
  theme_bw() +
  theme(legend.title=element_blank(),
        legend.position = c(.95, .35),
        legend.justification = c("right", "top"),
        legend.box.just = "right",
        legend.margin = margin(6, 6, 6, 6),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_rect(colour = "black", size=1))

ggsave("results/07_annual_light_temperature_cycle.png",
       plot = p2,
       width = 20,
       height = 14,
       units = "cm")

rm(list = ls())
