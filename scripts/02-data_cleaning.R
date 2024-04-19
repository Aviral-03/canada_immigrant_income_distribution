#### Preamble ####
# Purpose: Cleans the raw data for analysis
# Author: Aviral Bhardwaj
# Date: 17 April 2024
# Contact: aviral.bhardwaj@mail.utoronto.ca
# License: MIT
# Pre-requisites: 01-download_data.R

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(arrow)
library(styler)

#### Clean data ####

# Load the data
data <- read.csv("../data/raw_data/Immigrants_Income.csv")
data_2021 <- read.csv("../data/raw_data/2021_census.csv")


# Adjusting and cleaning the name of the variable
cleaned_data <- data %>% 
  clean_names() %>% 
  clean_names(case = "snake")

cleaned_data <- cleaned_data |>
  select(
    ref_date, immigrant_admission_category, statistics, value 
  )

# Rename the columns
cleaned_data <- cleaned_data |>
  rename(
    year = ref_date,
    admission_category = immigrant_admission_category,
    statistics = statistics,
    value = value
  )

selected_categories <- c("Total, immigrant admission category",
                         "Economic Immigrant, principal applicant",
                         "Economic Immigrant, spouse and dependent",
                         "Immigrants sponsored by family",
                         "Refugee",
                         "Other immigrant")


## Keep row from 232 to 239
data_2021 <- rbind(data_2021[231, ], data_2021[233:237, ])

## Only Keep the required columns
data_2021 <- data_2021 |>
  select(Characteristic, Less.than..20.000..including.loss., X.20.000.to..39.999, X.40.000.to..59.999, X.60.000.to..79.999, X.80.000.to..99.999, X.100.000.to..149.999, X.150.000.and.over) |>
  rename(
    "< $20,000 (including loss)" = Less.than..20.000..including.loss.,
    "$20,000 to $39,999" = X.20.000.to..39.999,
    "$40,000 to $59,999" = X.40.000.to..59.999,
    "$60,000 to $79,999" = X.60.000.to..79.999,
    "$80,000 to $99,999" = X.80.000.to..99.999,
    "$100,000 to $149,999" = X.100.000.to..149.999,
    "$150,000 and over" = X.150.000.and.over
  ) 

# Transpose the dataframe
transposed_data <- t(data_2021)

# Set the column names to be the first row of the transposed data
colnames(transposed_data) <- transposed_data[1, ]

# Remove the first row (which is now the column names)
transposed_data <- transposed_data[-1, ]

# Convert row names to a new column "Characteristic"
transposed_data <- data.frame(Characteristic = rownames(transposed_data), transposed_data, row.names = NULL)

# Reset row names to NULL
rownames(transposed_data) <- NULL

# Rename the columns
data_2021 <- transposed_data |>
  rename(
    Income = Characteristic,
    "Total, immigrant admission category" = Total...Admission.category.and.applicant.type.for.the.population.in.private.households...25..sample.data,
    `Economic Immigrant, principal applicant` = X....Principal.applicants,
    `Economic Immigrant, spouse and dependent` = X....Secondary.applicants,
    `Immigrants sponsored by family` = X..Immigrants.sponsored.by.family,
    `Refugee` = X..Refugees,
    `Other immigrant` = X..Other.immigrants
  )

#Write the data to a csv file
write.csv(data_2021, "../data/analysis_data/2021_Income_Groups.csv", row.names = FALSE)
write_parquet(data_2021, "../data/analysis_data/2021_Income_Groups.parquet")
write.csv(cleaned_data, "../data/analysis_data/cleaned_data.csv", row.names = FALSE)
write_parquet(cleaned_data, "../data/analysis_data/cleaned_data.parquet")

