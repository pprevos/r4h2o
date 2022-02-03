# Case Study 1b

# Load data
library(tidyverse)
gormsey <- read_csv("casestudy1/gormsey.csv")


# Base Plotting
turbidity <- filter(gormsey, Measure == "Turbidity")

plot(turbidity$Date, turbidity$Result,
     type = "l",
     xlab = "Date",
     ylab = "Result",
     main = "Turbidity measurements")
abline(h = 5, col = "red")

boxplot(log10(Result) ~ Town, data = turbidity,
        pch = 19, las = 3, col = "brown",
        main = "Turbidity measurements")
abline(h = log10(5), col = "red")

p95 <- summarise(group_by(turbidity, Town),
                 p95 = quantile(Result, 0.95))

barplot(p95$p95, names.arg = p95$Town)
abline(h = 5, col = "red")

## ggplot2
ggplot(gormsey)

ggplot(gormsey, aes(Town))

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

# Statistics
thm <- filter(gormsey, Measure == "THM")
thm_grouped <- group_by(thm, Date)
thm_max <- summarise(thm_grouped, thm_max = max(Result))

ggplot(thm_max, aes(Date, thm_max)) +
    geom_smooth(method = "lm") +
    geom_line() +
    geom_hline(yintercept = 0.25, col = "red")

# Coordinates
ggplot(turbidity, aes(Town, Result)) +
    geom_boxplot() +
    scale_y_log10(name = "Samples (log)",
                  n.breaks = 10) +
    coord_flip()

# Themes
ggplot(gormsey, aes(Measure)) +
    geom_bar() +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 90))

ggsave("casestudy1/measures.png", width = 15, height = 10, dpi = 300, units = "cm")























