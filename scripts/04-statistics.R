####################################
#
# R4H2O: 4 - DESCRIPTIVE STATISTICS
#
####################################

# Load data

library(readr)
library(dplyr)
labdata <- read_csv("data/water_quality.csv")
turbidity <- filter(labdata, Measure == "Turbidity")

x <- turbidity$Result

n <- length(x)

# MEASURES OF CENTRAL TENDENCY

# Arithmetic mean

sum(x) / n

mean(x)

# Weighted mean

weighted.mean(c(0.2, 0.5, 1), w = c(7, 5, 2))

mean(rep(c(0.2, 0.5, 1), c(7, 5, 2)))

# Median

median(x)

# Mode

mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

mode(x)

# MEASURES OF POSITION

summary(x)
fivenum(x)

# The quantile function

quantile(x)

quantile(x, probs = 0.95)
quantile(x, c(0.33, 0.66))

# Manual quantile calculations (linear method)

# Linear method

x_ord <- x[order(x)]
p <- 0.95

r <- p * n
(1 - (r - floor(r))) * x_ord[floor(r)] + (r - floor(r)) * x_ord[ceiling(r)]

# Weibull method

p <- 0.95

r <- p * (n + 1)
(1 - (r - floor(r))) * x_ord[floor(r)] + (r - floor(r)) * x_ord[ceiling(r)]

# Types of percentiles

# Linear method

quantile(x, 0.95,  type = 4)

# Weibull method

quantile(x, 0.95,  type = 6)

# MEASURES OF DISPERSION

min(x)
max(x)

range(x)

max(x) - min(x)

range(x)[2] - range(x)[1]

diff(range(x))

# Inter Quartile Range (IQR)

diff(quantile(x, probs = c(0.25, 0.75)))

IQR(x)

# Variance

var(x)

sum((x - mean(x))^2) / (n - 1)

# Standard Deviation

sd(x)

sqrt(sum((x - mean(x))^2) / (n - 1))

# MEASURES OF SHAPE

# Skewness: Third central moment

(sum((x - mean(x))^3) / n) / (sqrt(sum((x - mean(x))^2) / n)^3)

# Skewness with the moments package

moments::skewness(x)

# Kurtosis: Fourth central moment

(sum((x - mean(x))^4) / n) / (sqrt(sum((x - mean(x))^2) / n)^4)

# Moment package

moments::kurtosis(x)

# Using the e1071 package for skweness and kurtosis

# This library masks (overrides) the functions in the moments package
library(e1071)

skewness(x)
kurtosis(x)


# ANALYSING GROUPED DATA

labdata_grouped <- group_by(labdata, Measure)
labdata_grouped

summarise(labdata_grouped,
          Minimum = min(Result),
          Median = median(Result),
          p95 = quantile(Result, 0.95, type = 6),
          Maximum = max(Result),
          Kurtosis = moments::kurtosis(Result))

labdata_grouped <- group_by(labdata, Measure, Suburb)
summarise(labdata_grouped,
          samples = n())

count(labdata, Measure, Suburb, name = "Samples")

