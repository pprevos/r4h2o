## Percentile calculations

## Example
set.seed(1969)
test.data <- rnorm(n = 10000, mean = 100, sd = 15)

library(ggplot2)

ggplot(as.data.frame(test.data), aes(test.data)) +
  geom_histogram(binwidth = 1, aes(y = ..density..), fill = "dodgerblue") +
  geom_line(stat = "function", fun = dnorm, args = list(mean = 100, sd = 15), colour = "red", size = 1) +
  geom_area(stat = "function", fun = dnorm, args = list(mean = 100, sd = 15),
            colour = "red", fill = "red", alpha = 0.5, xlim = quantile(test.data, c(0.5, 0.75))) +
  theme_bw(base_size = 8)

quantile(test.data)

quantile(test.data, probs = 0.95)

## Weibull method
weibull.quantile <- function(x, p) {
  # Order Samples from large to small
  x <- x[order(x, decreasing = FALSE)]
  # Determine the ranking of percentile according to Weibull (1939)
  r <- p * (length(x) + 1)
  # Linear interpolation
  rfrac <- (r - floor(r))
  return((1 - rfrac) * x[floor(r)] + rfrac * x[floor(r) + 1])
}
weibull.quantile(test.data, 0.95)

quantile(test.data, 0.95, type = 6)

## Visualise Data
library(tidyverse)

gormsey <- read_csv("~/Documents/projects/r4h2o/data/water_quality.csv")
turbidity <- filter(gormsey, Measure == "Turbidity" &
                             Suburb %in% c("Blancathey", "Tarnstead"))

ggplot(turbidity, aes(Result)) +
  geom_density(fill = "dodgerblue", aes(y = ..density..)) +
  scale_x_continuous(trans = "log10") + 
  facet_wrap(~Suburb) +
  theme_bw() +
  labs(title = "Turbidity Distribution",
       x= "log Results")

# Calculate all percentile methods
tapply(turbidity$Result, turbidity$Suburb,
       function(x) sapply(1:9, function(m) quantile(x, 0.95, type = m)))
