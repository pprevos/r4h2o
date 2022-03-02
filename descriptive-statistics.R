## Descriptive Statistics
library(tidyverse)
library(sn)
library(modeest)


set.seed(1)
##x <- rlnorm(1000, meanlog = .6, sdlog = .1) * 100
x <- rsn(n=1000, xi=0, omega=1, alpha=100, tau=.1, dp=NULL)
s <- tibble(s = c(mean(x),
                  median(x),
                  mlv(x, method = "asselin")),
            t = c("Mean", "Median", "Mode"))
ggplot(tibble(x), aes(x)) +
    geom_density(fill = "dodgerblue", alpha = 0.1, col = "dodgerblue") +
    geom_vline(data = s, aes(xintercept = s, col = t), size = 1) +
    scale_color_brewer(type = "qual", palette = 2, name = NULL) + 
    theme_void(base_size = 20) +
    theme(legend.direction="horizontal",
          legend.position = "bottom")
ggsave("central-tendency.png", bg = "transparent")


