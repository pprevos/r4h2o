########################################################
#
# R4H2O: 5: VISUALISING WATER QUALITY DATA WITH GGPLOT2
#
########################################################

# Libraries
library(readr)
library(dplyr)

# Load data

labdata <- read_csv("data/water_quality.csv")

turbidity <- filter(labdata, Measure == "Turbidity")

## BASE R

# Time series
plot(turbidity$Date, turbidity$Result, type = "l")

# Histograms

hist(turbidity$Result, main = "No transformation")
hist(log(turbidity$Result), main = "Log transformation")

# Changing the breaks parameter

hist(log(turbidity$Result), breaks = 5)

# Box (and whisker) plots

par(mar = c(8, 4, 4, 1))
boxplot(data = turbidity, log10(Result) ~ Suburb, las = 2,
        xlab = NULL, main = "Gormsey Turbidity Samples")

# Range parameter 10

boxplot(data = turbidity, log10(Result) ~ Suburb, range = 10)

## GGPLOT 2

# Data layer

library(ggplot2)
ggplot(labdata)

# Add aesthetics

ggplot(labdata, aes(Measure))

# Other aesthetics

ggplot(labdata, aes(Date, Result))

# Geometries layer

# Bar chart

ggplot(labdata, aes(Measure)) + 
  geom_bar()

# Coloured bar chart

ggplot(labdata, aes(Measure)) + 
  geom_bar(fill = "#78417A")

# Line chart geometry, coloured by suburb

ggplot(turbidity, aes(Date, Result, col = Suburb)) + 
  geom_line()

# Setting colour palettes

ggplot(labdata, aes(Suburb, fill = Measure)) +
  geom_bar() +
  scale_fill_brewer(type = "qual", palette = "Set1")

RColorBrewer::display.brewer.all()

ggplot(labdata, aes(Suburb, fill = Measure)) +
  geom_bar() +
  scale_fill_manual(values = c("cornflowerblue",
                               "darkseagreen",
                               "#ee6611",
                               "#ccaa44"))

# Facets layer

ggplot(turbidity, aes(Date, Result)) + 
  geom_line() + 
  facet_wrap(~Suburb)

# Statistics

library(dplyr)
thm <- filter(labdata, Measure == "THM")
thm_grouped <- group_by(thm, Date)
thm_max <- summarise(thm_grouped, thm_max = max(Result))

ggplot(thm_max, aes(Date, thm_max)) + 
  geom_smooth(method = "lm") + 
  geom_line() + 
  geom_hline(yintercept = 0.25, col = "red")

# Coordinates

ggplot(turbidity, aes(Suburb, Result)) + 
  geom_boxplot() + 
  scale_y_log10(name = "Samples (log)", n.breaks = 10) +
  coord_flip()

# Themes

ggplot(turbidity, aes(Date, Result)) + 
  geom_line() + 
  facet_wrap(~Suburb, ncol = 1) + 
  theme_void(base_size = 12)

ggplot(labdata, aes(Measure)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90))

# Sharing visualisations

limits <- data.frame(Measure = c("Chlorine Total", "Chlorine Total",
                                 "THM", "Turbidity"),
                     Limit = c(1, 2, 0.25, 5))

ggplot(filter(labdata, Measure != "E. coli" & 
                       Suburb %in% c("Merton", "Tarnstead", "Blancathey")),
       aes(Date, Result)) +
  geom_hline(data = limits, aes(yintercept = Limit),
             col = "red", linetype = 2) + 
  geom_line(size = .5) +
  facet_grid(Measure ~ Suburb, scales = "free_y") +
  scale_x_date(date_labels = "%Y", date_breaks = "2 years") +
  theme_minimal(base_size = 11) + 
  labs(title = "Gormsey Laboratory Data",
       subtitle = "Operational and regulatory compliance",
       caption = "Source: Gormsey Laboratory")

ggsave("gormsey_labdata.pdf", width = 297, height = 210, units = "mm")
