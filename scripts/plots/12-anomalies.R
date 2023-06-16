# Multidimensional anomaly detection

set.seed(12345)
x <- c(rnorm(100, 10, 3), rnorm(100, 20, 1))
y <- c(rnorm(100, 10, 3), rnorm(100, 20, 1))
xy <- data.frame(x, y)

# Multivariate anomaly detection

library(FNN)
xy_knn <- get.knn(xy, k = 5)
xy$`k-Nearest Neighbours` <- rowMeans(xy_knn$nn.dist)

library(dbscan)
xy$`Local Outlier Factor` <- lof(xy, minPts = 5)

library(tidyverse)
tibble(xy) %>%
    pivot_longer(-1:-2, names_to = "Method") %>%
    ggplot(aes(x, y, size = value, col = value > 2.5)) +
    geom_point() +
    scale_color_manual(values = c("black", "gray")) +
    facet_wrap(~Method, strip.position = "bottom") +
    theme_void() +
    theme(legend.position = "none",
          strip.text.x = element_text(margin = margin(10, 0, 2 ,0, "mm"),
                                      size = 11))
