## R4H2O: Data Science for Water Professionals
## Chapter 12: Dates and Times

# Base date and time functions

# Dates
Sys.Date()
as.numeric(Sys.Date())

format(Sys.Date(), "%A %d %B %Y")

format(Sys.Date(), "%B %d, %Y")

as.Date("2020-07-01")

as.Date("1 July 2020")

as.Date("1 July 2020", format = "%d %B %Y")

d <- Sys.Date() - as.Date("1977-03-13")

sqrt(d)

sqrt(as.numeric(d))

# Times
help(strptime)

as.POSIXct("21 December 2020 12:23", format = "%d %B %Y %H:%M")

# Timezones
Sys.timezone()     

format(Sys.time(), tz = "UTC")
format(Sys.time(), tz = "NZ")

OlsonNames()

nzt <- Sys.time()
attr(nzt, "tzone") <- "NZ"
nzt

lju <- Sys.time()
attr(lju, "tzone") <- "Europe/Ljubljana"
lju

as.POSIXct("21 December 2020 12:23", format = "%d %B %Y %H:%M", tz = "Israel")

# Lubridate
library(tidyverse)
library(lubridate)

Sys.Date()
today()

as.numeric(format(Sys.Date(), "%m"))
month(Sys.Date())

as.Date(paste(format(Sys.Date(), "%Y-%m"), "01", sep = "-"))
floor_date(Sys.Date(), unit = "month")

# Explore Digital Meting Data
meters <- read_csv("casestudy3/meter_reads.csv")
meters_subset <- filter(meters, TimeStamp >= "2069-05-01" & 
                          TimeStamp < "2069-05-10" & 
                          DeviceID == "RTU-640893")
ggplot(meters_subset, aes(TimeStamp, Count * 5)) + 
  geom_line() + 
  labs(title = "Digital Meter Reads",
       subtitle = "RTU-640893",
       y = "Cumulative consumption [litres]") + 
  theme_minimal()
ggsave("manuscript/resources/12_dates_times/meter-reads.png")

meters_au <- meters  %>% 
  mutate(TimeStampAU = with_tz(TimeStamp, tzone = "Australia/Melbourne"))

weekly <- meters_au %>% 
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






