## Digital Metering Simulation

## Libraries
library(tidyverse)

## Boundary conditions
n <- 100 # Number of services
d <- 365 # Number of days
s <- as.POSIXct("2069-07-01", tz = "Australia/Melbourne") # Start of simulation

set.seed(2069) # Seed random number generator for reproducibility
rtu <- paste("RTU", sample(1E6:9E6, n, replace = FALSE), sep = "-") # 6-digit id
offset <- sample(0:3599, n, replace = TRUE) # Unique Random offset for each RTU

## Generic Diurnal Curve
diurnal <- tibble(Time = 0:24,
                  Flow = round(c(1.36, 1.085, 0.98, 1.05, 1.58, 3.87,
                                 9.37, 13.3, 12.1, 10.3, 8.44, 7.04,
                                 6.11, 5.68, 5.58, 6.67, 8.32, 10.0,
                                 9.37, 7.73, 6.59, 5.18, 3.55, 2.11, 1)) - 1)

ggplot(diurnal, aes(Time, Flow)) + 
    geom_area(fill = "dodgerblue", alpha = 0.5) +
    scale_x_continuous(breaks = 0:23) + 
    scale_y_continuous(breaks = seq(0, 15, 5)) + 
    labs(title = "Model diurnal curve",
         subtitle = "Liters per person per hour",
         y = "Flow [L/h/p]")
ggsave("manuscript/resources/session7/model-diurnal.png", width = 8, height = 6)

diurnal <- diurnal[-24, ] # Last entry only for visualisation

## Occupants
occupants <- rpois(n, 1.5) + 1 # Number of occupants per connection
as.tibble(occupants) %>%
  ggplot(aes(occupants)) + geom_bar(fill = "dodgerblue") + 
  labs(title = "Simulated occupants per connection",
       x = "Occupants", y = "Properties")
ggsave("manuscript/resources/session7/occupants.png", width = 8, height = 6)

## Leak simulation
leaks <- rbinom(n, 1, prob = .1) * sample(10:50, n, replace = TRUE)
tibble(DevEUI = rtu, Leak = leaks) %>%
    filter(Leak > 0)

## Digital metering data simulation
sim <- matrix(ncol = 3, nrow = 24 * n * d)
colnames(sim) <- c("DeviceID", "TimeStamp", "Count")

for (i in 1:n) {
    r <- ((i - 1) * 24 * d + 1):(i * 24 * d)
    sim[r, 1] <- rep(rtu[i], each = (24 * d))
    sim[r, 2] <- seq.POSIXt(s, by = "hour", length.out = 24 * d) + offset[i]
    diurnal_service <- (diurnal$Flow * runif(1, 0.8, 1.2) * occupants[i]) + 
        (leaks[i] * runif(1, 0.8, 1.2))
    sim[r, 3] <- round(cumsum(rep(diurnal_service, d)) / 5)
}

meter_reads <- as_tibble(sim) %>%
    type_convert() %>%
    mutate(TimeStamp = as.POSIXct(TimeStamp, origin = "1970-01-01"))

write_csv(meter_reads, "casestudy3/meter_reads.csv")
