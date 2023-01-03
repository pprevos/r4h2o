###########################
#
# R4H2O 11: Dates and Times
#
###########################

options(crayon.enabled = FALSE)

# Date Variables

Sys.Date()
as.numeric(Sys.Date())

as.Date("2022-07-01")
as.Date("1 July 2022", format = "%d %B %Y")
as.Date(19174, origin = "1970-01-01")

d <- Sys.Date() - as.Date("1969-09-12")
d
as.numeric(d)

format(Sys.time(), "%I %p")

as.POSIXct("2020-12-21 12:23:00")
as.POSIXct("21 December 2020 12:23", format = "%d %B %Y %H:%M")

Sys.timezone()
Sys.time()
format(Sys.time(), tz = "UTC")
format(Sys.time(), tz = "NZ")

ams <- Sys.time()
ams

attr(ams, "tzone") <- "Europe/Amsterdam"
ams

as.POSIXct("21 December 2020 12:23",
           format = "%d %B %Y %H:%M",
           tz = "America/Vancouver")

d <- as.POSIXct("2022-02-22 10:00:00")
d
as.Date(d)

# Lubridate package

library(lubridate)

# Extract date components

now()
year(now())
month(now())
day(now())

# Rounding date/time variables

floor_date(now(), unit = "hour")
round_date(now(), unit = "day")
ceiling_date(now(), unit = "month")

# Change time zones in Lubridate

now()
with_tz(now(), tz = "Europe/Amsterdam") # Change display
force_tz(now(), tz = "Europe/Amsterdam") # Change variable

# Exploring digital metering data

# Load data

library(readr)
meter_reads <- read_csv("data/meter_reads.csv")

# Filtering and Grouping by Date and Time

library(dplyr)
transmissions <- meter_reads %>%
  mutate(date = as.Date(timestamp)) %>%
  count(device_id, date)
transmissions

# Filtering by dates and times

filter(transmissions, date == as.Date("2050-02-04"))

filter(transmissions, between(date, as.Date("2050-01-01"), as.Date("2050-01-31")))

filter(meter_reads, as.Date(timestamp) == as.Date("2050-02-04"))

# Using lubridate helper functions to filter

filter(transmissions, year(date) == 2050)

filter(transmissions, floor_date(date, "month") == as.Date("2050-03-01"))

filter(meter_reads, round_date(timestamp, "hour") ==
                    as.POSIXct("2050-03-01 10:00:00", tz = "UTC"))

filter(meter_reads, format(timestamp, "%b %Y") == "Mar 2050")

# Monthly data

transmissions %>%
  group_by(month = floor_date(date, "month")) %>%
  summarise(transmissions = sum(n)) %>%
  mutate(days = days_in_month(month),
         mean_transmissions = transmissions / days)

# Calculating flows

meter_flow <- meter_reads %>%
  group_by(device_id) %>%
  mutate(volume = (count - lag(count, default = 0)) * 5,
         time = as.numeric(timestamp - lag(timestamp)),
         flow = volume / time)  %>%
  filter(!is.na(flow)) %>%
  ungroup()

# Calculating dayly flows

daily_dates <- unique(floor_date(meter_reads$timestamp, "day"))

daily_flow <- meter_reads %>%
  group_by(device_id) %>%
  summarise(date = (daily_dates),
            count = approx(x = timestamp,
                           y = count,
                           xout = daily_dates)$y) %>%
  mutate(volume = 5 * (count - lag(count))) %>%
  filter(!is.na(volume)) %>%
  ungroup()

library(ggplot2)
ggplot(daily_flow, aes(volume)) +
  geom_histogram(binwidth = 100) +
  theme_minimal()

seq.Date(from = Sys.Date(), length.out = 10, by = 1)
seq.POSIXt(from = Sys.time(), length.out = 4, by = 30)

diurnal <- meter_flow %>%
  mutate(timestamp_au = with_tz(timestamp, tzone = "Australia/Melbourne"),
         hour = hour(round_date(timestamp_au, "hour"))) %>%
  group_by(hour) %>%
  summarise(min_flow = min(flow) / 1000,
            mean_flow = mean(flow) / 1000,
            max_flow = max(flow) / 1000)

library(ggplot2)
ggplot(diurnal, aes(x = hour, ymin = min_flow, ymax = max_flow)) +
  geom_ribbon(fill = "gray", alpha = 0.5) +
  geom_line(aes(x = hour, y = mean_flow), col = "black", size = 1) +
  ggtitle("Connections Diurnal flow") +
  ylab(expression(Flow~m^3/h)) + 
  theme_bw(base_size = 10)

filter(meter_flow, device_id %in% c(1404857, 1515776))

filter(meter_flow, device_id == 1404857 | device_id == 1515776)

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

fit <- auto.arima(hourly_vol_ts)
fcast <- forecast(fit, h = 12)
plot(fcast)
