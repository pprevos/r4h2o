# using a function

channel_flow <- function(h, b, cd = 0.62, g = 9.81) {
    q <- (2/3) * cd * sqrt(2 * g) * b * h^(3/2)
    return(q)
}

channel_flow(h = 100 / 1000, b = 0.5)

channel_flow <- function(h, b, cd = 0.62, g = 9.81) {
    q <- (2/3) * cd * sqrt(2 * g) * b * h^(3/2)
    return(q)}

channel_flow(h = 100 / 1000, b = 0.5, cd = 0.62, g = 9.81)

channel_flow(100 / 1000, 0.5)

channel_flow(100 / 1000, 0.5, g = 3.72)

channel_flow

sum

y <- 12
f <- function(x) {
    y <- x^2
    y
}

f(10)
y

f <- function(x) {
    y <<- x^2
    y
}

f(10)
y
