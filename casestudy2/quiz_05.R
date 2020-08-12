## R4H2O: Data Science for Water Professionals
## Quiz 5

library(tidyverse)

## Question 1
lab <- tibble(Date = as.Date(c("2022-12-01", "2022-12-08", "2022-12-15")),
              Sample_Point = rep("S2365", 3),
              Chlorine = c(0.62, 0.34, 1.20), 
              Turbidity = c(0.12, 0.10, 0.80))
lab

## Question 2
pivot_longer(lab, Chlorine:Turbidity, names_to = "Measure", values_to = "Result")

## Question 3
mean(c(100, 50, 25, NA, 25))
mean(c(100, 50, 25, NA, 25), na.rm = TRUE)

## Question 4
read_csv("casestudy2/customer_survey.csv", skip = 1) %>%
    select(hardship, contact) %>%
    pivot_longer(hardship:contact, names_to = "Parameter", values_to = "Response") %>%
    filter(is.na(Response)) %>%
    count()






