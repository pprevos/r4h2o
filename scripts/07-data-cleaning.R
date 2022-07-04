#########################
# R4H2O: 7: Cleaning data
#########################

# Load and explore the data

library(readr)
library(dplyr)
rawdata  <- read_csv("data/customer_survey.csv")
glimpse(rawdata)

# Convert data types

customers <- rawdata[-1, ]
customers <- type_convert(customers)

glimpse(customers)

# Select relevant variables

names(customers)
customers <- select(customers, c(1, 15, 19, 21:51, -33))

# Rename first variable

customers <- rename(customers, customer_id = V1)

# Join dimension table with suburb names

suburbs_dim <- tibble(suburb = 1:3,
                      suburb_name = c("Merton", "Tarnstead", "Wakefield"))

customers <- left_join(customers, suburbs_dim)
customers <- select(customers, -"suburb")

# Using right-join gives same result when folling variable names

right_join(suburbs_dim, customers)

# Remove invalid data

table(customers$term)

table(customers$term, useNA = "ifany")

customers <- filter(customers, is.na(term))
customers <- select(customers, -"term")

# Refactoring code

# Refactoring using nested functions

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

# Dealing with missing data

# Technical Service Quality

tq <- select(customers, customer_id, t01:t05)
summary(tq[, -1])

# Visualise missing data

library(visdat)
vis_miss(tq)

# Calculate with missing data

mean(tq$t01)

mean(tq$t01, na.rm = TRUE)

mean(na.omit(tq$t01))

# Remove missing data in tq

tq <- tq[complete.cases(tq), ]

# Convert tq to a tidy data set

library(tidyr)
tq_long <- pivot_longer(tq, cols = -1, 
                        names_to = "Item", 
                        values_to = "Response")

library(ggplot2)

ggplot(tq_long, aes(Item, Response)) +
  geom_boxplot() +
  scale_y_continuous(breaks = 1:7) + 
  labs(title = "Technical Service Quality",
       subtitle = "Tap water in Gormsey")
