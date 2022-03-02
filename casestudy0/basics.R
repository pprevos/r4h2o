# Basic R Coding

# Arithmetic
3 - 3 * 6 + 2

diameter <- 150
pipe_area <- (pi / 4) * (diameter / 1000)^2
pipe_area
sqrt(pipe_area / (pi / 4)) * 1000


# Vectors
complaints <- c(12, 13, 23, 45, 22, 99, 31)

sum(complaints)
prod(complaints)
abs(complaints)
exp(complaints)
factorial(complaints)
log(complaints, base = 3)
log10(complaints)


# Basic plotting
diameter <- 50:350
pipe_area <- (pi / 4) * (diameter / 1000)^2
plot(diameter, pipe_area, type = "l", col = "blue", main = "Pipe Section Area")
abline(v = 150, col = "grey", lty = 2)
abline(h = (pi / 4) * (150 / 1000)^2, col = "grey", lty = 2)
points(150, (pi / 4) * (150 / 1000)^2, col = "red", pch = 19)
