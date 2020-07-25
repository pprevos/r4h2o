## R4H2O: Data Science for Water Professionals
## Chapter 5: Descriptive Statistics

## Load data
library(tidyverse)
gormsey <- read_csv("casestudy1/gormsey.csv")

## Summary of the results
summary(gormsey$Result)

## What is the mean turbidity result in Pontybridge?
turbidity_pontybridge <- filter(gormsey, Town == "Pontybridge" & Measure == "Turbidity")
mean(turbidity_pontybridge$Result)

## Percentiles (quantiles)
quantile(turbidity_pontybridge$Result, 0.95) # 95th percentile
quantile(turbidity_pontybridge$ Result, c(0.50, 0.95)) #50th and 95th percentile

unique(gormsey$Town)

## What is the 33rd percentile for the NTU data in Paethsmouth?
thm_paethsmouth <- filter(gormsey, Town == "Paethsmouth" & Measure == "THM")
quantile(thm_paethsmouth$Result, 0.33)

## Grouped data Example
df <- tibble(Town = rep(c("Bellmoral", "Blancathey", "Merton"), each = 2),
             Measure = rep(c("THM", "Turbidity"), 3),
             Result = runif(6))
df

df_grouped <- group_by(df, Measure)
df_grouped 

summarise(df_grouped,
          Average = mean(Result),
          Maximum = max(Result))

## Mean result per town and per measure
gormsey_grouped <- group_by(gormsey, Town, Measure)
summarise(gormsey_grouped, mean = mean(Result))
