######################################
# R4H2O: Case Study 1 question answers
######################################

# Load and view laboratory data

library (tidyverse)
labdata <- read_csv("data/water_quality.csv")

# Chapter 4: LOADING AND EXPLORING DATA

# Question 1
# Create a table of the number of E. coli regulation breaches by suburb

ecoli <- filter(labdata, Measure == "E. coli" & Result > 0)
count(ecoli, Suburb)

# Combine the code

count(filter(labdata, Measure == "E. coli" & Result > 0), Suburb)

# Question 2
# Which sample point has the most number of samples taken?

samples <- count(labdata, Sample_Point, name = "Samples")
filter(samples, Samples == max(Samples))

# Sort results

arrange(samples, desc(Samples))

# Top n results

slice_max(samples, order_by = Samples, n = 3)

# Question 3
# On how many days were samples taken?

length(unique(labdata$Date))

nrow(distinct(labdata, Date))

# Chapter 5: DESCRIPTIVE STATISTICS

# Question 1: Visualise distribution of THM results for the towns of Merton and Southwold

thm_sw <- filter(labdata, (Suburb == "Southwold" | Suburb == "Merton") & Measure == "THM")
boxplot(data = thm_sw, Result ~ Suburb)
abline(h = 0.25, col = "red")

# Question 2: Which suburb recorded the highest level of chlorine?

chlorine <- filter(labdata, Measure == "Chlorine Total")

chlorine_sp <- group_by(chlorine, Sample_Point)
chlorine_med <- summarise(chlorine_sp, median = median(Result))

arrange(chlorine_med, desc(median))

chlorine_med[which.max(chlorine_med$median), "Sample_Point"]

# Question 3: Average 95th percentile of turbidity for all towns

turbidity <- filter(labdata, Measure == "Turbidity")
turbidity_grouped <- group_by(turbidity, Suburb)
turbidity_p95 <- summarise(turbidity_grouped,
                           p95 = quantile(Result, 0.95, type = 6))
mean(turbidity_p95$p95)
