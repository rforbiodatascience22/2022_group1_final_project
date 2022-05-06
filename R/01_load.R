library("readxl") # To read excel files
library("tidyverse") # It's just neat

envDat <- read_excel("_raw/Raw_Env_Data.xlsx")
write.csv(envDat, "data/Env_Data.csv", 
          sep = ",", 
          row.names = FALSE)

OTU <- read_excel("_raw/Raw_OTU_Counts.xls")
write.csv(OTU, "data/OTU_Counts.csv",
          sep = ",",
          row.names = TRUE)

OTU_meta <- read_excel("_raw/Raw_OTU_Meta_Data.xlsx")
write.csv(OTU_meta, "data/OTU_Meta_Data.csv",
          sep = ",",
          row.names = TRUE)
