# Session 1a

# Arithmetic
3 - 3 * (6 + 2)
diameter <- 150
pipe_area <- (pi / 4) * (diameter / 1000)^2
pipe_area

sqrt(pipe_area / (pi / 4)) * 1000

complaints <- c(12, 13, 23, 45, 22, 99, 31)

sum(complaints)
prod(complaints)
abs(complaints)
exp(complaints)
factorial(complaints)
log(complaints, base = 10)

# Basic plotting
x <- -10:10
y <- -x^2 -2 * x + 30
plot(x, y, type = "l", col = "blue", main = "Parabola")
abline(h = 0, col = "grey", lty = 2)
abline(v = 0, col = "grey", lty = 2)

names(complaints) <- month.name[1:7]
barplot(complaints,
        col = "lavender",
        main = "Complaints")