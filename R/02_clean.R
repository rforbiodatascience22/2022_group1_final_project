library(tidyverse)

# load data
envDat <- read_csv("data/01_env_load.csv", col_types = "c") %>% 
  rename(dates = "Date (dd.mm.yy)") 

OTU <- read_csv("data/01_otu_counts_load.csv")

OTU_meta <- read_csv("data/01_otu_meta_load.csv")


# write files
write.csv(envDat, "data/02_env_load.csv", 
          row.names = FALSE)
write.csv(OTU, "data/02_otu_counts_load.csv",
          row.names = TRUE)
write.csv(OTU_meta, "data/02_otu_meta_load.csv",
          row.names = TRUE)
