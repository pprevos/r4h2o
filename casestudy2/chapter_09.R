## R4H2O: Data Science for Water Professionals
## Chapter 9: Explore the Customer Experience

## Read data
library(readr)
library(tibble)
customers <- read_csv("casestudy2/customer_survey_clean.csv")
glimpse(customers)

## Personal Involvement Inventory
library(dplyr)
pii <- select(customers, survey_id, starts_with("p")) %>%
    mutate(p01 = 8 - p01,
           p02 = 8 - p02,
           p07 = 8 - p07,
           p08 = 8 - p08,
           p09 = 8 - p09,
           p10 = 8 - p10)

select(customers, survey_id, p01:p10) #Alternative method

## Missing data
summary(pii[ , -1])

mean(pii$p01)
mean(pii$p01, na.rm = TRUE)

## Pivot data
library(tidyr)
lab_wide <- tibble(Sample = c("S1234", "S1235", "S1236"),
                   Date = as.Date(c("2017-12-13", "2017-12-14", "2017-12-15")),
                   Turbidity = c(0.05, 0.1, 0.23),
                   THM = c(0.12, 0.07, 0.21),
                   E.coli = c(0, NA, 0))
lab_wide
pivot_longer(lab_wide, cols = -1:-2, names_to = "Analyte", values_to = "Result") %>%
    filter(!is.na(Result))

## Pivot PII data
pii_long <- pivot_longer(pii, -survey_id, names_to = "Item", values_to = "Response") %>%
    filter(!is.na(Response))
pii_long
write_csv(pii_long, "casestudy2/pii_long.csv")

## Visualise responses
library(ggplot2)
ggplot(pii_long, aes(Item, Response)) +
    geom_boxplot(fill = "dodgerblue") +
    labs(title = "Personal Involvement Inventory items",
         subtitle = "Tap water") +
    theme_minimal(base_size = 10)
ggsave("manuscript/resources/09_customers/pii-responses.png", width = 9, height = 5)

ggplot(pii_long, aes(Response, fill = Item)) +
    geom_bar() +
    facet_wrap(~Item)
