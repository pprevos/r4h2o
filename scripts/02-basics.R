#########################
# R4H2O Chapter 3: Basics
#########################

# Assigning variables

diameter <- 150
diameter

pipe_area <- (pi / 4) * (diameter / 1000)^2
pipe_area

# BODMAS

3 - 3 * 6 + 2

7 + 7 / 7 + 7 * 7 - 7

# Vector Variables

complaints <- c(12, 7, 23, 45, 9, 33, 12)
day <- 1:100

# Arithmetic functions

nonRevenueWater <- c(13, -9, 45, 0)

sum(nonRevenueWater)

prod(nonRevenueWater)

factorial(nonRevenueWater)

exp(nonRevenueWater)

log(nonRevenueWater)

log10(nonRevenueWater)

sqrt(nonRevenueWater)

abs(nonRevenueWater)

# Absolute values

sqrt(abs(nonRevenueWater))

# Complaex numbers

sqrt(as.complex(-25))

# Basic visualisation

diameters <- 50:351
pipe_areas <- (pi / 4) * (diameters / 1000)^2

plot(diameters, pipe_areas,
     type = "l", col = "blue",
     main = "Pipe Section Area",
     xlab = "Diameter", ylab = "Pipe Area")
abline(v = 150, col = "grey", lty = 2)
abline(h = (pi / 4) * (150 / 1000)^2, col = "grey", lty = 2)
points(150, (pi / 4) * (150 / 1000)^2, col = "red", pch = 12, cex = 2)

# Plot with both points and lines
diameter <- c(63, 150, 225)
area <- (pi / 4) * diameter^2
plot(area, diameter, type = "b")
