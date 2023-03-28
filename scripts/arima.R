# loading packages
library(tidyverse)
library(forecast)
library(Metrics)

# reading data
meter_reads <- read_csv("data/meter_reads.csv")

# Daily flow
daily_flow <- meter_reads %>%
    group_by(device_id) %>%
    reframe(date = daily_dates,
              count = approx(x = timestamp,
                             y = count,
                             xout = daily_dates)$y) %>%
    mutate(volume = 5 * (count - lag(count))) %>%
    filter(!is.na(volume)) %>%
    ungroup() %>% 
    group_by(date) %>% 
    summarise(daily = sum(volume))

# splitting data into train and valid sets
train = daily_flow[1:80,]
valid = daily_flow[81:nrow(daily_flow),]

# training model
model = auto.arima(train[, -1])

# model summary
summary(model)

# forecasting
forecast = predict(model, nrow(daily_flow) - 80)

# evaluation
rmse(valid$daily, forecast$pred)

plot(daily_flow$date, daily_flow$daily, type = "l")

lines(daily_flow$date[81:nrow(daily_flow)], forecast$pred, col = "red")
