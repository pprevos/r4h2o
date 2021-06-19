## R4H2O: Data Science for Water Professionals
## Chapter 4: Exploring Data with the Tidyverse Packages

library(tidyverse)

# load data
gormsey <- read_csv("casestudy1/gormsey.csv")

gormsey

names(gormsey)

dim(gormsey)

nrow(gormsey)
ncol(gormsey)

# #xplore
glimpse(gormsey)

View(gormsey)

# Subset
gormsey[, 4:5]
gormsey[12:18, ]
gormsey$Date[1:12]

gormsey[1:10, c("Town", "Result")]

gormsey[nrow(gormsey), ]

# Filter
gormsey[gormsey$Measure == "Turbidity", ]

turbidity <- filter(gormsey, Measure == "Turbidity")

filter(gormsey, Town == "Strathmore" & Measure == "Turbidity" & Result > 1)

nrow(filter(turbidity, Town != "Strathmore" & Result > 0.1))

# Count
table(gormsey$Measure)

turbidity_count <- count(turbidity, Sample_Point)
turbidity_count

length(gormsey$Measure)
unique(gormsey$Measure)
