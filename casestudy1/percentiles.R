## R4H2O: Data Science for Water Professionals
## Percentiles example

## Create data
sample <- c(1:17, 63, 170, 300)

## Set parameters
n <- length(sample)
p <- 0.95

## Visualise
par(mar=c(6, 5, 4, 1))
plot(sample, type = "b", 
     main = "Percentile example", 
     sub = "Excel and Weibull percentile method", 
     pch = 20,
     lwd = 1, xlab = "Rank", ylab = "Result")

## Calculate rank
r_weibull <- p * (n + 1)
r_excel <- 1 + p * (n - 1)

## Interpolate percentiles
x_weibull <- (1 - (r_weibull - floor(r_weibull))) * sample[floor(r_weibull)] + (r_weibull - floor(r_weibull)) * sample[ceiling(r_weibull)]
x_excel <- (1 - (r_excel - floor(r_excel))) * sample[floor(r_excel)] + (r_excel - floor(r_excel)) * sample[ceiling(r_excel)]

## Visualise
abline(v = r_weibull, col = "red", lwd = 1)
abline(v = r_excel, col = "blue", lwd = 1)

## Legend
legend("topleft", legend = c("Excel", "Weibull"), fill = c("blue", "red"))

## Which ones are these in R?
x_r <- sapply(1:9, function(t) quantile(sample, 0.95, type = t))
weibull <- which(x_r == x_weibull)
excel <- which(x_r == x_excel)
