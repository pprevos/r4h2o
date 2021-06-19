## R4H2O: Data Science for Water Professionals
## Quiz 2: Exploring data

## Load data
library(tidyverse)
gormsey <- read_csv("casestudy1/gormsey.csv")

# How many results does the Gormsey data contain?
nrow(gormsey)
  
# How many E. coli results were recorded in Gormsey? 
nrow(filter(gormsey, Measure == "E. coli"))

# What is the maximum turbidity measurement in Blancathey?
turbidity_blancathey <- filter(gormsey, Town == "Blancathey" & Measure == "Turbidity")
max(turbidity_blancathey$Result)

# What is the data type of the Town field?
glimpse(gormsey)  
class(gormsey$Measure)

# What is the median THM result in Swadlincote and Wakefield?
thm_swad_wak <- filter(gormsey, (Town == "Swadlincote" | Town == "Wakefield") & Measure == "THM")
median(thm_swad_wak$Result)

# How many E Coli results breached the regulations? The limit for E Coli is 0 org/100ml.
nrow(filter(gormsey, Measure == "E. coli" & Result > 0))

# How many distinct measures are present in the data?
length(unique(gormsey$Measure))

