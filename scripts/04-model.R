#### Preamble ####
# Purpose: Model the relationship between Admission Category, Total Income, and Median Income
# Author: Aviral Bhardwaj
# Date: 17 April 2024
# Contact: aviral.bhardwaj@mail.utoronto.ca
# License: MIT
# Pre-requisites: 01-download_data.R, 02-data_cleaning.R, 03-test_data.R


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(styler)

# Style the code:
# style_file("04-model.R")

# Read the data
model_data <- read.csv("../data/analysis_data/cleaned_data.csv")

model_data <- cleaned_data %>%
  filter(statistics %in% c("Median with income", "Total count", "Total with income")) %>%
  filter(admission_category %in% selected_categories) %>%
  filter(admission_category != "Economic Immigrant, principal applicant") %>%
  mutate(admission_category = if_else(admission_category == "Total, immigrant admission category", "Principal applicant", admission_category)) %>%
  group_by(admission_category, year) %>%
  summarise(
    Total_count = value[statistics == "Total count"],
    Total_with_income = value[statistics == "Total with income"],
    Median_income = value[statistics == "Median with income"]
  )


# Fit the model
admission_category_poission <-
  stan_glm(
    Total_count ~ admission_category,
    data = model_data,
    family = poisson(link = "log"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 853
  )



prior_summary(admission_category_poission)

# Save the model
saveRDS(admission_category_poission, file = "../models/admission_category_poission.rds")


