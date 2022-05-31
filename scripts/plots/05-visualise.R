######################################
# R4H2O: Descriptive statistics images
######################################

# Data-Pixel Ratio

library(ggplot2)
library(gridExtra)
library(ggpubr)
library(jpeg)

graph_tit <- "Bottled Water Taste Testing Results"
comparison <- data.frame(item = LETTERS[1:5],
                         value = c(20, 11, 9, 13, 17))

bad_taste <- readJPEG("images/bad-taste.jpg")

bad <- ggplot(comparison, aes(item, value, fill = item)) +
  background_image(bad_taste) + 
  geom_col(alpha = 0., col = "black") +
  scale_fill_discrete(name = "Brand") + 
  theme_gray(base_size = 12) +
  theme(legend.position="left", legend.key.size = unit(2, "line"),
        plot.title = element_text(face = "bold")) +
  labs(title= graph_tit,
       subtitle = "Low Data-Pixel Ratio",
       x = "Brand", y = "Sales")

comparison$item <- factor(comparison$item, level = comparison$item[order(comparison$value)])

good <- ggplot(comparison, aes(item, value)) +
  geom_col(fill = "#002859", alpha = 0.7) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold")) + 
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) + 
  labs(title= graph_tit,
       subtitle = "High Data-Pixel Ratio",
       x = "Brand", y = "Sales")

grid.arrange(bad, good, ncol = 2, widths = c(1.1, 0.9))

# Data stories

library(tidyverse)
library(gridExtra)

theme_set(theme_minimal(base_size = 10) +
          theme(plot.title = element_text(face="bold"),
                plot.caption = element_text(family = "mono")))

set.seed(1969)

comparison <- tibble(item = LETTERS[1:5],
                     value = sample(10:20, 5))

c <- ggplot(comparison, aes(item, value)) +
  geom_col(fill = "#002859", alpha = 0.5) +
  scale_x_discrete(breaks = NULL) +     
  labs(title = "Comparison", x = NULL, y = NULL,
       caption = "geom_bar() / geom_col()")

relationship <- tibble(x = 1:20,
                       y = x + sample(-3:3, 20, replace = TRUE),
                       z = sample(1:5, 20 , replace = TRUE))

r1 <- ggplot(relationship, aes(x, y, z)) +
  geom_point(size = 2, col = "#002859") +
  labs(title = "Relationship",
       subtitle = "Two variables",
       x = NULL, y = NULL,
       caption = "geom_point()")

r2 <- ggplot(relationship, aes(x, y, z)) +
  geom_point(aes(size = z), col = "#002859", alpha = 0.5) +
  scale_size_area(max_size = 6, name = NULL) +
  labs(title = "Relationship",
       subtitle = "Three variables",
       caption = "geom_point(aes(size = z))",
       x = NULL, y = NULL)

distribution <- enframe(rnorm(1000))

d <- ggplot(distribution, aes(value)) +
  geom_histogram(bins = 40, fill = "#002859", alpha = 0.5) +
  labs(title = "Distribution", caption = "geom_histogram()",
       x = NULL, y = NULL)

grid.arrange(c, d, r1, r2, ncol=2)

theme_set(theme_gray())

# Overview of ggplot themes

library(gridExtra)

p <- ggplot(labdata, aes(Measure)) + geom_bar()
a <- p + theme_classic(base_size = 11) + ggtitle("theme_clasic()")
b <- a + theme_bw(base_size = 11) + ggtitle("theme_bw()")
c <- a + theme_minimal(base_size = 11) + ggtitle("theme_minimal()")
d <- a + theme_void(base_size = 11) + ggtitle("theme_void()")
grid.arrange(a, b, c, d)
