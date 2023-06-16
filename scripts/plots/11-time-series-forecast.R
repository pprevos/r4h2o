# Advanced Time Series Analysis

source("scripts/11-date-time.R")

library(xts)
library(forecast)

hourly_vol <- meter_flow %>%
    mutate(weeknum = week(timestamp)) %>%
    filter(between(timestamp, as.POSIXct("2050-04-01"), as.POSIXct("2050-04-05"))) %>%
    mutate(timestamp_au = with_tz(timestamp, tzone = "Australia/Melbourne"),
           hour = round_date(timestamp_au, "hour")) %>% 
    group_by(hour) %>%
    summarise(volume = sum(flow))

hourly_vol_ts <- xts(hourly_vol$volume,
                     order.by = hourly_vol$hour,
                     format = "%Y%m%d")  

fit <- auto.arima(hourly_vol_ts, trace = TRUE)
fcast <- forecast(fit, h = 12)
plot(fcast)
