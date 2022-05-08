library("readxl") # To read excel files

envDat <- read_excel("_raw/Raw_Env_Data.xlsx")
write.csv(envDat, "data/01_env_load.csv", 
          row.names = FALSE)

OTU <- read_excel("_raw/Raw_OTU_Counts.xls")
write.csv(OTU, "data/01_otu_counts_load.csv",
          row.names = FALSE)

OTU_meta <- read_excel("_raw/Raw_OTU_Meta_Data.xlsx")
write.csv(OTU_meta, "data/01_otu_meta_load.csv",
          row.names = FALSE)

rm(list = c("envDat", "OTU", "OTU_meta"))
