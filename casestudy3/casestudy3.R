## Analyse smart meter data
library(tidyverse)

## Consumer involvement
pii <- read_csv("casestudy2/involvement_tidy.csv")

table(pii$Score, useNA = "always")

a <- c(1, 3, NA, 5, 6)
sum(a)
sum(a, na.rm = TRUE)

involvement <- pii %>%
    group_by(id) %>%
    summarise(pii = sum(Score))

ggplot(involvement, aes(pii)) + 
    geom_histogram(fill = "indianred4", col = "white", binwidth = 1) + 
    geom_vline(xintercept = mean(involvement$pii, na.rm = TRUE), col = "orange") + 
    labs(title = "Personal Involvement Index for tapwater",
         subtitle = paste("n = ", nrow(involvement))) + 
    theme_bw()
ggsave("manuscript/resources/session7/involement_scores.png", width = 8, height = 6)

## How many NA values are there in the involvement data frame?
table(involvement$pii, useNA = "always")

filter(involvement, is.na(pii)) %>%
    count()

## Read the data
reads <- read_csv("casestudy3/meter_reads.csv")
glimpse(reads)

## Determine flow rate
v <- c(1, 2, 3, 4, 5)
diff(v)

summary(diff(reads$Count))

reads[(24 * 365 - 1):(24 * 365 + 2), ]

flow <- reads %>%
    group_by(DeviceID) %>%
    arrange(DeviceID, TimeStamp) %>%
    mutate(Flow = c(NA, diff(Count) * 5)) %>%
    select(-Count) %>%
    filter(!is.na(Flow))
write_csv(flow, "casestudy3/flow.csv")


filter(flow, DeviceID == "RTU-210156") %>%
    slice(1:48) %>%
    ggplot(aes(TimeStamp, Flow)) + 
    geom_line() + 
    ylim(0, 100) + 
    labs(title = "Flow profile",
         subtitle = "RTU-210156")
ggsave("manuscript/resources/session7/flow-profile.png", width = 8, height = 6)

## Total and mean consumption per property
top10 <- flow %>%
    group_by(DeviceID) %>%
    summarise(Consumption = sum(Flow) / 1000) %>%
    arrange(desc(Consumption)) %>%
    top_n(10)

top10 <- flow %>%
    group_by(DeviceID) %>%
    summarise(Consumption = sum(Flow) / 1000) %>%
    arrange(desc(Consumption)) %>%
    slice(1:10)

ggplot(top10, aes(DeviceID, Consumption)) + 
    geom_col(fill = "dodgerblue4") + 
    coord_flip() + 
    labs(title = "Top-10 consumption")
ggsave("manuscript/resources/session7/top10.png", width = 8, height = 6)

factor(top10$DeviceID)

top10$DeviceID <- factor(top10$DeviceID, levels = top10$DeviceID[order(top10$Consumption)])

ggplot(top10, aes(DeviceID, Consumption)) + 
    geom_dotplot(fill = "dodgerblue4", method="histodot") + 
    coord_flip() + 
    labs(title = "Top-10 consumption")

## Date and time
range(flow$TimeStamp)

filter(flow, TimeStamp >= as.Date("2069-05-01"), TimeStamp <= as.Date("2069-05-31"))

## Days alive
birth <- as.Date("1977-03-03")
now <- as.Date("2019-07-17")

d <- now - birth
print(d)
class(d)

Sys.Date() - birth

sqrt(d)

sqrt(as.numeric(d))

## Visualise daily consumption
filter(flow, TimeStamp >= as.Date("2069-06-01"), TimeStamp <= as.Date("2069-06-14")) %>%
    group_by(Date = as.Date(TimeStamp)) %>%
    summarise(Daily = sum(Flow)) %>%
    ggplot(aes(Date, Daily)) + 
    geom_line() + 
    labs(title = "Daily flow Gormsey pilot study",
         subtitle = "June 2069")
ggsave("manuscript/resources/session7/daily.png", width = 8, height = 6)

## Lubridate
library(lubridate)

month(as.Date("2019-07-17"))
year(as.Date("2019-07-17"))
day(as.Date("2019-07-17"))


## Monthly flow
flow %>%
    group_by(Month = month(TimeStamp, label = TRUE, abbr = TRUE)) %>%
    summarise(Consumption = sum(Flow) / 1000) %>%
    ggplot(aes(factor(Month), Consumption)) + 
    geom_col(fill = "dodgerblue4") + 
    labs(title = "Monthly consumption",
         x = "Month", y = "Consumption [kL]")

## Leaking properties
flow %>%
    group_by(DeviceID) %>%
    summarise(MinFlow = min(Flow)) %>%
    filter(MinFlow != 0)

