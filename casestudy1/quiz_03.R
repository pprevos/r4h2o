## R4H2O: Data Science for Water Professionals
## Quiz 3: Analysing data

library(tidyverse)
gormsey <- read_csv("casestudy1/gormsey.csv")

## What is the median THM value for all towns in Gormsey?
gormsey_thm <- filter(gormsey, Measure == "THM")
median(gormsey_thm$Result)

## Which town has breached the regulations for THM? The limit is 0.25 mg/l.
gormsey_thm_breach <- filter(gormsey_thm, Result > 0.25)
count(gormsey_thm_breach, Town)

## Which town in the Gormsey town shows the highest level of turbidity?
gormsey_turbidity <- filter(gormsey, Measure == "Turbidity")
gormsey_turbidity_town <- group_by(gormsey_turbidity, Town)
max_turbidity <- summarise(gormsey_turbidity_town, Maximum = max(Result))
filter(max_turbidity, Maximum == max(Maximum))

## What is the highest 95th percentile of the turbidity for each zone in the Gormsey system, using the Weibull method?
turbidity_p95 <- summarise(gormsey_turbidity_town, 
                           p95 = quantile(Result, 0.95, method = 6))
mean(turbidity_p95$p95)
