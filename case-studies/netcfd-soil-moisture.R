## Analysing soil moisture data with the ncdf4 library

## Reading, Extracting and Transforming with the ncdf4 library
library(ncdf4)

bom <- nc_open("data/sm_pct.nc")

## Generate matrix
longitude <- ncvar_get(bom, "longitude")
latitude <- ncvar_get(bom, "latitude")
month <- as.Date("1900-01-01") + ncvar_get(bom, "time")

moisture <- ncvar_get(bom, "sm_pct")
dimnames(moisture) <- list(longitude, latitude, month)

## Visualising the data with ggplot
library(ggplot2)
library(dplyr)
library(reshape2)
library(ozmaps)


plot_date <- "2025-05-31"

## Generate data frame
soil_moisture <- moisture[, , which(month == plot_date)] %>%
  melt(varnames = c("longitude", "latitude")) %>%
  subset(!is.na(value))

## State boundaries
sf_aus <- ozmap("states")

ggplot(soil_moisture) + 
  geom_tile(aes(x = longitude, y = latitude, fill = value)) +
  scale_fill_gradient(low = "chocolate4", high = "dodgerblue", name = NULL) + 
  geom_sf(data = sf_aus, fill = NA, col = "white") + 
  labs(title = "Relative Total rootzone soil moisture (0-100 cm)",
       subtitle = format(as.Date(plot_date), "%d %B %Y"),
       caption = "Source: Australian Landscape Water Balance AWRA-L Model") + 
  theme_void()

## Plot on Google Maps
library(ggmap)

api <- readLines("case-studies/google-maps.api") # Text file with the API key
register_google(key = api)

ggmap(get_map("Australia", zoom = 4, color = "bw")) +
  geom_tile(data = soil_moisture, 
            aes(x = longitude, y = latitude, fill = value), alpha = 0.5) +
  scale_fill_gradient(low = "chocolate4", high = "dodgerblue", name = NULL) + 
  labs(title = "Relative Total rootzone soil moisture (0-100 cm)",
       subtitle = format(as.Date(plot_date), "%d %B %Y"),
       caption = "Source: Australian Landscape Water Balance AWRA-L Model") + 
  theme_void()

## Time series
location <- round(geocode("Bendigo, Australia") / 0.05) * 0.05 

soil_moisture_time <- tibble(month,
                             moisture = moisture[as.character(location$lon), 
                                                 as.character(location$lat), ]) %>% 
  filter(month >= "2000-01-01")

ggplot(soil_moisture_time) + 
  geom_line(aes(x = month, y = moisture)) +
  labs(title = "Relative Total rootzone soil moisture (0-100 cm)",
       subtitle = paste(as.character(location), collapse = ", "),
       caption = "Source: Australian Landscape Water Balance AWRA-L Model",
       x = NULL, y = "Relative Soil Moisture") + 
  theme_minimal(base_size = 16)
