## R4H2O: Data Science for Water Professionals
## Chapter 6: Visualise data

library(tidyverse)
gormsey <- read_csv("casestudy1/gormsey.csv")

# Data and Aesthetics
ggplot(gormsey)

ggplot(gormsey, aes(Town))
ggsave("manuscript/resources/06_visualisation/towns_canvas.png", width = 9, height = 5)

ggplot(gormsey, aes(Town)) + 
    geom_bar()
ggsave("manuscript/resources/06_visualisation/towns_bars.png", width = 9, height = 5)

turbidity <- filter(gormsey, Measure == "Turbidity")

ggplot(turbidity, aes(Date, Result, col = Town)) + 
    geom_line()
ggsave("manuscript/resources/06_visualisation/time_series.png", width = 9, height = 5)

# Geometries
ggplot(turbidity, aes(Town, Result, fill = Town)) + 
    geom_boxplot() +
    scale_y_log10()
ggsave("manuscript/resources/06_visualisation/boxplot.png", width = 9, height = 5)

# Facets
ggplot(turbidity, aes(Date, Result, col = Town)) + 
    geom_line() + 
    facet_wrap(~Town)
ggsave("manuscript/resources/06_visualisation/facets.png", width = 9, height = 5)

# Statistics
thm <- filter(gormsey, Measure == "THM")
thm_date <- group_by(thm, Date)
thm_max <- summarise(thm_date, thm_max = max(Result))

ggplot(thm_max, aes(Date, thm_max)) + 
    geom_line() + 
    geom_smooth(method = "lm") + 
    geom_hline(yintercept = 0.25, col = "red")
ggsave("manuscript/resources/06_visualisation/thm_trend.png", width = 9, height = 5)

# Coordinates
ggplot(turbidity, aes(Town, Result, fill = Town)) + 
    geom_boxplot() +
    scale_y_log10() +
    coord_flip()

# Themes
ggplot(turbidity, aes(Date, Result)) + 
    geom_area(fill = "red", col = "black") + 
    facet_wrap(~Town, ncol = 1) + 
    theme_void()
ggsave("manuscript/resources/06_visualisation/sparklets.png", width = 9, height = 5)


ggplot(filter(turbidity, Town == "Strathmore"), aes(Date, Result)) + 
    geom_line() +
    geom_hline(yintercept = 5, col = "red") + 
    labs(title = "Turbidity Results", 
         subtitle = "Strathmore customer taps",
         caption = "Source: Gormsey laboratory",
         x = "Date sampled", y = "NTU") + 
    theme_bw()
ggsave("manuscript/resources/06_visualisation/labels.png")

