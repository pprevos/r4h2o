########################################
#
# R4H2O 2: IRRIGATION CHANNEL CASE STUDY
#
########################################

# Define constants

cd <- 0.62
g <- 9.81
b <- 0.5

# Question 1
# Flow in m3/s when h = 100 mm

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

h3 <- (50:500) / 1000
q3 <- (2 / 3) * cd * sqrt(2 * g) * b * h3^(3 / 2)

plot(h3, q3, type = "l",
     xlab = "Height [m]", ylab = "Flow [m3/s]",
     main = paste("Open Channel Flow, Cd =", cd))
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

