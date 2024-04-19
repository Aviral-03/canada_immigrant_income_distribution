#### Preamble ####
# Purpose: Tests and validates the data
# Author: Aviral Bhardwaj
# Date: 17 April 2024
# Contact: aviral.bhardwaj@mail.utoronto.ca
# License: MIT
# Pre-requisites: 01-download_data.R, 02-data_cleaning.R



#### Workspace setup ####
library(tidyverse)
library(styler)

#### Test data ####
cleaned_data <- read_csv("../data/cleaned_data.csv")


# Check if statistics are character
class(cleaned_data$statistics) %>% stopifnot(. == "character")

# Check if year is numeric
class(cleaned_data$year) %>% stopifnot(. == "numeric")

# Check if value is numeric
class(cleaned_data$value) %>% stopifnot(. == "numeric")

#Check if admission category is character
class(cleaned_data$admission_category) %>% stopifnot(. == "character")

# Check if year is between 2000 and 2020
cleaned_data %>%
  pull(year) %>%
  range() %>%
  stopifnot(. == c(2000, 2020))

# Check if value is positive or chracter NA
cleaned_data %>%
  pull(value) %>%
  range() %>%
  stopifnot(all(. >= 0) | all(is.na(.)))

# Check if statistics have Total count as a value
cleaned_data %>%
  pull(statistics) %>%
  unique() %>%
  grepl("Total count", .) %>%
  stopifnot(any(.))


# Check if value max is less than 1000000
cleaned_data %>%
  pull(value) %>%
  max() %>%
  stopifnot(. < 1000000)


