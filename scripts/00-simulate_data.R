#### Preamble ####
# Purpose: Simulates data for testing and validation
# Author: Aviral Bhardwaj
# Date: 17 April 2024
# Contact: aviral.bhardwaj@mail.utoronto.ca
# License: MIT
# Pre-requisites: None


#### Workspace setup ####
# Load necessary libraries
library(dplyr)
library(tidyr)
library(ggplot2)

# Set seed for reproducibility
set.seed(123)

# Define years
years <- 2001:2021

# Define admission categories
admission_categories <- c("Total, immigrant admission category",
                          "Economic Immigrant, principal applicant",
                          "Economic Immigrant, spouse and dependent",
                          "Immigrants sponsored by family",
                          "Refugee",
                          "Other immigrant")

# Create an empty data frame to store simulated data
simulated_data <- expand.grid(year = years, admission_category = admission_categories)

# Generate random income values
simulated_data$value <- rnorm(nrow(simulated_data), mean = 30000, sd = 5000)


simulated_data$year <- as.factor(simulated_data$year)

# Create ggplot
ggplot(simulated_data, aes(x = year, y = value, color = admission_category)) +
  geom_line() +
  geom_point() +
  labs(title = "Immigrants' Income by Admission Category",
       x = "Year",
       y = "Income (CAD)",
       color = "Admission Category") +
  theme_minimal() +
  theme(legend.position = "right",
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))


# Define income categories
income_categories <- c("< $20,000 (including loss)", 
                       "$20,000 to $39,999", 
                       "$40,000 to $59,999", 
                       "$60,000 to $79,999", 
                       "$80,000 to $99,999", 
                       "$100,000 to $149,999", 
                       "$150,000 and over")

# Define admission categories
admission_categories <- c("Total, immigrant admission category",
                          "Economic Immigrant, principal applicant",
                          "Economic Immigrant, spouse and dependent",
                          "Immigrants sponsored by family",
                          "Refugee",
                          "Other immigrant")

# Create an empty data frame to store simulated data
simulated_data <- data.frame(Characteristic = income_categories)

# Generate random income values for each admission category
for (category in admission_categories) {
  simulated_data[category] <- round(runif(length(income_categories), min = 5000, max = 100000), 2)
}
