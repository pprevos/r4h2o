#########################################
#
# R4H2O 2: INTRODUCTION TO THE R LANGUAGE
#
#########################################

# Assigning variables

diameter <- 150
diameter

(pi / 4) * (diameter / 1000)^2

# BODMAS

3 - 3 * 6 + 2

7 + 7 / 7 + 7 * 7 - 7

# Vector Variables

complaints <- c(12, 7, 23, 45, 9, 33, 12)
day <- 1:100

# Arithmetic functions

non_revenue_water <- c(13, -9, 45, 0)

sum(non_revenue_water)

prod(non_revenue_water)

factorial(non_revenue_water)

exp(non_revenue_water)

log(non_revenue_water)

sqrt(non_revenue_water)

abs(non_revenue_water)

# Absolute values
sqrt(abs(non_revenue_water))

# Complex numbers
sqrt(as.complex(-non_revenue_water))

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
