# Chapter 5

library(tidyverse)
gormsey <- read_csv("casestudy1/gormsey.csv", show_col_types = FALSE)
turbidity <- filter(gormsey, Measure == "Turbidity")

# Histograms
par(mfrow = c(1, 2))
hist(turbidity$Result)
hist(log(turbidity$Result))

# Boxplot
par(mar = c(8, 4, 4, 1), mfrow = c(1, 1))
boxplot(data = turbidity, log(Result) ~ Town, las = 2,
        xlab = NULL, main = "Gormsey Turbidity Samples")


# Central tendency
mean(turbidity$Result)

sum(turbidity$Result) / length(turbidity$Result)

weighted.mean(c(0.2, 0.5, 1), w = c(7, 5, 2))

mean(rep(c(0.2, 0.5, 1), c(7, 5, 2)))

median(turbidity$Result)

mode <- pull(top_n(count(turbidity, Result), 1), Result)
mode


# Position
summary(turbidity$Result)

# Quantile
n <- length(turbidity$Result)
ranked_turbidity <- turbidity$Result[order(turbidity$Result)]
ranked_turbidity[n / 4]

quantile(turbidity$Result)

sample <- turbidity$Result[order(turbidity$Result)]
p <- 0.95
n <- length(sample)

# Weibull
r <- p * (n + 1)
(1 - (r - floor(r))) * sample[floor(r)] + (r - floor(r)) * sample[ceiling(r)]

# Excel method
r <- 1 + p * (n - 1)
(1 - (r - floor(r))) * sample[floor(r)] + (r - floor(r)) * sample[ceiling(r)]


quantile(turbidity$Result, 0.95)
quantile(turbidity$Result, 0.95,  type = 4)
quantile(turbidity$Result, 0.95,  type = 6)


# Range
min(turbidity$Result)
max(turbidity$Result)
range(turbidity$Result)

IQR(turbidity$Result)

diff(quantile(turbidity$Result, probs = c(0.25, 0.75)))


# Spread
var(turbidity$Result)
sum((turbidity$Result - mean(turbidity$Result))^2) / (length(turbidity$Result) - 1)

sd(turbidity$Result)

sqrt(var(turbidity$Result))


# Skewness
mode_skew <- (mean(turbidity$Result) - mode) / sd(turbidity$Result)
mode_skew
med_skew <- 3 * (mean(turbidity$Result) - median(turbidity$Result)) /
    sd(turbidity$Result)
med_skew


x <- turbidity$Result
n <- length(x)

(sum((x - mean(x))^3)) / n / (sqrt(sum((x - mean(x))^2) / n)^3)


library(moments)
skewness(x)


# Kurtosis
(sum((x - mean(x))^4)) / n / (sqrt(sum((x - mean(x))^2) / n)^4)

library(moments)
kurtosis(x)


# Grouping
turbidity_grouped <- group_by(turbidity, Town)
turbidity_grouped

summarise(turbidity_grouped,
          Minimum = min(Result),
          Median = median(Result),
          p95 = quantile(Result, 0.95, type = 6),
          Maximum = max(Result))


gormsey_grouped <- group_by(gormsey, Measure, Town)
summarise(gormsey_grouped,
          samples = n(),
          min = min(Result),
          mean = mean(Result),
          p95 = quantile(Result, 0.95, type = 6),
          max = max(Result))

