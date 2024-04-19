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

admission_category_mult_regression <-
  stan_glm(
    Total_count ~ Total_with_income + Median_income,
    data = model_data,
    family = gaussian(),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 853
  )


prior_summary(admission_category_poission)
prior_summary(admission_category_mult_regression)

# Save the model
save(admission_category_poission, file = "models/admission_category_poission.rds")

# Save the model
save(admission_category_mult_regression, file = "models/admission_category_mult_regression.rds")




```{r}
#| echo: false
#| eval: true
#| label: fig-modelresultsfig
#| warning: false


# Plot the model results
pp_check(admission_category_neg_binomial) + 
  theme_minimal() + 
  theme(legend.position = "bottom") +
  ggtitle("Posterior Predictive Check for Negative Binomial Regression Model")

# Prior predictive check
posterior_vs_prior(admission_category_neg_binomial) +
  theme_minimal() +
  theme(legend.position = "bottom") + 
  coord_flip()

```




```{r}

# Plot the model results
pp_check(admission_category_poission) + 
  theme_minimal() + 
  theme(legend.position = "bottom")

# Prior predictive check
posterior_vs_prior(admission_category_poission) +
  theme_minimal() +
  theme(legend.position = "bottom") + 
  coord_flip()

```


```{r}
# #| echo: false
# #| eval: true
# #| label: tbl-modelresults
# #| tbl-cap: "Total Immigrants Explantory Model Results with Variables of Interest"
# #| warning: false
# 
# modelsummary(poisson_model, stars = TRUE, statistic = 'conf.int', conf_level = 0.95, fmt = 2)
# modelsummary(multiple_regression_model, stars = TRUE, statistic = 'conf.int', conf_level = 0.95, fmt = 2)

```
