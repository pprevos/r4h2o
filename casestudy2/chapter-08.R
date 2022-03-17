# Cleaning data

# Read data
library(tidyverse)
rawdata  <- read_csv("casestudy2/customer_survey.csv")
glimpse(rawdata)

# Convert
customers <- rawdata[-1, ]
customers <- type_convert(customers)
glimpse(customers)

# Extract questions
questions <- rawdata[1, ]
questions <- t(questions)
class(questions)

questions <- tibble(Item = rownames(questions),
                    Question = questions)
questions <- questions[-1:-18, ]

# Remove terminated responses
table(customers$term)

table(customers$term, useNA = "ifany")

count(customers, term)

customers <- filter(customers, is.na(term))

# Rename variable
customers <- rename(customers, customer_id = V1)

names(customers)

customers <- select(customers, c(1, 19:51, -20, -33))

# Join dimension table
suburbs_dim <- tibble(suburb = 1:3,
                      suburb_name = c("Merton", "Snake's Canyon", "Wakefield"))

customers <- left_join(customers, suburbs_dim)
customers <- select(customers, -2)

glimpse(customers)

# Coding efficiently
customers <- rawdata[-1, ]
customers <- type_convert(customers)
customers <- filter(customers, is.na(term))
customers <- left_join(customers, suburbs_dim)
customers <- rename(customers, customer_id = V1)
customers <- select(customers, c(1, 52, 21:51, -33))

# Excel Style
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

# Tidyverse Pipes
customers <- rawdata[-1, ] %>%
  type_convert() %>%
  filter(is.na(term)) %>%
  left_join(suburbs_dim) %>% 
  rename(customer_id = V1) %>%
  select(c(1, 52, 21:51, -33))

# Case study 1 in pipes
gormsey <- read_csv("casestudy1/gormsey.csv")
gormsey_grouped <- group_by(gormsey, Suburb, Measure)
summarise(gormsey_grouped, mean = round(mean(Result), 2))

read_csv("casestudy1/gormsey.csv") %>% 
  group_by(Suburb, Measure)  %>%
  summarise(mean = mean(Result))

# Missing data
select(customers, p01:p04) %>% 
  summary()

pii <- select(customers, customer_id, starts_with("p"))

pii %>% 
  mutate_at(-1, function(p) is.na(p)) %>% 
  pivot_longer(2:11, names_to = "Item", values_to = "Missing") %>% 
  group_by(customer_id) %>% 
  summarise(Missing = sum(Missing)) %>% 
  count(Missing, name = "Respondents")

library(visdat)
vis_miss(customers)

mean(customers$p01)
mean(customers$p01, na.rm = TRUE)

missing <- customers %>%
    mutate_at(-1:-2, function(p) is.na(p)) %>% 
    mutate(sum = rowSums(across(where(is.logical)))) %>%
    select(customer_id, sum)

customers <- customers %>%
    left_join(missing) %>%
    filter(sum != 30) %>%
    select(-sum)

source("casestudy2/customer_clean.R")

# Tidy data
library(tidyr)

customers_long <- pivot_longer(customers, 
                         cols = -1:-2, 
                         names_to = "Item", 
                         values_to = "Response")

library(ggplot2)
library(stringr)

customers_long %>%
    filter(str_detect(Item, "^f")) %>%
    ggplot(aes(Item, Response)) +
    geom_boxplot() +
    scale_y_continuous(breaks = 1:7) + 
    labs(title = "Functional Service Quality",
         subtitle = "Tap water in Gormsey")
