######################################
#
# R4H2O 3 - LOADING AND EXPLORING DATA
#
######################################

# Install packages (only do this once)
# install.packages("tidyverse")

# Reading a CSV file with base R

labdata <- read.csv("data/water_quality.csv")

# Using the readr package from Tidyverse
library(tidyverse)

labdata <- read_csv("data/water_quality.csv")

# Reading Spreadsheet data
# Use ?readxl to learn about options

library(readxl)
labdata <- read_excel("data/water_quality.xlsx",
                      skip = 2, sheet = "data")

# Explore data frames / tibbles
labdata

names(labdata) # Variable names

dim(labdata) # Table dimension (rows, columns)

nrow(labdata) # Number of rows
ncol(labdata) # Number of columns

# Glimpse the content of a data frame
glimpse(labdata)

# Subsetting a vector
labdata$Result

labdata$Result[1:10]

labdata$Result[c(1, 3, 5)]

# Subsetting a data frame or tibble
labdata[12, 3]

labdata[, "Date"]

labdata[1:10, c("Suburb", "Result")]

n <- 10

labdata[n * 2, ]

# Filtering data frames
labdata[labdata$Measure == "Turbidity", ]

# Conditionals
a <- 1:2

a == 1
a != 1

# Filtering in tidyverse
turbidity <- filter(labdata, Measure == "Turbidity")

filter(labdata, Suburb == "Tarnstead" & Measure == "THM" & Result > .1)

nrow(filter(labdata, Suburb != "Strathmore" &
                     Measure == "Turbidity" &
                     Result < 0.1))

# Counting data
length(labdata$Measure)

unique(labdata$Measure)

# Generating tables
table(labdata$Measure)

table(labdata$Suburb, labdata$Measure)

# The dplyr count function (result is another data frame)
count(labdata, Suburb, Measure)

# Combining functions in steps
turbidity <- filter(labdata, Measure == "Turbidity")
turbidity_count <- count(turbidity, Suburb, name = "Samples")
turbidity_count

# Sorting data frames with dplyr
sample_count <- count(labdata, Sample_Point)
arrange(sample_count, n)
arrange(sample_count, desc(n))
slice_max(sample_count, n = 3, order_by = n)

# Using Regular Expressions (regex) to filter text
# Use vignette("regular-expressions") to learn more about regex
filter(labdata, str_detect(Suburb, "^M"))
