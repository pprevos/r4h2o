# Case Study 1a

# Load data
library(tidyverse)
gormsey <- read_csv("casestudy1/gormsey.csv")

# Explore data
names(gormsey)
dim(gormsey)
ncol(gormsey)
nrow(gormsey)

head(gormsey)
str(gormsey)
glimpse(gormsey)

# Select data
gormsey[12:13, ]
gormsey[, 4:5]
gormsey[1:2, c(2, 4:5, 6)]
gormsey[1:2, c(-1, -3, -7)]
gormsey$Date[1:6]

# Conditionals
gormsey$Measure == "Turbidity" & gormsey$Result > 5

# Filtering
gormsey[gormsey$Measure == "Turbidity", ]

subset(gormsey, Measure == "Turbidity")

library(dplyr)
filter(gormsey, Measure == "Turbidity")

turb5 <- filter(gormsey, Measure == "Turbidity" & Result > 5)

# Counting
length(gormsey$Measure)

unique(gormsey$Measure)

table(gormsey$Measure)

count(gormsey, Measure)

# Questions

# How many turbidity results are lower than 0.1 NTU in strathmore and Snake's Canyon?
turbidity <- filter(gormsey,
                    Measure == "Turbidity" &
                        Result < 0.1 &
                        (Town == "Strathmore" | Town == "Snake's Canyon"))
nrow(turbidity)

# Which sample points had a non-zero E. coli count?
e.coli <- filter(gormsey, Measure == "E. coli" & Result > 0)
e.coli$Sample_Point

# Create a table that counts the number of THM samples per town
thm <- filter(gormsey, Measure == "THM")
count(thm, Town)

# Central tendency
turbidity <- filter(gormsey, Measure == "Turbidity")

mean(turbidity$Result)
sum(turbidity$Result) / length(turbidity$Result)

median(turbidity$Result)

which.max(table(round(turbidity$Result, 1)))

# Dispersion
min(turbidity$Result)
max(turbidity$Result)
range(turbidity$Result)

var(turbidity$Result)
sd(turbidity$Result)

sqrt(sum((turbidity$Result - mean(turbidity$Result))^2) / (length(turbidity$Result) - 1))

IQR(turbidity$Result)
summary(turbidity$Result)
quantile(turbidity$Result)
quantile(turbidity$Result, type = 6, probs = 0.95)

# Grouped Statistics
measures <- group_by(gormsey, Measure)
summarise(measures, max = max(Result))

measures_town <- group_by(gormsey, Measure, Town)
summarise(measures_town,
          Samples = n(),
          Mean = mean(Result),
          Median = median(Result),
          p95 = quantile(Result, type = 6, probs = 0.95))

# Average number of samples taken at the sample points in Gormsey?
sample_points <- count(gormsey, Sample_Point)
mean(sample_points$n)

# Which town has the highest level of average turbidity?
turbidity <- filter(gormsey, Measure == "Turbidity")
turbidity_town <- group_by(turbidity, Town)
turb_town_mean <- summarise(turbidity_town, mean = mean(Result))
filter(turb_town_mean, mean == max(mean))

# Which sample point has breached the maximum value of 0.25 mg/l for THM most often?
thm <- filter(gormsey, Measure == "THM")
count(filter(thm, Result > 0.25), Town)

# What is the highest 95th percentile of the turbidity for each of the towns in Gormsey, using the Weibull method?
p95 <- summarise(turbidity_town, p95 = quantile(Result, type = 6, probs = 0.95))
filter(p95, p95 == max(p95))
