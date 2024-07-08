##########################################
#
# R4H2O: 7: CLEANING CUSTOMER SURVEY DATA
#
##########################################

# Load and explore the data

library(readr)
library(dplyr)

rawdata  <- read_csv("data/customer_survey.csv")

glimpse(rawdata)

# Convert data types

customers <- rawdata[-1, ]

glimpse(customers)

customers <- type_convert(customers)

# Select relevant variables

names(customers)

customers <- select(customers, c(1, 15, 19, 21:51, -33))

# Rename first variable

customers <- rename(customers, customer_id = V1)

glimpse(customers)

# Join dimension table with suburb names

suburbs_dim <- tibble(suburb = 1:3,
                      suburb_name = c("Merton", "Tarnstead", "Wakefield"))

customers <- left_join(customers, suburbs_dim)

customers <- left_join(customers, suburbs_dim, join_by(suburb == suburb))

customers <- select(customers, -"suburb")

# Remove invalid data

count(customers, term)

customers <- filter(customers, is.na(term))
customers <- select(customers, -"term")

# Refactoring code

# Inefficient Method
rawdata  <- read_csv("data/customer_survey.csv")
customers <- rawdata[-1, ]
customers <- type_convert(customers)
customers <- select(customers, c(1, 15, 19, 21:51, -33))
customers <- rename(customers, customer_id = V1)
customers <- left_join(customers, suburbs_dim)
customers <- select(customers, -"suburb")
customers <- filter(customers, is.na(term))
customers <- select(customers, -"term")

# Refactoring using nested functions (Excel method)

customers <- rename(
  select(
    rename(
      left_join(
        filter(
          type_convert(rawdata[-1, ]),
          is.na(term)), 
        suburbs_dim), 
      customer_id = V1), 
    c(1, 52, 21:51, -33)))

# Refactoring using Tidyverse pipes

customers <- rawdata[-1, ] %>%
  type_convert() %>%
  filter(is.na(term)) %>%
  left_join(suburbs_dim) %>% 
  rename(customer_id = V1) %>%
  select(c(1, 52, 21:51, -33))

# Data cleaning workflow

# Write clean data to disk

write_csv(customers, "data/customer_survey_clean.csv")

# Create data cleaning script: 07-customer-clean.R

# Dealing with missing data

# Technical Service Quality

technical_quality <- select(customers, customer_id, t01:t05)
summary(technical_quality[, -1])

# Visualise missing data

library(visdat)
vis_miss(technical_quality)

# Calculate with missing data

mean(technical_quality$t01)

mean(technical_quality$t01, na.rm = TRUE)

mean(na.omit(technical_quality$t01))

# Remove missing data in technical_quality

technical_quality <- technical_quality[complete.cases(technical_quality), ]

# Convert technical_quality to a tidy data set

library(tidyr)
tq_long <- pivot_longer(technical_quality, cols = -1, 
                        names_to = "Item", 
                        values_to = "Response")

library(ggplot2)

ggplot(tq_long, aes(Item, Response)) +
  geom_boxplot() +
  scale_y_continuous(breaks = 1:7) + 
  labs(title = "Technical Service Quality",
       subtitle = "Tap water in Gormsey")

