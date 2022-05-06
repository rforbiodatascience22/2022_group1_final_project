library(tidyverse)

# load data
envDat <- read_csv("data/01_env_load.csv")
OTU <- read_csv("data/01_otu_counts_load.csv")
OTU_meta <- read_csv("data/01_otu_meta_load.csv")

# rename columns
envDat <- envDat %>% 
  rename(dates = "Date (dd.mm.yy)")
OTU_meta <- OTU_meta %>% 
  rename(OTU_id = "OTU id")

# write files
write.csv(envDat, "data/02_env_clean.csv", 
          row.names = FALSE)
write.csv(OTU, "data/02_otu_counts_clean.csv",
          row.names = FALSE)
write.csv(OTU_meta, "data/02_otu_meta_clean.csv",
          row.names = FALSE)
