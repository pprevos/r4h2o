#######################################
# R4H2O: 4 - LOADING AND EXPLORING DATA
#######################################

# Install packages (only do this once)
install.packages("tidyverse")

# Loading the Tidyverse packages

library(tidyverse)

# Reading a CSV file with base R

labdata <- read.csv("data/labdata.csv")

# Using the readr package from Tidyverse

library(readr)
labdata <- read_csv("data/labdata.csv")

# Reading Spreadsheet data

library(readxl)
labdata <- read_excel("data/labdata.xlsx", skip = 2, sheet = "data")

# Explore data frames

names(labdata)

dim(labdata)

nrow(labdata)
ncol(labdata)

head(labdata)
tail(labdata)

labdata

# Glimpse the content of a data frame

glimpse(labdata)

# View the structure of a variable
str(labdata)

# Subsetting a data frame or tibble

labdata$Result
labdata$Result[1:10]
labdata$Result[c(1, 3, 5)]
labdata[, "Date"]

labdata[1:2, 1:2]
labdata[1:2, ]
labdata[, 1:2]

labdata[1:10, c("Suburb", "Result")]
n <- 10
labdata[n * 2, ]

# Filtering data frames

labdata[labdata$Measure == "Turbidity", ]

# Conditionals

a <- 1:2
a == 1

a <- c(TRUE, FALSE)
a * 2

"small" > "large"
"small" > "large" & 1 > 2

# Filtering in tidyverse

turbidity <- filter(labdata, Measure == "Turbidity")

filter(labdata, Suburb == "Tarnstead" & Measure == "Turbidity" & Result > 1)

nrow(filter(labdata, Suburb != "Strathmore" &
                     Measure == "Turbidity" &
                     Result < 0.1))

# Counting data

length(labdata$Measure)

unique(labdata$Measure)

# Generating tables

table(labdata$Measure)

table(labdata$Suburb, labdata$Measure)

# The dplyr count function

count(labdata, Suburb, Measure)

# Combining functions in steps

turbidity <- filter(labdata, Measure == "Turbidity")
turbidity_count <- count(turbidity, Suburb, name = "Samples")
turbidity_count

# Using Regular Expressions (wildcards) to filter text

filter(labdata, str_detect(Suburb, "^M"))

# Reading data from the internet

read_csv("https://lucidmanager.org/r4h2o/data/labdata.csv")