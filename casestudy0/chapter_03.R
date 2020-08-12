## R4H2O: Data Science for Water Professionals
## Chapter 3: Introduction to the R Language 

# basics
3 - 3 * (6 + 2)

diameter <- 150
pipe_area <- (pi / 4) * (diameter / 1000)^2
pipe_area

complaints <- c(12, 3, 23, 45, 2, 99, 1)
mean(complaints)

x <- -10:10
y <- -x^2 -2 * x + 30
plot(x, y, type = "l", col = "blue")
abline(h = 0, col = "grey")
abline(v = 0, col = "grey")

# Vector functions
flow <- c(12, 3, 23, 45, 2, 99, 1, 0)
abs(flow)
exp(flow)
factorial(flow)
log(flow, base = 10)
sqrt(flow)
sum(flow)
prod(flow)
min(flow)
max(flow)

