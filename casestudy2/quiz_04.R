## R4H2O: Data Science for Water Professionals
## Quiz 4: Cleaning data

## 1. You receive a CSV file from a colleague. The first five rows of this data look like the table below. How do you read this CSV file into memory?
library(tidyverse)
read_csv("casestudy2/quiz_04.csv")
read_csv("casestudy2/quiz_04.csv", skip = 1)

## 2. You want to write a single piece of code that reads a CSV file and removes the second column. What is the best way to achieve this?
read_csv("casestudy2/quiz_04.csv", skip = 1) %>% select(-2)

## Employee survey
read_csv("casestudy2/employee_survey.csv") %>% View()
employees <- read_csv("casestudy2/employee_survey.csv", skip = 1)

## 3. How many employees did not consent?
count(employees, consent)

## 4. How many respondents have both engineering and marketing qualifications?
select(employees, engineer, marketing)
count(employees, engineer == 1 & marketing == 1) 

## 5. You want to visualise the number of respondents by department
employees$department

ggplot(employees, aes(department)) +
    geom_bar() + labs(title = "Employees per department type") + 
    theme_bw(base_size = 20)
ggsave("manuscript/resources/08_cleaning/employees.png")

