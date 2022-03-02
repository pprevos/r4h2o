# Case Study 0: Channel Flows

# Define constants
Cd <- 0.62
g <- 9.81
l <- 0.5

# 1. What is the flow in the channel in m3/s when the height h = 100mm?
h1 <- 100 / 1000
q1 <- (2 / 3) * Cd * sqrt(2 * g) * l * h1^(3 / 2)
q1

# 2. What is the average flow for these three heights: 150mm, 136mm, 75mm, in litres per second?
h <- c(150, 136, 75) / 1000
q <- (2 / 3) * Cd * sqrt(2 * g) * l * h^(3 / 2) * 1000
q

# 3. Visualise the flow in m3/s for all heights (h) between 50mm and 500mm
h <- (50:500) / 1000
q <- (2 / 3) * Cd * sqrt(2 * g) * l * h^(3 / 2)
plot(h, q, type = "l", main = "Channel Flow")
abline(v = c(150, 136, 175) / 1000, col = "red")
abline

# Advanced method
weir_flow <- function(h, l, Cd = 0.62, g = 9.81) {
    (2 / 3) * Cd * sqrt(2 * g) * l * h^(3 / 2)
}

weir_flow(.1, l)
weir_flow(c(150, 136, 75) / 1000, l)
plot((50:500) / 1000, weir_flow((50:500) / 1000, l), type = "l", main = "Channel flow")
