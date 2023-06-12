# Simulate turbidity data

set.seed(1234)
turbidity <- data.frame(DateTime = seq.POSIXt(as.POSIXct("2017-01-01 00:00:00"),
                                              by = "min", length.out = 24 * 60),
                        Turbidity = rnorm(n = 24*60, mean = 0.1, sd = 0.01)
                        )

## Spike detection

## Simulate data
for (i in 1:5) {
  time <- sample(turbidity$DateTime, 1)
  duration <- sample(10:30, 1)
  value <- rnorm(1, 0.5 * rbinom(1, 1, 0.5) + 0.3, 0.05)
  start <- which(turbidity$DateTime == time)
  turbidity$Turbidity[start:(start+duration - 1)] <- rnorm(duration, value, value/10)
}

library(ggplot2)
ggplot(turbidity, aes(x = DateTime, y = Turbidity)) + 
  geom_line(size = 0.2) +
  geom_hline(yintercept = 0.5, col = "red") + 
  ylim(0,max(turbidity$Turbidity)) +
  theme_bw(base_size = 10) + 
  ggtitle("Simulated SCADA data")
ggsave("spikes.png", width = 4, height = 3)

# Spike Detection Function

spike.detect <- function(DateTime, Value, Height, Duration) {
  runlength <- rle(Value > Height)
  spikes <- data.frame(Spike = runlength$values,
                       times = cumsum(runlength$lengths))
  spikes$Times <- DateTime[spikes$times]
  spikes$Event <- c(0,spikes$Times[-1] - spikes$Times[-nrow(spikes)])
  spikes <- subset(spikes, Spike == TRUE & Event > Duration)
  return(spikes)
}

spike.detect(turbidity$DateTime, turbidity$Turbidity, 0.5, 15)
