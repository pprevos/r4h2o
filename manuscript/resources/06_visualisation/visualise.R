## R4H2O: Data Science for Water Professionals
## Chapter 6 images

library(tidyverse)
gormsey <- read_csv("casestudy1/gormsey.csv")

## Figure 6.3
## library(devtools)
## devtools::install_github("hilaryparker/cats")

library(cats)

bad <- ggplot(comparison, aes(item, value, fill = item)) +
    add_cat(bw = FALSE) +
    geom_col(alpha = 0.5, col = "black") +
    scale_fill_discrete(name = "Brand") + 
    theme_gray(base_size = 40) +
    theme(legend.position="left", legend.key.size = unit(5,"line"),
          plot.title = element_text(face = "bold")) +
        labs(title= "Cat food sales",
         subtitle = "Low Data-Pixel Ratio",
         x = "Brand", y = "Sales")

bad
comparison$item <- factor(comparison$item, level = comparison$item[order(comparison$value)])

good <- ggplot(comparison, aes(item, value)) +
    geom_col(fill = "#002859", alpha = 0.7) +
    theme_minimal(base_size = 40) +
    theme(plot.title = element_text(face = "bold")) + 
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
    labs(title= "Cat food sales",
         subtitle = "High Data-Pixel Ratio",
         x = "Brand", y = "Sales")

png("manuscript/resources/06_visualisation/data-pixel-ratio2.png", width = 1920, height = 1080)
grid.arrange(bad, good, ncol = 2, widths = c(1.1, 0.9))
dev.off()

## Figure 6.6
ggplot(gormsey, aes(Town))
ggsave("manuscript/resources/06_visualisation/towns_canvas.png", width = 9, height = 5)

## Figure 6.7
ggplot(gormsey, aes(Town)) + 
    geom_bar()
ggsave("manuscript/resources/06_visualisation/towns_bars.png", width = 9, height = 5)

## Figure 6.9
turbidity <- filter(gormsey, Measure == "Turbidity")
ggplot(turbidity, aes(Date, Result, col = Town)) + 
    geom_line()
ggsave("manuscript/resources/06_visualisation/time_series.png", width = 9, height = 5)

## Figure 6.10
ggplot(turbidity, aes(Town, Result, fill = Town)) + 
    geom_boxplot() +
    scale_y_log10()
ggsave("manuscript/resources/06_visualisation/boxplot.png", width = 9, height = 5)

## Figure 6.11
ggplot(turbidity, aes(Date, Result, col = Town)) + 
    geom_line() + 
    facet_wrap(~Town)
ggsave("manuscript/resources/06_visualisation/facets.png", width = 9, height = 5)

## Figure 6.12
thm <- filter(gormsey, Measure == "THM")
thm_grouped <- group_by(thm, Date)
thm_max <- summarise(thm_grouped, thm_max = max(Result))

ggplot(thm_max, aes(Date, thm_max)) + 
    geom_smooth() + 
    geom_line() + 
    geom_hline(yintercept = 0.25, col = "red") 
ggsave("manuscript/resources/06_visualisation/thm_trend.png", width = 9, height = 5)

## Figure 6.13
library(gridExtra)
p <- ggplot(gormsey, aes(Measure)) + geom_bar()
a <- p + theme_classic(base_size = 22)+ ggtitle("theme_clasic()")
b <- a + theme_bw(base_size = 22) + ggtitle("theme_bw()")
c <- a + theme_dark(base_size = 22) + ggtitle("theme_dark()")
d <- a + theme_void(base_size = 22) + ggtitle("theme_void()")

png("manuscript/resources/06_visualisation/themes.png", width = 1920, height = 1080)
grid.arrange(a, b, c, d)
dev.off()

## Figure 6.14
ggplot(turbidity, aes(Date, Result)) + 
    geom_area(fill = "red", col = "black") + 
    facet_wrap(~Town, ncol = 1) + 
    theme_void(base_size = 10)
ggsave("manuscript/resources/06_visualisation/sparklets.png", width = 9, height = 5)

## Figure 6.15
ggplot(filter(turbidity, Town == "Strathmore"), aes(Date, Result)) + 
    geom_line() +
    labs(title = "Turbidity Spikes", 
         subtitle = "Strathmore customer taps",
         x = "Date sampled", y = "NTU") + 
    geom_hline(yintercept = 5, col = "red") + 
    theme_bw(base_size = 10)
ggsave("manuscript/resources/06_visualisation/labels.png", width = 9, height = 5)
