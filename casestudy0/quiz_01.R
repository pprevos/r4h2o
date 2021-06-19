## R4H2O: Data Science for Water Professionals
## Quiz 1: Channel flow

## Constants
Cd <- 0.6 # approximation
g <- 9.81

## Measurements
b <- 0.75 # Width


## Question 1
h <- 100 / 1000 # Height in m
q <- (2/3) * Cd * sqrt(2 * 9.81) * b * h^(3/2)  # m3 / s
q

## Question 2
h <- c(150, 136, 75) / 1000 # Create a vector
q <- (2/3) * Cd * sqrt(2 * 9.81) * b * h^(3/2) # Same as before
mean(q) * 1000 # Convert to l/s

## Question 3
# Try the options
(2/3) * Cd * sqrt(2 * 9.81) * b * (0.05:0.50)^(3/2)
(2/3) * Cd * sqrt(2 * 9.81) * b * ((50:500)/1000)^(3/2)

h <- (50:500) / 1000 # Create a vector
q <- (2/3) * Cd * sqrt(2 * 9.81) * b * h^(3/2) # Same as before
q

plot(h, q, type = "l", 
     main = "Flow over a weir", 
     sub = paste("Cd =", Cd, "b =", b))

