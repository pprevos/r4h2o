## Chapter 3
library(tidyverse)
library(datasauRus)

ggplot(filter(datasaurus_dozen, dataset %in% c("dino", "away", "star", "bullseye", "slant_up", "dots")), aes(x = x, y = y)) +
  geom_point(colour = "#002859") +
  theme_void(base_size = 20) +
    theme(legend.position = "none") +
    facet_wrap(~dataset, ncol=3)
ggsave("manuscript/resources/session6/datasaurus.png", width = 8, height = 6)


