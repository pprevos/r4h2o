## R4H2O: Data Science for Water Professionals
## Quiz 3: Analysing data

library(tidyverse)
gormsey <- read_csv("casestudy1/gormsey.csv")

## What is the median THM value for all towns in Gormsey?
gormsey_thm <- filter(gormsey, Measure == "THM")
median(gormsey_thm$Result)

## Which town has breached the regulations for THM most often? The limit is 0.25 mg/l.
gormsey_thm_breach <- filter(gormsey_thm, Result > 0.25)
count(gormsey_thm_breach, Town)

## Which sample point has registered the highest level of THM?
sample_points_thm <- group_by(gormsey_thm, Sample_Point)
sample_points_thm_max <- summarise(sample_points_thm,
                                   max_result = max(Result))
filter(sample_points_thm_max, max_result == max(max_result))

## Which town in the Gormsey town shows the highest level of turbidity?
gormsey_turbidity <- filter(gormsey, Measure == "Turbidity")
gormsey_turbidity_town <- group_by(gormsey_turbidity, Town)
max_turbidity <- summarise(gormsey_turbidity_town, Maximum = max(Result))
filter(max_turbidity, Maximum == max(Maximum))

## What is the highest 95th percentile of the turbidity for each zone in the Gormsey system, using the Weibull method?
turbidity_p95 <- summarise(gormsey_turbidity_town, 
                           p95 = quantile(Result, 0.95, method = 6))
mean(turbidity_p95$p95)

## Plot
gormsey_thm <- arrange(gormsey_thm, Date)
plot(gormsey_thm$Date, gormsey_thm$Result,
     pch = 19,
     main = "THM Results, Gormsey",
     xlab = "Date", ylab = "Result")
abline(h = 0.25, col = "red")
