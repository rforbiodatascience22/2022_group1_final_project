library(tidyverse)
 
#### Model ####
mathias.dat <- read.csv("data/02_env_clean.csv") %>%
  select(contains("mean")) %>% 
  mutate(across(.fns = as.numeric)) %>% 
  pivot_longer(cols = -Temp.mean,
               names_to = "parameter",
               values_to = "value") %>% 
  select(parameter, 
         temperature = Temp.mean,
         value)


  
