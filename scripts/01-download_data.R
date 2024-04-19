#### Preamble ####
# Purpose: Downloads and saves the data from Statistics Canada
# Author: Aviral Bhardwaj
# Date: 17 April 2024
# Contact: aviral.bhardwaj@mail.utoronto.ca
# License: MIT
# Pre-requisites: None


#### Workspace setup ####
# install.packages("cansim")

library(tidyverse)
library(readxl)
library(styler)
library(cansim)

#### Download data ####

# Download data from Statistics Canada
mydata <- get_cansim("43-10-0010-01")


# Download Census data
url <- "https://www12.statcan.gc.ca/census-recensement/2021/dp-pd/sip/details/download-telecharger/GetFile-Current-Actuelle.cfm?Dguid=2021A000011124&PoiId=5&Lang=E&TId=11&FILETYPE=CSV"
local_file <- tempfile(fileext = ".csv")
download.file(url, local_file, mode = "wb")

census_data <- read_csv(local_file)


#### Save data ####
write_csv(census_data, "../data/raw_data/2021_Census.csv")
write_csv(mydata, "../data/raw_data/Immigrants_Income.csv")




         
