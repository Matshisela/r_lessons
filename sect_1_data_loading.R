# Author: Ntando
# Date: 2025-05-19
# Description: Loading data examples
# Github Link: https://github.com/your_repo

library(tidyverse)

# reading data from a CSV file
library(readr)
data <- read_csv("data.csv")

data <- read.table("data/Document.txt", 
                   header = TRUE,
                   sep = ",")

# Read csv
csv_data <- read_csv("data/2017_Yellow_Taxi_Trip_Data.csv")


# reading data from spss
spss_data <- haven::read_sav("data/drama3categories.sav")  
  

# reading data from Stata
stata_data <- haven::read_dta("data/drama3categories.dta")

# reading data from Excel
library(readxl)
excel_data <- read_excel("data/drama3categories.xlsx", 
                           sheet = "Sheet1",
                         skip = 4)

# reading data from JSON
library(jsonlite)
json_data <- fromJSON("data/drama3categories.json")

# reading data from RData
load("data/drama3categories.RData")

# reading data from RDS
rds_data <- readRDS("data/drama3categories.rds")

# reading data from Feather
library(arrow)
feather_data <- read_feather("data/drama3categories.feather")

# reading data from Parquet
parquet_data <- read_parquet("data/drama3categories.parquet")

# reading data from SQL
library(DBI)
library(RSQLite)
con <- dbConnect(RSQLite::SQLite(), "data/drama3categories.db")

