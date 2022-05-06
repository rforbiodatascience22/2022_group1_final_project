library("readxl") # To read excel files
library("tidyverse") # It's just neat


otu <- read_excel("data/MEC-14-1145-OTUtab_piconanopool_subsamp5553_correctversion.xls")
env <- read_excel("data/Env_data_mec-14-1145.xlsx")
tab2 <- read_excel("data/Table_S2_Egge_et_al_2015_jeukmic.xlsx")
tab4 <- read.csv("data/figure4_data.csv", sep =";")
