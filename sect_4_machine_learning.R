# Author: Ntando
# Date: 2025-06-05
# Description: Tidymodels tutorial using the Abalone dataset
# Github Link: https://github.com/your_repo

# Load necessary libraries
library(tidymodels) # Package for modeling and machine learning
library(tidyverse) # Data cleaning & EDA
library(janitor) # Cleaning variables

# Load the Abalone dataset
url <- "https://raw.githubusercontent.com/TheBabu/Abalone-Machine-Learning/refs/heads/master/abalone.csv"

abalone_df <-  read_csv(url) %>% 
  clean_names()

# Display variable names and structure
abalone_df %>% 
  glimpse()


# Data preprocessing ------------------------------------------------------

# Checking missing
abalone_df %>% 
  summarise(across(everything(), ~ sum(is.na(.))))


# Perfoming EDA vs target variable rings

# Visualizing the distribution of the target variable
abalone_df %>% 
  ggplot(aes(x = rings)) +
  geom_histogram(bins = 30, fill = "#b7950b", color = "black") +
  labs(title = "Distribution of Rings", x = "Rings", y = "Count") +
  theme_bw()

# visualizing the relationship between rings and other variables
abalone_df %>% 
  ggplot(aes(x = length, y = rings)) +
  geom_point(color = "#922b21") +
  labs(title = "Rings vs Length", x = "Length", y = "Rings") +
  theme_minimal()

# Visualize the relationship between rings and diameter colored by sex
abalone_df %>% 
  ggplot(aes(x=diameter, rings, color = sex, shape = sex)) +
  geom_point() +
  labs(title = "Rings vs Diameter by Sex", x = "Diameter", y = "Rings") +
  theme_minimal() +
  scale_color_brewer(palette="Dark2")


# Data splitting ---------------------------------------------------------

set.seed(42)

data_split <- initial_split(abalone_df, 
                            prop = 0.8, #0.75. 
                            strata = rings)

train_data <- training(data_split)
test_data <- testing(data_split)

# Display the dimensions of the training and testing sets
dim(train_data)
dim(test_data)

# Preprocessing recipe ---------------------------------------------------

abalone_recipe <- recipe(rings ~ ., data = train_data) %>%
  step_normalize(all_numeric_predictors()) %>%  # Normalize numeric predictors
  step_dummy(all_nominal_predictors(), one_hot = TRUE) #%>%   # One-hot encode categorical variables
  # step_zv(all_predictors()) %>%  # Remove zero-variance predictors
  # step_nzv(all_predictors()) %>%  # Remove near-zero variance predictors
  # step_rm(id)  # Remove the id column if present



# Display the recipe
abalone_recipe %>% 
  prep() %>% 
  bake(new_data = NULL) %>% 
  glimpse()

# Model specification ----------------------------------------------------
# Specify a linear regression model
abalone_model_lin <- linear_reg() %>%
  set_engine("lm")

# Specify a kNN model (optional, for comparison)
abalone_model_knn <- nearest_neighbor() %>%
  set_engine("kknn") %>%
  set_mode("regression")


# Create a workflow combining the recipe and model
abalone_workflow_lin <- workflow() %>%
  add_recipe(abalone_recipe) %>%
  add_model(abalone_model_lin)

abalone_workflow_knn <- workflow() %>%
  add_recipe(abalone_recipe) %>%
  add_model(abalone_model_knn)

# Train the model --------------------------------------------------------
# Fitting linear regression model
abalone_fit_lin <- abalone_workflow_lin %>%
  fit(data = train_data)

# Fitting knearest neighbors model (optional)
abalone_fit_knn <- abalone_workflow_knn %>%
  fit(data = train_data)

# Display the fitted model
abalone_fit_lin %>% 
  extract_fit_parsnip() %>% 
  summary()


# Display the fitted kNN model (optional)
abalone_fit_knn <- abalone_fit_knn %>%
  fit(data = train_data)

# Display the fitted kNN model
abalone_fit_knn %>% 
  extract_fit_parsnip() %>% 
  summary()

# Make predictions on the test set --------------------------------------
# Make predictions using the linear regression model
abalone_predictions_lin <- abalone_fit_lin %>%
  predict(new_data = test_data) %>%
  bind_cols(test_data)

# Make predictions using the kNN model (optional)
abalone_predictions_knn <- abalone_fit_knn %>%
  predict(new_data = test_data) %>%
  bind_cols(test_data)

# Display the predictions
abalone_predictions_lin %>% 
  select(rings, .pred) %>% 
  head()

# Display the kNN predictions (optional)
abalone_predictions_knn %>% 
  select(rings, .pred) %>% 
  head()

# Evaluate the model performance ----------------------------------------

# Calculate evaluation metrics for the linear regression model
abalone_metrics_lin <- abalone_predictions_lin %>%
  metrics(truth = rings, estimate = .pred)

# Calculate evaluation metrics for the kNN model (optional)
abalone_metrics_knn <- abalone_predictions_knn %>%
  metrics(truth = rings, estimate = .pred)

# Display the evaluation metrics
abalone_metrics_lin %>% 
  mutate(across(where(is.numeric), round, 2)) %>%
  arrange(desc(.estimate))

# Display the kNN evaluation metrics (optional)
abalone_metrics_knn %>% 
  mutate(across(where(is.numeric), round, 2)) %>%
  arrange(desc(.estimate))

# Visualize the predictions vs actual values
abalone_predictions_lin %>% 
  ggplot(aes(x = rings, y = .pred)) +
  geom_point(color = "#1f77b4") +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Predicted vs Actual Rings", x = "Actual Rings", y = "Predicted Rings") +
  theme_minimal() +
  coord_fixed()

# Visualize the kNN predictions vs actual values (optional)
abalone_predictions_knn %>% 
  ggplot(aes(x = rings, y = .pred)) +
  geom_point(color = "#f39c12") +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "blue") +
  labs(title = "KNN Predicted vs Actual Rings", x = "Actual Rings", y = "Predicted Rings") +
  theme_minimal() +
  coord_fixed()

# Save the model for future use
saveRDS(abalone_fit_lin, "output/abalone_model_lin.rds")

# Save the kNN model (optional)
saveRDS(abalone_fit_knn, "output/abalone_model_knn.rds")


# Load the model later using:
# abalone_fit_lin <- readRDS("abalone_model_lin.rds")

# Conclusion -------------------------------------------------------------
# This tutorial demonstrated how to use the Tidymodels framework to build a linear regression model on the Abalone dataset.
# The steps included data preprocessing, model training, prediction, and evaluation.
# The model can be saved and loaded for future use, allowing for easy deployment and reuse.
# Further improvements could include hyperparameter tuning, cross-validation, and exploring more complex models.
# Additional resources for Tidymodels:
# - Tidymodels documentation: https://www.tidymodels.org/
# - Tidymodels tutorials: https://www.tidymodels.org/start/
# - Abalone dataset documentation: https://archive.ics.uci.edu/ml/datasets/abalone
