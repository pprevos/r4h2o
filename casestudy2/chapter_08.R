## R4H2O: Data Science for Water Professionals
## Case Study 2: Chapter 8: Cleaning data

## Load data
library(tidyverse)
rawdata  <- read_csv("casestudy2/customer_survey.csv")

# Show first two columns as data frame
questions <- read_csv("casestudy2/customer_survey.csv", n_max = 2, col_names = FALSE)
questions <- data.frame(t(questions), row.names = NULL)

## Explore data
glimpse(rawdata)
View(rawdata)

## Clean headers
customers <- rawdata[-1, ]
customers <- type_convert(customers)
glimpse(customers)

## Terminated surveys
table(customers$term)
table(customers$term, useNA = "ifany") # Show all NA values

term <- count(customers, term)
ggplot(term, aes(term, n)) +
    geom_col()

## Remove terminated surveys and attention filter
customers <- filter(customers, is.na(term))
nrow(customers)

## Merge town names
table(customers$city)
cities <- tibble(city = 1:3,
                 city_name = c("Merton", "Snake's Canyon", "Wakefield"))
cities
customers <- left_join(customers, cities)

## Remove unwanted columns
names(customers)
customers <- select(customers, c(-2:-20, -33))

## Rename variables
customers <- rename(customers, survey_id = V1)
glimpse(customers)

write_csv(customers, "casestudy2/customer_survey_clean.csv")

## Nested (Excel style)
customers <- rename(select(left_join(filter(type_convert(rawdata[-1, ]), is.na(term)), cities), c(-2:-20, -33)), survey_id = V1)

## Piped
customers <- rawdata[-1, ] %>%
    type_convert() %>%
    filter(is.na(term)) %>%
    left_join(cities) %>% 
    select(c(-2:-20, -33)) %>%
    rename(survey_id = V1)
