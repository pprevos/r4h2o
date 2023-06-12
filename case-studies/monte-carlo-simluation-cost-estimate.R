# Monte Carlo Simulation in R
library(triangle)

# Triangular distribution
hist(rtriangle(n = 10000, a = 12000, b = 15000, c = 14000), 
     breaks = 100, 
     main = "Triangular distribution simulation")

## Read Data
estimate <- read.csv("data/cost-estimate.csv")

## Simulation settings
n <- 10000 ## Simulations
j <- nrow(estimate)
mc_sims <- matrix(ncol = n,
                  nrow = j)

## Simulation
for (i in 1:j){
  mc_sims[i,] <- rtriangle(n = n,
                           a = estimate$Low[i],
                           b = estimate$High[i],
                           c = estimate$Medium[i])}

## Determine estimates and 95th percentile
mc_results <- colSums(mc_sims)
p95 <- quantile(mc_results, 0.95)

## Visualise
hist(mc_results, breaks = 100)
abline(v = p95, col = "red", lwd = 2)
