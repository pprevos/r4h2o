# Config code
options(crayon.enabled = FALSE)

Sys.Date()

as.numeric(Sys.Date())

# Format dates
format(Sys.Date(), "%A %d %B %Y")
format(Sys.Date(), "%d/%m/%Y")
format(Sys.Date(), "%B %d, %Y")

as.Date("2020-07-01")

as.Date("1 July 2020", format = "%d %B %Y")

d <- Sys.Date() - as.Date("1969-09-12")
d

as.numeric(d)

as.POSIXct("21 December 2020 12:23", format = "%d %B %Y %H:%M")

format(Sys.time(), tz = "UTC")

format(Sys.time(), tz = "NZ")

nzt <- Sys.time()
attr(nzt, "tzone") <- "NZ"
nzt
class(nzt)

as.POSIXct("21 December 2020 12:23",
           format = "%d %B %Y %H:%M",
           tz = "America/Vancouver")

library(tidyverse)
meter_reads <- read_csv("data/meter_reads.csv")

meters_subset <- filter(meter_reads, DeviceID == "RTU-1544773" &
                                     TimeStamp <= as.Date("2069-07-02"))

ggplot(meters_subset, aes(TimeStamp, Count * 5)) + 
  geom_line() + 
  labs(title = "Digital Meter Reads",
       subtitle = "RTU-640893",
       y = "Cumulative consumption [litres]")

library(lubridate)
meter_reads$TimeStampAU <- with_tz(meter_reads$TimeStamp,
                                   tzone = "Australia/Melbourne")

weekly <- meter_reads %>% 
    mutate(Week = ceiling_date(TimeStampAU, unit = "week")) %>% 
    group_by(DeviceID, Week) %>% 
    summarise(Consumption = (max(Count) - min(Count)) * 5) %>% 
    group_by(Week) %>% 
    summarise(Weekly_Consumption = sum(Consumption) / 1000)

ggplot(weekly, aes(Week, Weekly_Consumption)) + 
    geom_col(fill = "dodgerblue4") + 
    labs(title = "Weekly Consumption",
         subtitle = "Digital Meters",
         y = "Cumulative consumption [litres]") + 
    theme_minimal()

meter_reads[(24 * 365 - 1):(24 * 365 + 2), ]

flow <- meter_reads %>%
    group_by(DeviceID) %>%
    arrange(TimeStamp) %>%
    mutate(Flow = c(NA, diff(Count) * 5)) %>%
    select(-Count) %>%
    filter(!is.na(Flow))

flow %>%
    group_by(DeviceID) %>%
    summarise(Consumption = sum(Flow) / 1000) %>%
    arrange(desc(Consumption)) %>%
    top_n(10)
