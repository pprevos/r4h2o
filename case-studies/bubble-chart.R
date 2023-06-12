# Water consumption bubble chart

water <- read.csv("data/viet-tri-consumption.csv")
water$Consumption <- water$read_new - water$read_old

## Summarise the data
summary(water$Consumption)

## Plot on Google Maps
library(ggmap)

api <- readLines("case-studies/google-maps.api") # Text file with the API key
register_google(key = api)

centre <- c(mean(range(water$lon)), mean(range(water$lat)))
viettri <- get_map(centre, zoom = 17, maptype = "hybrid")
g <- ggmap(viettri)

# Add data to ggmap

g + geom_point(data = water, aes(x = lon, y = lat, size = Consumption),
               shape = 21, colour = "dodgerblue4", fill = "dodgerblue", 
               alpha = .8) +
  scale_size_area(max_size = 30) + # Size of the biggest point
  ggtitle("Việt Trì sự tiêu thụ nước")
