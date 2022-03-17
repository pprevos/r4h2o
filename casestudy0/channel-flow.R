# Case Study 0: Channel Flows

# Define constants
Cd <- 0.62
g <- 9.81
b <- 0.5

# 1. What is the flow in the channel in m3/s when the height h = 100mm?
h1 <- 100 / 1000
q1 <- (2 / 3) * Cd * sqrt(2 * g) * b * h1^(3 / 2)
q1

# In the first hour, the head is 150mm, the next two hours, we measure 136mm, and in the last three hours of the delivery, the head is 75mm. So what is the total delivered volume in m^3^?
h2 <- c(150, 136, 75) / 1000
q2 <- (2 / 3) * Cd * sqrt(2 * g) * b * h2^(3 / 2)
t <- (1:3) * 3600
sum(q2 * t)

# 3. Visualise the flow in m3/s for all heights (h) between 50mm and 500mm
h3 <- (50:300) / 1000
q3 <- (2 / 3) * Cd * sqrt(2 * g) * b * h3^(3 / 2)

plot(h3, q3, type = "l",
     xlab = "Height [m]", ylab = "Flow [m3/s]",
     main = "Open Channel Flow, Cd = 0.62")
abline(v = h2, col = "grey")
abline(h = q2, col = "grey")
points(h2, q2, pch = 19, col = "blue")

# Alternative methods
h3 <- (50:300) / 1000
h3 <- seq(from = 0.05, to = 0.3, by = 0.001)
h3 <- seq(from = 0.05, to = 0.3, length.out = 251)

# Using loops
q3 <- vector()

for (h3 in 50:500) {
  q3[h3 - 49] <- (2 / 3) * Cd * sqrt(2 * g) * b * (h3 / 1000)^(3 / 2)
}

# Advanced method
weir_flow <- function(h, l, Cd = 0.62, g = 9.81) {
    (2 / 3) * Cd * sqrt(2 * g) * l * h^(3 / 2)
}

weir_flow(.1, 0.5)
