###########################
#
# R4H2O 11: DATES AND TIMES
#
###########################

# Date Variables

Sys.Date()
class(Sys.Date())

# Unix epoch
as.numeric(Sys.Date())

as.Date(20000, origin = "1970-01-01") # Unix
as.Date(20000, origin = "1899-12-31") # Spreadsheets

# Date formats
as.Date("2022-07-01") # ISO 8601
as.Date("1 July 2022", format = "%d %B %Y")
as.Date("Day: 12, Month: 06, Year: 2023", format = "Day: %d, Month: %m, Year: %Y")
format(Sys.Date(), "%A week %V, %Y")

?strptime

# Convert dates to numbers (time differences)

d <- Sys.Date() - as.Date("1969-09-12")
d
as.numeric(d)

# Time variables

as.POSIXct("2020-12-21 12:23:00")
as.POSIXct("21 December 2020 12:23", format = "%d %B %Y %H:%M")

# Time zones

Sys.time()

Sys.timezone()

format(Sys.time(), tz = "Asia/Macao")
format(Sys.time(), tz = "NZ")

OlsonNames()

ams <- Sys.time()
ams

attr(ams, "tzone") <- "Europe/Amsterdam"
ams
class(ams)

as.POSIXct("21 December 2020 12:23",
           format = "%d %B %Y %H:%M",
           tz = "America/Vancouver")

# Converting time to date jumps to UTC
d <- as.POSIXct("2022-02-22 10:00:00", tz = "Australia/Melbourne")
d
as.Date(d)

as.Date(d, tz = "Australia/Melbourne")

# Lubridate package

library(lubridate)

# Extract date components

now()
year(now())
month(now())
day(now())
week(now())

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
library(dplyr)

meter_reads <- read_csv("data/meter_reads.csv")

group_by(meter_reads, device_id) %>% 
  summarise(volume = (5 / 1000) * (max(count) - min(count))) %>% 
  arrange(desc(volume))

# Filtering and Grouping by Date and Time

transmissions <- meter_reads %>%
  mutate(date = as.Date(timestamp)) %>%
  count(device_id, date)
transmissions

# Filtering by dates and times

filter(transmissions, date == as.Date("2050-02-04"))
filter(transmissions, date == "2050-02-04")

filter(transmissions, between(date, as.Date("2050-01-01"), as.Date("2050-01-31")))

filter(meter_reads, as.Date(timestamp) == "2050-02-04")

# Using lubridate helper functions to filter

filter(transmissions, year(date) == 2050)

filter(transmissions, floor_date(date, "month") == "2050-03-01")

filter(meter_reads, round_date(timestamp, "hour") ==
                    as.POSIXct("2050-03-01 10:00:00", tz = "UTC"))

filter(meter_reads, round_date(timestamp, "hour") == "2050-03-01 10:00:00")

filter(meter_reads, format(timestamp, "%b %Y") == "Mar 2050")

# Monthly data

transmissions %>%
  group_by(month = floor_date(date, "month")) %>%
  summarise(transmissions = sum(n)) %>%
  mutate(days = days_in_month(month),
         mean_transmissions = transmissions / days)

# Calculating flows

lag(1:10)
lead(1:10)

meter_flow <- meter_reads %>%
  group_by(device_id) %>%
  mutate(volume = (count - lag(count, default = 0)) * 5,
         time = as.numeric(timestamp - lag(timestamp)),
         flow = volume / time) %>% 
  filter(!is.na(flow)) %>%
  ungroup()

# Linear Interpolation
x <- today() + c(0, 7, 10, 15)
y <- c(0, 30, 135, 200)

plot(x, y, col = "red", pch = 16)

linear <- approx(x, y) # Default: 50 interpolations

points(linear$x, linear$y, col = "gray", cex = .5,
     xlab = "x", ylab = "y")

constant <- approx(x, y, method = "constant", n = 9)

points(constant$x, constant$y, col = "gray", pch = 20, type = "b")

point <- approx(x, y, xout = today() + 8.5)

points(point$x, point$y, col = "blue", pch = 12, cex = 2)


# Calculating daily flows

daily_dates <- unique(floor_date(meter_reads$timestamp, "day"))

daily_flow <- meter_reads %>%
    group_by(device_id) %>%
    reframe(date = daily_dates,
            # Book uses summarise, which was deprecated
            # reframe can return an arbitrary number of rows per group
            # summarise reduces each group down to a single row
            count = approx(x = timestamp,
                           y = count,
                           xout = daily_dates)$y) %>%
  mutate(volume = 5 * (count - lag(count))) %>%
  filter(!is.na(volume))

library(ggplot2)
ggplot(daily_flow, aes(volume)) +
  geom_histogram(binwidth = 100) +
  theme_minimal()

# Diurnal curves
diurnal <- meter_flow %>%
  mutate(timestamp_au = with_tz(timestamp, tzone = "Australia/Melbourne"),
         hour = hour(round_date(timestamp_au, "hour"))) %>%
  group_by(hour) %>%
  summarise(min_flow = min(flow) / 1000,
            mean_flow = mean(flow) / 1000,
            max_flow = max(flow) / 1000)

ggplot(diurnal, aes(x = hour, ymin = min_flow, ymax = max_flow)) +
  geom_ribbon(fill = "gray", alpha = 0.5) +
  geom_line(aes(x = hour, y = mean_flow), col = "black", linewidth = 1) +
  ggtitle("Connections Diurnal flow") +
  ylab(expression(Flow~m^3/h)) + 
  theme_bw(base_size = 10)
