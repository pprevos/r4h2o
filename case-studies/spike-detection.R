# Simulate turbidity data

# set.seed(1234)
turbidity <- data.frame(timestamp = seq.POSIXt(as.POSIXct("2017-01-01 00:00:00"),
                                               by = "min", length.out = 24 * 60),
                        turbidity = rnorm(n = 24*60, mean = 0.1, sd = 0.01))

## Spike detection

## Simulate data
for (i in 1:5) {
  duration <- sample(10:30, 1)
  start_time <- sample(turbidity$timestamp[1:(nrow(turbidity) - duration)], 1)
  value <- rnorm(1, 0.5 * rbinom(1, 1, 0.5) + 0.3, 0.05)
  start_row <- which(turbidity$timestamp == start_time)
  turbidity$turbidity[start_row:(start_row + duration - 1)] <- rnorm(duration, value, value / 10)
}

library(ggplot2)

ggplot(turbidity) + 
  aes(x = timestamp, y = turbidity) + 
  geom_line(size = 0.2) +
  geom_hline(yintercept = 0.5, col = "red", linetype = 2) + 
  ylim(0, max(turbidity$turbidity)) +
  theme_bw(base_size = 10) + 
  ggtitle("Simulated SCADA data")

ggsave("spikes.png", width = 4, height = 3)

# Spike Detection Function

spike.detect <- function(timestamp, value, limit, duration) {
  runlength <- rle(value > limit)
  spikes <- data.frame(spike = runlength$values,
                       times = cumsum(runlength$lengths))
  spikes$times <- timestamp[spikes$times]
  spikes$event <- c(0, spikes$times[-1] - spikes$times[-nrow(spikes)])
  spikes <- subset(spikes, spike == TRUE & event > duration)
  return(spikes)
}

spike.detect(turbidity$timestamp, turbidity$turbidity, 0.5, 15)
