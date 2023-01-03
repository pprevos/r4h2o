#################################################
#
# R4H2O Chapter 2: Introduction to the R Language
#
#################################################

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

# Irrigation Channel Case Study

# Define constants

cd <- 0.62
g <- 9.81
b <- 0.5

# Question 1
# Flow in m3/2 when h = 100 mm

h1 <- 100 / 1000
q1 <- (2 / 3) * cd * sqrt(2 * g) * b * h1^(3 / 2)
q1

# Question 2
# h=150mm, h = 136mm, h = 75mm

h2 <- c(150, 136, 75) / 1000
q2 <- (2 / 3) * cd * sqrt(2 * g) * b * h2^(3 / 2)
mean(q2)

# Question 3
# Plot the flow in m3/s for all heights between 50mm and 500mm

h3 <- (50:300) / 1000
q3 <- (2 / 3) * cd * sqrt(2 * g) * b * h3^(3 / 2)

plot(h3, q3, type = "l",
     xlab = "Height [m]", ylab = "Flow [m3/s]",
     main = "Open Channel Flow, Cd = 0.62")
abline(v = h2, col = "grey")
abline(h = q2, col = "grey")
points(h2, q2, pch = 19, col = "blue")

# Generate sequences

h3 <- seq(from = .05, to = .3, by = .001)

h3 <- seq(from = 0.05, to = 0.3, length.out = 100)

# For-loop (not recommended)

q3 <- vector()
i <- 1

for (h3 in 50:500) {
  q3[i] <- (2 / 3) * cd * sqrt(2 * g) * b * (h3 / 1000)^(3 / 2)
  i <- i + 1
}
