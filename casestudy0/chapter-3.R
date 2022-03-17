# Basic R Coding

# Arithmetic

diameter <- 150
pipe_area <- (pi / 4) * (diameter / 1000)^2
pipe_area
sqrt(pipe_area / (pi / 4)) * 1000


# Vectors
nonRevenueWater <- c(12, 13, 23, -9, 45, 22, 99, 0)

sum(nonRevenueWater)
prod(nonRevenueWater)
abs(nonRevenueWater)
exp(nonRevenueWater)
factorial(nonRevenueWater)
log(nonRevenueWater, base = 3)
log10(nonRevenueWater)
log2(nonRevenueWater)

# Basic plotting
diameters <- 50:350
pipe_areas <- (pi / 4) * (diameters / 1000)^2
plot(diameters, pipe_areas,
     type = "l", col = "blue",
     main = "Pipe Section Area",
     xlab = "Diameter", ylab = "Pipe Area")
abline(v = 150, col = "grey", lty = 2)
abline(h = (pi / 4) * (150 / 1000)^2, col = "grey", lty = 2)
points(150, (pi / 4) * (150 / 1000)^2, col = "red", pch = 12, cex = 2)
