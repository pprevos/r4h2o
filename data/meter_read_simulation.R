# Simulate water consumption

library(tidyverse)

rm(list = ls())

# Boundary conditions
n <- 100 # Number of simulated meters
d <- 100 # Number of days to simulate
s <- as.POSIXct("2050-01-01", tz = "UTC") # Start of simulation

set.seed(1969) # Seed random number generator for reproducibility
rtu <- sample(1E6:2E6, n, replace = FALSE) # 6-digit id
offset <- sample(0:3599, n, replace = TRUE) # Unique Random offset for each RTU

# Number of occupants per connection
occupants <- rpois(n, 1.5) + 1

# Diurnal Curve
diurnal_au <- round(c(1.36, 1.085, 0.98, 1.05, 1.58, 3.87, 9.37, 13.3, 12.1, 10.3, 8.44, 7.04, 6.11, 5.68, 5.58, 6.67, 8.32, 10.0, 9.37, 7.73, 6.59, 5.18, 3.55, 2.11)) - 1

tdiff <- 11
diurnal_utc <- c(diurnal_au[(tdiff + 1): 24], diurnal_au[1:tdiff])

# Leaking properties
leaks <- rbinom(n, 1, prob = .1) * sample(10:50, n, replace = TRUE)
data.frame(device_id = rtu, leak = leaks) %>%
    subset(leak > 0)

# Digital metering data simulation
meter_reads <- matrix(ncol = 3, nrow = 24 * n * d)
colnames(meter_reads) <- c("device_id", "timestamp" , "count")

for (i in 1:n) {
    r <- ((i - 1) * 24 * d + 1):(i * 24 * d)
    meter_reads[r, 1] <- rep(rtu[i], each = (24 * d))
    meter_reads[r, 2] <- seq.POSIXt(s, by = "hour", length.out = 24 * d) + offset[i]
    meter_reads[r, 3] <- round(cumsum((rep(diurnal_utc * occupants[i], d) +
                                           leaks[i]) * runif(24 * d, 0.9, 1.1)) / 5)
}

meter_reads <- as_tibble(meter_reads) %>%
    mutate(timestamp = as.POSIXct(timestamp, origin = "1970-01-01", tz = "UTC"))

# Set missing indicator
meter_reads <- mutate(meter_reads, remove = 0)

# Define faulty RTUs (2% of fleet)
faulty <- rtu[rbinom(n, 1, prob = 0.02) == 1]
meter_reads$remove[meter_reads$device_id %in% faulty] <- 
    rbinom(sum(meter_reads$device_id %in% faulty), 1, prob = .5)

# Data loss
missing <- sample(1:(nrow(meter_reads) - 5), 0.005 * nrow(meter_reads))
for (m in missing){
    meter_reads[m:(m + sample(1:5, 1)), "remove"] <- 1
}

# Remove missing reads
meter_reads <- filter(meter_reads, remove == 0) %>%
    select(-remove)

# Write to disk
write_csv(meter_reads, "data/meter_reads.csv")









