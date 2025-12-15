## Cheesecake diagram
library(tidyverse)
library(ggmap)
library(RColorBrewer)

## Register Google Maps API
api <- readLines("data/google-maps.api")
register_google(key = api)

## Create mock performance data
## Towns with water treatment plants
towns <- c("Bendigo", "Boort", "Bridgewater", "Castlemaine", "Cohuna", "Echuca", 
           "Elmore", "Goornong", "Gunower", "Heathcote", "Korong Vale", "Kyneton", 
           "Laanecoorie", "Leitchville", "Lockington", "Pyramid Hill", "Rochester", 
           "Serpentine", "Trentham")
t <- length(towns)

## Volume produced
## https://www.coliban.com.au/files/2019-10/FINAL_CW_AnnualReport2019_200919pm.pdf p. 24
consumption <- c(11682, 138, 141, 2064, 610, 3017, 106, 44, 48, 243, 117, 862, 106, 161, 55, 84, 857, 17, 94)

set.seed(1969)
performance <- tibble(Town = towns) %>%
    bind_cols(geocode(paste(towns, "Victoria, Australia"))) %>%
    mutate(Consumption = consumption,
           Treatment = sample(0:100, t),
           Network = sample(0:100, t),
           Regulation = sample(0:100, t),
           Perception = sample(0:100, t),
           Performance = round((Treatment + Network + Regulation + Perception) / 4))

## Get map
map <- get_map(location = c(lon = mean(performance$lon), lat = mean(performance$lat)), 
               color = "bw", zoom = 8)

## Single variable
ggmap(map, extent = "device") + 
    geom_point(data = performance,
               aes(lon, lat, size = sqrt(Consumption), col = Performance),
               alpha = 0.9) +
    scale_size_area(max_size = 18, guide = "none") +
    scale_color_gradientn(colors = brewer.pal(7, "RdYlBu")) +
    labs(title = "System Performance",
         subtitle = "Simulated data") +
    theme_void(base_size = 8)

## Cheesecake diagram
library(ggforce)
library(gridExtra)

## Convert data
cheesecake = pivot_longer(performance, -1:-4,
                          names_to = "Aspect",
                          values_to = "Performance") %>%
  filter(Aspect != "Performance") %>%
  mutate(start = rep(seq(0, 2 * pi, length.out = 5)[-5], t),
         end = rep(seq(0, 2 * pi, length.out = 5)[-1], t))

## Legend
cheesecake_legend <- tibble(x0 = c(.1, .1, -.1, -.1),
                            y0 = c(.1, -.1, -.1, .1),
                            start = seq(0, 2 * pi, length.out = 5)[-5],
                            end = seq(0, 2 * pi, length.out = 5)[-1],
                            dimension = unique(cheesecake$Aspect))

l <- ggplot(cheesecake_legend) +
  aes(x0 = x0, y0 = y0, r0 = 0, r = 1, start = start, end = end) +
  geom_arc_bar(col = NA, fill = "chocolate") +
  geom_text(aes(x0 * 6, y0 * 6,
                label = unique(cheesecake$Aspect)), size = 2) + 
  theme_void() +
  coord_equal()

## Visualise
m <- ggmap(map, extent = "device",
           base_layer = ggplot(data = cheesecake,
                               aes(x0 = lon,
                                   y0 = lat,
                                   r0 = 0,
                                   r = .1,
                                   start = start,
                                   end = end,
                                   fill = Performance))) +
  geom_arc_bar(col = "darkgrey", size = .1) +
  scale_size_area(max_size = 12, guide = FALSE) +
  scale_fill_gradientn(colors = brewer.pal(7, "RdYlBu")) +
  labs(title = "System Performance",
       subtitle = "Simulated data")  +
  theme_void(base_size = 4)

bbox <- make_bbox(range(performance$lon), range(performance$lat), f = .1)

m + coord_cartesian() + 
  coord_equal() +
  annotation_custom(grob = ggplotGrob(l),
                    xmin = bbox[3] - .3, xmax = bbox[3],
                    ymin = bbox[4] - .3, ymax = bbox[4])

