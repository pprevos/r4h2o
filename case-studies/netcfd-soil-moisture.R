# Analysing soil moisture data with the ncdf4 library

# Reading, Extracting and Transforming with the ncdf4 library
library(ncdf4)

bom <- nc_open("data/ss_pct_Actual_month.nc")

print(bom) # Inspect the data

lon <- ncvar_get(bom, "longitude")
lat <- ncvar_get(bom, "latitude")
t <- as.Date("1900-01-01") + ncvar_get(bom, "time")

moisture <- ncvar_get(bom, "ss_pct")
dimnames(moisture) <- list(lon, lat, t)

# Visualising the data with ggplot
library(tidyverse)
library(RColorBrewer)
library(reshape2)

d <- "2017-07-31"
m <- moisture[, , which(t == d)] %>%
  melt(varnames = c("lon", "lat")) %>%
  subset(!is.na(value))

ggplot(m, aes(x = lon, y = lat, fill = value)) + 
  borders("world") +
  geom_tile() +
  scale_fill_gradientn(colors = brewer.pal(9, "Blues")) +
  labs(title = "Total moisture in deep soil layer (100-500 cm)",
       subtitle = format(as.Date(d), "%d %B %Y")) +
  xlim(range(lon)) + 
  ylim(range(lat)) + 
  coord_fixed()

library(ggmap)
api <- readLines("case-studies/google-maps.api") # Text file with the API key
register_google(key = api)

loc <- round(geocode("Bendigo") / 0.05) * 0.05 

get_map(loc, zoom = 12) %>%
  ggmap() +
  geom_tile(data = m, aes(x = lon, y = lat, fill = value), alpha = 0.5) +
  scale_fill_gradientn(colors = brewer.pal(9, "Blues")) +
  labs(title = "Total moisture in deep soil layer (100-500 cm)",
       subtitle = format(as.Date(d), "%d %B %Y"))

mt <- data.frame(date = t,
                 dp = moisture[as.character(loc$lon), as.character(loc$lat), ])

ggplot(mt, aes(x = t, y = dp)) + geom_line() +
  labs(x = "Month",
       y = "Moisture",
       title = "Total moisture in deep soil layer (100-500 cm)",
       subtitle = paste(as.character(loc), collapse = ", "))
