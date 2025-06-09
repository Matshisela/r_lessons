# Author: Ntando
# Date: 2025-06-09
# Description: A tutorial on webscraping using rvest
# Github Link: https://github.com/your_repo

# Load necessary libraries
library(rvest) # Load the rvest package for web scraping
library(dplyr) # Load dplyr for data manipulation
library(readr)
library(janitor) # Load tibble for creating data frames

# Website to scrape
url <- "https://www.zimauto.co.zw/cars/for-sale" # Replace with the actual URL

# car name

car_name <- read_html(url) %>%
  html_nodes(".car-title") %>% # Replace with the actual CSS selector for car names
  html_text2() 

car_model_year <- read_html(url) %>%
  html_nodes(".year") %>% # Replace with the actual CSS selector for car model years
  html_text2()

car_price <- read_html(url) %>%
  html_nodes(".car-price") %>% # Replace with the actual CSS selector for car prices
  html_text2()

location <- read_html(url) %>%
  html_nodes(".location") %>% # Replace with the actual CSS selector for locations
  html_text2()


# Combine the scraped data into a data frame
car_data <- tibble(
  Car_Name = car_name,
  Model_Year = car_model_year,
  Price = car_price,
  Location = location
) %>% 
  mutate(
    Price = parse_number(Price) # Convert price to numeric
  )



# Webscraping US presidents

presidents_url <- "https://en.wikipedia.org/wiki/List_of_presidents_of_the_United_States"


presidents_data <- read_html(presidents_url) %>%
  html_nodes("table.wikitable") %>% # Select the table with class 'wikitable'
  html_table(fill = TRUE) %>% # Convert the HTML table to a data frame
  .[[1]] %>%  # Extract the first table
  clean_names()# Clean column names
