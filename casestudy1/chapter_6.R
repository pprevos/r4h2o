# Visualise

library(tidyverse)
gormsey <- read_csv("casestudy1/gormsey.csv")

# Data
ggplot(gormsey)

ggplot(gormsey, aes(Measure))

# Geometries
ggplot(gormsey, aes(Measure)) +
    geom_bar()


turbidity <- filter(gormsey, Measure == "Turbidity")

ggplot(turbidity, aes(Date, Result, col = Town)) +
    geom_line()

ggplot(gormsey, aes(Town, fill = Measure)) +
    geom_bar() +
    scale_fill_brewer(type = "qual",
                      palette = "Dark2")

library(RColorBrewer)
display.brewer.all()

ggplot(gormsey, aes(Town, fill = Measure)) +
     geom_bar() +
     scale_fill_manual(values = c("cornflowerblue",
                                  "darkseagreen",
                                  "#ee6611",
                                  "#ccaa44"))


# Facets
ggplot(turbidity, aes(Date, Result, col = Town)) +
    geom_line() +
    facet_wrap(~Town)

ggplot(gormsey, aes(Date, Result)) +
    geom_line() +
    facet_grid(Town~Measure, scales = "free_y")


thm <- filter(gormsey, Measure == "THM")
thm_grouped <- group_by(thm, Date)
thm_max <- summarise(thm_grouped, thm_max = max(Result))

ggplot(thm_max, aes(Date, thm_max)) +
    geom_smooth(method = "lm") +
    geom_line() +
    geom_hline(yintercept = 0.25, col = "red")

ggplot(turbidity, aes(Town, Result)) +
    geom_boxplot() +
    scale_y_log10(name = "Samples (log)",
                  n.breaks = 10) +
    coord_flip()

# Themes
ggplot(turbidity, aes(Date, Result)) +
     geom_line() +
     facet_wrap(~Town, ncol = 1) +
     theme_void(base_size = 12)

ggplot(turbidity, aes(Date, Result)) +
    geom_area(fill = "red", col = "black") +
    facet_wrap(~Town, ncol = 1) +
    theme_void()

# Axes
ggplot(gormsey, aes(Measure)) +
    geom_bar() +
    theme(axis.text.x = element_text(angle = 90))

ggplot(filter(turbidity, Town == "Tarnstead"), aes(Date, Result)) +
  geom_line() +
  geom_hline(yintercept = 5, col = "red", linetype = 2) +
  labs(title = "Turbidity Spikes",
       subtitle = "Strathmore customer taps",
       caption = "Source: Gormsey laboratory",
       x = "Date sampled", y = "NTU") +
  theme_bw(base_size = 10)

ggsave("test.png", width = 15, height = 10, dpi = 320, units = "cm")

