# Chapter 4: Exploring Data with the Tidyverse

# Load data
gormsey <- read.csv("casestudy1/gormsey.csv")

gormsey

# Reading tibbles
library(tidyverse)
gormsey <- read_csv("casestudy1/gormsey.csv")

gormsey

# Reading spreadsheets
library(readxl)
gormsey <- read_excel("casestudy1/gormsey.xlsx", skip = 2, sheet = "data")

# Exploring database
head(gormsey)
tail(gormsey)

names(gormsey)
dim(gormsey)

nrow(gormsey)
ncol(gormsey)

glimpse(gormsey)
str(gormsey)

# Exploring content
gormsey[1:2, 1:2]
gormsey[1:2, ]
gormsey[, 1:2]
gormsey$Date[1:2]

gormsey$Sample_No[nrow(gormsey)]

gormsey[gormsey$Measure == "Turbidity", ]

a <- 1:2
a == 1

a <- c(TRUE, FALSE)
a * 2

turbidity <- filter(gormsey, Measure == "Turbidity")

nrow(filter(gormsey, Town != "Strathmore" & Measure == "Turbidity", Result < 0.1))

# Counting
unique(gormsey$Measure)

table(gormsey$Measure)

table(gormsey$Town, gormsey$Measure)

count(gormsey, Town, Measure, name = "Samples")

turbidity <- filter(gormsey, Measure == "Turbidity")
turbidity_count <- count(turbidity, Town, name = "Samples")
turbidity_count

# Case study 1 questions
ecoli <- filter(gormsey, Measure == "E. coli" & Result > 0)
count(ecoli, Town)
count(filter(gormsey, Measure == "E. coli" & Result > 0), Town)

samples <- count(gormsey, Sample_Point, name = "Samples")
filter(samples, Samples == max(Samples))
arrange(samples, desc(Samples))
top_n(samples, 3)

length(unique(gormsey$Date))
nrow(distinct(gormsey, Date))
