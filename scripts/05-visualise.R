########################################
# R4H2O: 6: Visualising data with ggplot2
#########################################

# Load data

library(readr)
labdata <- read_csv("data/labdata.csv")

# Data layer

library(ggplot2)
ggplot(labdata)

# Add aesthetics

ggplot(labdata, aes(Measure))

# Other aesthetics

ggplot(labdata, aex(Date, Result))

# Geometries layer

# Bar chart

ggplot(labdata, aes(Measure)) + 
    geom_bar()

# Coloured bar chart
ggplot(labdata, aes(Measure)) + 
  geom_bar(fill = "#78417A")

# Line chart geometry, coloured by suburb

turbidity <- dplyr::filter(labdata, Measure == "Turbidity")

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

ggplot(turbidity, aes(Date, Result, col = Suburb)) + 
    geom_line() + 
    facet_wrap(~Suburb)

# Remove legend

ggplot(turbidity, aes(Date, Result, col = Suburb)) + 
    geom_line() + 
    facet_wrap(~Suburb)+
    scale_colour_brewer(type = "qual", guide = NULL)

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

limits <- data.frame(Measure = c("Chlorine Total", "E. coli",
                                 "THM", "Turbidity", "Chlorine Total"),
                     Limit = c(1, 0, 0.25, 5, 2))

ggplot(labdata, aes(Date, Result)) +
  geom_line(size = .1) +
  geom_hline(data = limits, aes(yintercept = Limit),
             col = "red", linetype = 2) + 
  facet_grid(Measure ~ Suburb, scales = "free_y") +
  scale_x_date(date_labels = "%y", date_breaks = "1 years") +
  theme_minimal() + 
  labs(title = "Gormsey Laboratory Data",
       subtitle = "Operational and regulatory compliance",
       caption = "Source: Gormsey Laboratory")

ggsave("gormsey_labdata.pdf", width = 297, height = 210, units = "mm")
