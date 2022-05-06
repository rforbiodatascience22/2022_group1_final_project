library("readxl") # To read excel files

envDat <- read_excel("_raw/Raw_Env_Data.xlsx")
write.csv(envDat, "data/01_Env_Data_load.csv", 
          row.names = FALSE)

OTU <- read_excel("_raw/Raw_OTU_Counts.xls")
write.csv(OTU, "data/01_OTU_Counts_load.csv",
          row.names = TRUE)

OTU_meta <- read_excel("_raw/Raw_OTU_Meta_Data.xlsx")
write.csv(OTU_meta, "data/01_OTU_Meta_Data_load.csv",
          row.names = TRUE)
