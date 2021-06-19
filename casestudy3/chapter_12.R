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
library(lubridate)

Sys.Date()
today()

as.numeric(format(Sys.Date(), "%m"))
month(Sys.Date())

as.Date(paste(format(Sys.Date(), "%Y-%m"), "01", sep = "-"))
floor_date(Sys.Date(), unit = "month")

# Explore Digital Meting Data











