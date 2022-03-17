## Cleaning customer survey data
library(readr)
library(dplyr)

# Suburb dimension table
suburbs_dim <- tibble(suburb = 1:3,
                      suburb_name = c("Merton", 
                                      "Snake's Canyon", 
                                      "Wakefield"))

# Clean data
customers <- read_csv("casestudy2/customer_survey.csv")[-1, ] %>%
    type_convert() %>%
    filter(is.na(term)) %>% # Remove terminated surveys
    left_join(suburbs_dim) %>% 
    rename(customer_id = V1) %>%
    select(c(1, 52, 21:51, -33))

# Remove subjects with all missing data
missing <- customers %>%
    mutate_at(-1:-2, function(p) is.na(p)) %>% 
    mutate(sum = rowSums(across(where(is.logical)))) %>%
    select(customer_id, sum)

customers <- customers %>%
    left_join(missing) %>%
    filter(sum != 30) %>% 
    select(-sum)

# Remove helper variables
rm(missing, suburbs_dim)
