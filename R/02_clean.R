library(tidyverse)

# load data
envDat <- read_csv("data/01_env_load.csv", col_types = "c") %>% 
  rename(dates = "Date (dd.mm.yy)") 

OTU <- read_csv("data/01_otu_counts_load.csv") %>% 
  select(-Rownames)

OTU_meta <- read_csv("data/01_otu_meta_load.csv") %>% 
  rename(OTU_id = "OTU id") %>% 
  mutate(OTU_id = OTU_id %>% str_replace(" ", "_"))


# write files
write.csv(envDat, "data/02_env_clean.csv", 
          row.names = FALSE)
write.csv(OTU, "data/02_otu_counts_clean.csv",
          row.names = FALSE)
write.csv(OTU_meta, "data/02_otu_meta_clean.csv",
          row.names = FALSE)

rm(list = c("envDat", "OTU", "OTU_meta"))
