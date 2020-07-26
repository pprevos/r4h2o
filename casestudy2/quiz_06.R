## R4H2O: Data Science for Water Professionals
## Quiz 6

library(tidyverse)
customers <- read_csv("casestudy2/customer_survey_clean.csv")

## Question 1
cor(customers$hardship, customers$contact, use = "complete.obs")

## Question 1  
cor.test(customers$hardship, customers$contact, use = "complete.obs")

## Question 3
quality <- select(customers, starts_with("t") | starts_with("f")) %>%
  filter(complete.cases(.)) 

clust <- t(quality) %>%
  scale() %>%
  dist() %>%
  hclust()

plot(clust)

## Question 4
scores <- customers %>%
  select(survey_id, starts_with("t")) %>%
  mutate(Score = t01 + t02 + t03 + t04 + t05) 

mean(scores$Score, na.rm = TRUE)

5 * 4
