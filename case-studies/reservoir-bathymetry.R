# Bathymetry visualisation and analysis

# libraries
library(tidyverse)
library(RColorBrewer)

rm(list = ls())

# Data source
# http://www.mgs.md.gov/publications/data_pages/reservoir_bathymetry.html

if (!file.exists("data/PrettyBoy1998.dat")) {
  download.file("http://www.mgs.md.gov/output/reservoir_bathy/PrettyBoy1998.zip",
                destfile = "data/prettyboy-1998.zip")
  unzip("data/prettyboy-1998.zip", exdir = "data")
  file.remove("data/prettyboy-1998.zip")
}

# Read data
rawdata <- read.csv("data/PrettyBoy1998.dat", skip = 1)
fsl <- 145 # Full Supply Level

# Data cleaning
prettyboy <- rawdata |>
  rename(easting = 1, northing = 2, depth_ft = 3) |>
  filter(!duplicated(rawdata) & !(easting %in% range(easting))) |> 
  mutate(depth_m = depth_ft * 0.304)

# Basic Visualisation
bathymetry_colours <- c(rev(brewer.pal(3, "Greens"))[-2:-3], 
                        brewer.pal(9, "Blues")[-1:-3])

ggplot(prettyboy) + 
  aes(easting, northing, colour = depth_m) + 
  geom_point(size = .1) + 
  scale_x_continuous(labels = scales::label_comma()) + 
  scale_y_continuous(labels = scales::label_comma()) + 
  coord_equal() + labs(colour = "Depth [m]") + 
  scale_colour_gradientn(colors = bathymetry_colours) +
  labs(title = "Prettyboy Reservoir Bathymetry (1988)",
       caption = "Source: Maryland Geological Survey",
       x = "Easting (UTM NAD83)", y = "Northing (UTM NAD83)") + 
  theme_minimal(base_size = 8)

# Spatial mapping
library(sf)

# Convert prettyboy tibble to an sf object
prettyboy_sf <- st_as_sf(prettyboy,
                         coords = c("easting", "northing"),
                         crs = 26918)   # NAD83 / UTM zone 18N

# Transform to latitude/longitude (WGS84)
prettyboy_wgs <- st_transform(prettyboy_sf, crs = 4326)

# Convert back to tibble with lat/lon columns
coords <- st_coordinates(prettyboy_wgs)

prettyboy_wgs <- cbind(prettyboy_wgs, coords) |>
  rename(lon = X, lat = Y) |>
  st_drop_geometry()

library(ggmap)
## Register Google Maps API
api <- readLines("data/google-maps.api")
register_google(key = api)
prettyboy_map <- get_map(c(mean(prettyboy_wgs$lon), 
                           mean(prettyboy_wgs$lat)),
                         zoom = 14, color = "bw")

ggmap(prettyboy_map, extent = "device") + 
  geom_point(data = as_tibble(prettyboy_wgs), 
             aes(lon, lat, col = depth_m), size = 0.1) +
  scale_colour_gradientn(colors = bathymetry_colours, name = "Depth [m]") + 
  labs(title = "Prettyboy Reservoir Bathymetry (1988)",
       caption = "Source: Maryland Geological Survey") + 
  theme_void(base_size = 10)

# Extrapolate gridded version
library(akima)

# Grid size [m]
dx <- 10
dy <- 10

# Regular grid coordinates
x_seq <- seq(min(prettyboy$easting), max(prettyboy$easting), by = dx)
y_seq <- seq(min(prettyboy$northing), max(prettyboy$northing), by = dy)

# Interpolate scattered (x, y, depth) -> regular grid
# no extrapolation outside convex hull
interp_res <- with(prettyboy,
                   interp(x = easting,
                          y = northing,
                          z = depth_m,
                          xo = x_seq,
                          yo = y_seq,
                          duplicate = "strip",
                          linear = TRUE,
                          extrap = FALSE))

# Volume
prettyboy_grid <- interp2xyz(interp_res, data.frame = TRUE) |>
  as_tibble() |>
  rename(easting = x, northing = y, depth_m = z)

grid_volume_m3 <- sum(prettyboy_grid$depth_m * dx * dy, na.rm = TRUE)
grid_volume_m3 / 100^3

# Visualise Cross sections
set.seed(1234)
northing_sections <- sample(prettyboy_grid$northing, 4)
prettyboy_sections <- filter(prettyboy_grid, northing %in% northing_sections)
max_depth <- round(max(prettyboy_sections$depth_m, na.rm = TRUE))

map <- ggplot(filter(prettyboy_grid)) + 
  aes(easting, northing) +
  geom_raster(aes(fill = depth_m), interpolate = TRUE) +
  geom_contour(aes(z = depth_m), colour = "white", alpha = 0.4) +
  geom_hline(yintercept = northing_sections, col = "orange") + 
  coord_equal() +
  scale_x_continuous(labels = scales::label_comma()) + 
  scale_y_continuous(labels = scales::label_comma()) + 
  scale_fill_gradientn(
    colours = c(NA, bathymetry_colours[-1]),
    na.value = "transparent",
    guide = guide_colourbar(reverse = TRUE),
    name = "Depth [m]") +
  theme_minimal(base_size = 28) +
  labs(title = "Prettyboy Reservoir",
       caption = "Source: Maryland Geological Survey",
       x = "Easting [m]", y = "Northing [m]") + 
  theme(legend.position = "bottom", 
        legend.key.width = unit(2, 'cm'))

sections <- ggplot(prettyboy_sections) + 
    aes(easting, (fsl - depth_m)) + 
    geom_area(fill = bathymetry_colours[1], alpha = 0.5) +  
    scale_x_continuous(labels = scales::label_comma()) + 
    facet_wrap(~rev(northing), ncol = 1) +
    coord_cartesian(ylim = c(fsl - 1.1 * max(prettyboy_sections$depth_m, na.rm = TRUE), fsl)) +
    theme_minimal(base_size = 28) +
    labs(x = "Easting [m]", y = "Elevation [m]")

library(gridExtra)
png(filename = "prettyboy-sections.png", width = 1920, height = 940, units = "px")
grid.arrange(map, sections, ncol = 2)
dev.off()

# Triangulated Irregular Network
library(geometry) 
library(purrr)

# 2D coordinates
coords2d <- as.matrix(prettyboy[, c("easting", "northing")])

# Delaunay triangulation
tri <- delaunayn(coords2d)

# Convert the triangles into a long data frame for ggplot
tin_df <- map_dfr(seq_len(nrow(tri)), function(i) {
  idx <- tri[i, ]
  data.frame(
    tri_id   = i,
    easting  = prettyboy$easting[idx],
    northing = prettyboy$northing[idx],
    depth_m  = prettyboy$depth_m[idx])})

triangle_area_shoelace <- function(x, y) {
  abs(x[1] * (y[2] - y[3]) +
      x[2] * (y[3] - y[1]) +
      x[3] * (y[1] - y[2])) / 2}

tin_volume <- tin_df |>
  dplyr::group_by(tri_id) |>
  dplyr::summarise(
           area       = triangle_area_shoelace(easting, northing),
           mean_depth = mean(depth_m),
           volume     = area * mean_depth,
           .groups    = "drop")

tin_volume_m3 <- sum(tin_volume$volume)
tin_volume_m3 / 1e6

# Capacity Curve
# levels to evaluate
levels <- seq(fsl + 15 - round(max(prettyboy$depth_m) / 10) * 10, fsl, by = 1)

grid_capacity <- tibble(level = levels) |>
  mutate(volume_m3 = map_dbl(level, \(L) {
    bed <- fsl - prettyboy_grid$depth_m
    depth_L <- pmax(0, L - bed)
    sum(depth_L * dx * dy, na.rm = TRUE)}))

# Cubic regression
cubic <- lm(volume_m3 ~ poly(level, 3, raw = TRUE), data = grid_capacity)

grid_capacity$cubic = predict(cubic)
  
ggplot(grid_capacity) + 
  aes(level, volume_m3 / 1E3) + 
  geom_point(col = "grey") + 
  geom_line(aes(level, cubic / 1E3)) + 
  geom_hline(yintercept = grid_volume_m3 / 1E3, linetype = 6, col = "red") + 
  scale_y_continuous(labels = scales::label_comma()) + 
  theme_minimal() + 
  labs(title = "Prettyboy Reservoir Capacity Curve",
       x = "Water level", y = expression(Volume~km^3))

