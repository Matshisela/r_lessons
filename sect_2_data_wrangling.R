# Author: Ntando
# Date: 2025-05-19
# Description: Lesson on data wrangling in R
# Github Link: https://github.com/Matshisela/r_lessons


# Load necessary libraries
library(tidyverse)

# Create a sample data frame
raw_data <- data_frame(
  id = 1:15,
  name = c("Alice", "Bob", "Charlie", "Dana", NA, "Eli", "Frank", "Grace", "Henry", "Ivy", "Jack", "Kara", "Leo", "Mona", "N/A"),
  age = c(25, 34, NA, 45, 52, "Thirty", 29, 37, NA, 22, 43, 31, 28, "unknown", 30),
  gender = c("F", "M", "M", "F", "F", "M", "Male", "Female", "F", "F", "M", "F", "M", NA, "M"),
  income = c(50000, 60000, 55000, 58000, 62000, 48000, NA, 57000, 59000, 51000, "unknown", 63000, 54000, 56000, 52000),
  join_date = c("2020-01-15", "2019-07-30", "2018/06/22", "15-08-2017", NA, "2021-10-10", "2020-05-05", "unknown", "2017-03-18", "2019-12-01", "2022-01-01", "2016-11-11", "2018-08-08", "2023-02-02", "2017-07-07"),
  department = c("HR", "Finance", "HR", "IT", "HR", "finance", "NA", "IT", "Operations", "HR", "HR", "finance", "IT", "HR", "Operations")
)


# 1. Display 
glimpse(raw_data)

# 2. Cleaning Age. Changing Thirty to 30 and changing unknown to NA
clean_df <- raw_data %>% 
  mutate(age = case_when(age == "Thirty" ~30,
                         age == "unknown" ~ NA_real_,
                         T ~ as.numeric(age)))

# 3. Changing Income character column to numeric
clean_df <- clean_df %>% 
  mutate(income = case_when(income == "unknown" ~ NA_real_,
                            T ~ as.numeric(income)))

# 4. Changing Join date to date format

clean_df <- clean_df %>% 
  mutate(join_date = case_when(join_date == "unknown" ~ NA_character_,
                               T ~ as.character(join_date))) %>%
  mutate(join_date = parse_date_time(join_date, orders = c("ymd", "dmy", "mdy")))

# 5. clean the gender column

clean_df <- clean_df %>%
  mutate(gender = case_when(gender == "M" ~ "Male",
                            gender == "F" ~ "Female",
                            T ~ gender))


# 6. Clean the department column
clean_df <- clean_df %>%
  mutate(department = str_(department))
  
  
  mutate(department = case_when(department == "finance" ~ "Finance",
                                department == "HR" ~ "HR",
                                department == "IT" ~ "IT",
                                department == "Operations" ~ "Operations",
                                T ~ NA_character_)) %>%
  mutate(department = str_to_title(department))
