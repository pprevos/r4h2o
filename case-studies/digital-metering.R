## Analyse digital meter data
library(tidyverse)
library(lubridate)
library(magrittr)

# Load data
meter_reads <- read_csv("~/r4h2o-gh/data/meter_reads.csv")
rtu <- unique(meter_reads$device_id)

# Slicing meter reads

slice_reads <- function(rtus, dates = range(meter_reads$timestamp)) {
  filter(meter_reads, device_id %in% rtus) %>%
    filter(timestamp >= as.POSIXct(dates[1], tz = "UTC") &
           timestamp <= as.POSIXct(dates[2], tz = "UTC")) %>%
    arrange(device_id, timestamp)
}

slice_reads(rtu[12], c("2050-02-12", "2050-02-13"))

# Interpolation

interpolate_count <- function(rtus, timestamps) {
    timestamps <- as.POSIXct(timestamps, tz = "UTC")
    results <- vector("list", length(rtus))
    for (r in seq_along(rtus)) {
        interp <- slice_reads(rtus[r]) %$%
            approx(timestamp, count, timestamps)
        results[[r]] <- tibble(device_id = rep(rtus[r], 
                                                   length(timestamps)),
                                   timestamp = timestamps, count = interp$y)
    }
    return(do.call(rbind, results))
}

interpolate_count(rtu[2:3], seq.POSIXt(as.POSIXct("2050-02-01"), 
                                       by = "day", length.out = 3))

sample <- 4:5

slice_reads(rtu[sample], c("2050-02-01 20:00", "2050-02-02 04:00")) %>%
    ggplot(aes(timestamp, count, col = factor(device_id))) +
    geom_line() +
    geom_point() +
    geom_point(data = interpolate_count(rtu[sample], "2050-02-02 00:00"), 
               col = "blue", size = 3) + 
    facet_wrap(~device_id, scale = "free_y") + 
    ggtitle(paste("Device", rtu[2:3])) +
    theme_bw(base_size = 10)

# Daily consumption
daily_consumption <- function(rtus, dates) {
  timestamps <- seq.POSIXt(as.POSIXct(min(dates), tz = "UTC") - 24 * 3600,
                           as.POSIXct(max(dates), tz = "UTC"), by = "day")
  interpolate_count(rtus, timestamps) %>%
    group_by(device_id) %>%
    mutate(consumption = c(0, diff(count)) * 5) %>%
    filter(timestamp != timestamps[1])
}

daily_consumption(rtu[32:33], c("2050-02-01", "2050-02-07")) %>%
  ggplot(aes(timestamp, consumption)) +
  geom_col() +
  facet_wrap(~device_id) +
  theme_bw(base_size = 10) +
  ggtitle("Daily consumption")

# Diurnal curves

plot_diurnal_connections <- function(rtus, dates) {
  timestamps <- seq.POSIXt(as.POSIXct(dates[1], tz = "UTC"),
                           as.POSIXct(dates[2], tz = "UTC"), by = "hour")
  interpolate_count(rtus, timestamps) %>%
    group_by(device_id) %>%
    mutate(rate = c(0, diff(count * 5)),
           hour = as.integer(format(timestamp, "%H"))) %>%
    filter(rate >= 0) %>%
    group_by(hour) %>%
    summarise(min = min(rate), mean = mean(rate), max = max(rate)) %>%
    ggplot(aes(x = hour, ymin = min, ymax = max)) +
    geom_ribbon(fill = "lightblue", alpha = 0.5) +
    geom_line(aes(x = hour, y = mean), col = "orange", linewidth = 1) +
    ggtitle("Connections Diurnal flow") +
    ylab("Flow rate [L/h]") + 
    theme_bw(base_size = 10)
}

plot_diurnal_connections(rtu[10:20], c("2050-02-01", "2050-03-01"))
