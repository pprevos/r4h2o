## R4H2O: Data Science for Water Professionals
## Chapter 6 images

library(tidyverse)
library(gridExtra)

## Figure 6.3
## library(devtools)
## devtools::install_github("hilaryparker/cats")

library(cats)

comparison <- tibble(item = LETTERS[1:5],
                     value = c(20, 11, 9, 13, 17))

bad <- ggplot(comparison, aes(item, value, fill = item)) +
  add_cat(bw = FALSE) +
  geom_col(alpha = 0.5, col = "black") +
  scale_fill_discrete(name = "Brand") + 
  theme_gray(base_size = 50) +
  theme(legend.position="left", 
        legend.key.size = unit(5,"line"),
        plot.title = element_text(face = "bold")) +
  labs(title= "Cat food sales",
       subtitle = "Low Data-Pixel Ratio",
       x = "Brand", y = "Sales")

comparison$item <- factor(comparison$item, level = comparison$item[order(comparison$value)])

good <- ggplot(comparison, aes(item, value)) +
  geom_col(fill = "#002859", alpha = 0.7) +
  theme_minimal(base_size = 50) +
  theme(plot.title = element_text(face = "bold"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank()) + 
  labs(title= "Cat food sales",
       subtitle = "High Data-Pixel Ratio",
       x = "Brand", y = "Sales")

png("images/data-pixel-ratio.png", width = 1920, height = 1080)
grid.arrange(bad, good, ncol = 2, widths = c(1.1, 0.9))
dev.off()

## Figure 6.4
set.seed(1969)

comparison <- tibble(item = LETTERS[1:5],
                     value = sample(10:20, 5))

c <- ggplot(comparison, aes(item, value)) + geom_col(fill = "#002859", alpha = 0.5) +
    theme_minimal(base_size = 40) +
    theme(plot.title = element_text(face="bold")) +
    scale_x_discrete(breaks = NULL) +     
    ggtitle("Comparison")

relationship <- tibble(x = 1:20,
                       y = x + sample(-2:2, 20, replace = TRUE),
                       z = sample(1:5, 20 , replace = TRUE))

r1 <- ggplot(relationship, aes(x, y, z)) +
    geom_point(size = 10, col = "#002859") +
    ggtitle("Relationship: Two variables") + 
    theme_minimal(base_size = 40) +
    theme(plot.title = element_text(face="bold"))

r2 <- ggplot(relationship, aes(x, y, z)) +
    geom_point(aes(size = z), col = "#002859", alpha = 0.5) +
    scale_size_area(max_size = 25) +
    theme_minimal(base_size = 40) +
    theme(plot.title = element_text(face="bold")) +
    ggtitle("Relationship: Three variables")

distribution <- enframe(rnorm(1000))

d <- ggplot(distribution, aes(value)) +
    geom_histogram(bins = 40, fill = "#002859", alpha = 0.5) +
    theme_minimal(base_size = 40) +
    theme(plot.title = element_text(face="bold")) +
    ggtitle("Distribution")

png("manuscript/resources/06_visualisation/stories.png", width = 2048, height = 1536)
grid.arrange(c, d, r1, r2, ncol=2)
dev.off()


