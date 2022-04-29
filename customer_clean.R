## Cleaning customer survey data
library(readr)
library(dplyr)

# Suburb dimension table
suburbs_dim <- tibble(suburb = 1:3,
                      suburb_name = c("Merton", 
                                      "Tarnstead", 
                                      "Wakefield"))

# Clean data
customers <- read_csv("data/customer_survey.csv")[-1, ] %>%
  type_convert() %>%
  filter(is.na(term)) %>%
  left_join(suburbs_dim) %>% 
  rename(customer_id = V1) %>%
  select(c(1, 52, 21:51, -33))

# Remove helper variable from memory
rm(suburbs_dim)
