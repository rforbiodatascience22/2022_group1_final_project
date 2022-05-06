library(tidyverse)
 
## Reading cleaned data
envDat <- read.csv("data/02_env_clean.csv")
OTU <- read.csv("data/02_otu_counts_clean.csv") %>% 
  mutate(across(-OTU_id, ~as.numeric(.)))
OTU_meta <- read.csv("data/02_otu_meta_clean.csv")

#### Data for 04_analysis_i.R ####
envData.filtered <- envDat %>% 
  select(-PAR.samplingdate,
         -TotP.1m,
         -TotP.mean,
         -Density.1m,
         -Density.mean,
         -Synechococcus,
         -Virus1,
         -Virus2,
         -Virus3,
         -Large.virus.2.3.,
         -Secchi,
         -Light.1.,
         -Zmix,
         -daylength) %>% 
  #manipulate values to appropriate x-axis values 
  mutate(#nanoalgae 10^3 cells/mL 
         Nanoalgae = Nanoalgae / 1000,
         #pcioalgage 10^3 cells/mL 
         Picoalgae = Picoalgae / 1000,
         #bacteria 10^6 cells/mL
         Bacteria = Bacteria / 1000000,
         #total virus 10^7 part/mL
         Total.virus = Total.virus / 10000000
         )

envDat.filtered1 <- envData.filtered %>% 
  select(dates,
         PAR.avg10,
         Nanoalgae,
         Picoalgae,
         Bacteria,
         Total.virus)

envDat.filtered1.long <- envDat.filtered1 %>% 
  pivot_longer(cols = -dates,
               names_to = "data",
               values_to = "values") %>% 
  arrange(dates)
  
write.csv(envDat.filtered1.long,
          file = "data/03_env_filtered1_aug.csv",
          row.names = FALSE)

envDat.filtered2 <- envData.filtered %>% 
  select(-PAR.avg10,
         -Nanoalgae,
         -Picoalgae,
         -Bacteria,
         -Total.virus)

envDat.filtered2.means <- envDat.filtered2 %>% 
  pivot_longer(cols = contains("mean"),
               names_to = "parameter",
               values_to = "mean") %>% 
  select(dates, 
         parameter, 
         mean) %>% 
  mutate(parameter = str_extract(parameter, 
                                 pattern = "(\\w+)(?=\\.\\w+)")) 

envDat.filtered2.1m <- envDat.filtered2 %>% 
  pivot_longer(cols = contains("1m"),
               names_to = "parameter",
               values_to = "one.m") %>% 
  select(dates, 
         parameter, 
         "one.m") %>% 
  mutate(parameter = str_extract(parameter, 
                                 pattern = "(\\w+)(?=\\.\\w+)")) 

envDat.filtered2.long <- envDat.filtered2.means %>% 
  full_join(envDat.filtered2.1m, by = c("dates", "parameter")) %>% 
  pivot_longer(cols= c(mean, one.m),
               names_to = "type", 
               values_to = "values")%>%
  arrange(dates)

write.csv(envDat.filtered2.long,
          file = "data/03_env_filtered2_aug.csv",
          row.names = FALSE)


#### Data for 05_analysis_ii.R + 06_analysis_iii.R ####
OTU_group = OTU_meta %>%
  select(OTU_id, Group)

OTU.long = OTU_group %>%
  right_join(OTU,
             by = 'OTU_id') %>% 
  pivot_longer(cols = Sep09:June11,
               names_to = "Month",
               values_to = "Count") %>%
  mutate(Group = str_replace(Group, "Haptophyta[\\s\\S]+", "HAP\\-4")) %>% 
  mutate(Group = str_replace(Group, "HAP\\-[345]", "HAP\\-3\\-4\\-5")) %>% 
  mutate(Group = str_replace(Group, "Prymnesiales[\\s\\S]+", "Prymnesiophyceae")) %>%
  mutate(Group = str_replace(Group, "Prymnesiophyceae[\\s\\S]+", "Prymnesiophyceae"))

month_count = OTU.long %>% 
  select(Month, Count) %>% 
  group_by(Month) %>% 
  summarise(Count_month = sum(Count))

OTU.long = OTU.long %>%
  right_join(month_count,
             by = 'Month') %>% 
  ##Calculate frequency
  mutate(Frequency = Count / Count_month)

# Order data
OTU.long.ordered = OTU.long %>% 
  mutate(id = str_replace(OTU_id, "OTU_", "") %>% 
           as.integer()) %>% 
  arrange(id)

write.csv(OTU.long.ordered, 
          file = "data/03_otu_counts_long_aug.csv")

#### Data for 07_analysis_iv.R ####
OTU.zeroReplaced = OTU %>% 
  # Zero replacement
  mutate(across(where(is.numeric), ~case_when(.==0 ~0.005,
                                       TRUE ~.))) %>%
  select(-OTU_id)

write.csv(OTU.zeroReplaced,
          file = "data/03_otu_counts_zeroReplaced_aug.csv",
          row.names = FALSE)

#### Data for 08_analysis_v.R ####
temperature_model_data <- envDat %>% 
  select(contains("mean")) %>% 
  mutate(across(.fns = as.numeric)) %>% 
  pivot_longer(cols = -Temp.mean,
               names_to = "parameter",
               values_to = "value") %>% 
  rename(temperature = Temp.mean)

write.csv(temperature_model_data, "data/03_temp_model_dat_aug.csv", 
          row.names = FALSE)


#### CLEAN UP ####
rm(list = ls())