## R4H2O: Data Science for Water Professionals
## Percentiles example

## Create data
sample <- c(1:17, 63, 170, 300)

## Set parameters
n <- length(sample)
p <- 0.95

## Visualise
png("manuscript/resources/05_statistics/percentiles.png", width = 1024, height = 768)
par(mar=c(6, 5, 4, 1))
plot(sample, type = "b", 
     main = "Percentile example", 
     sub = "Excel and Weibull percentile method", 
     cex.axis = 2,
     cex.lab = 2,
     cex.main = 2,
     cex.sub = 2,
     pch = 20,
     lwd = 3)

## Calculate rank
r_weibull <- p * (n + 1)
r_excel <- 1 + p * (n - 1)

## Interpolate percentiles
x_weibull <- (1 - (r_weibull - floor(r_weibull))) * sample[floor(r_weibull)] + (r_weibull - floor(r_weibull)) * sample[ceiling(r_weibull)]
x_excel <- (1 - (r_excel - floor(r_excel))) * sample[floor(r_excel)] + (r_excel - floor(r_excel)) * sample[ceiling(r_excel)]

## Visualise
abline(v = r_weibull, col = "red", lwd = 3, lty = 3)
abline(v = r_excel, col = "blue", lwd = 3, lty = 2)

## Legend
legend("topleft", legend = c("Excel", "Weibull"), fill = c("blue", "red"), cex = 2)
dev.off()

## R
x_r <- sapply(1:9, function(t) quantile(sample, 0.95, type = t))
weibull <- which(x_r == x_weibull)
excel <- which(x_r == x_excel)
