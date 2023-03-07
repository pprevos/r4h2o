## Datasaurus dozen

library(tidyverse)
library(datasauRus)

filter(datasaurus_dozen,
       dataset %in% c("dino", "x_shape", "star", "bullseye")) %>%
    ggplot(aes(x = x, y = y)) +
    geom_point() +
    theme_void(base_size = 20) +
    theme(legend.position = "none") +
    facet_wrap(~dataset, ncol = 6)
