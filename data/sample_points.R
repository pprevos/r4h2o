# Create sample points

library(tidyverse)

sample_points <- lab_results %>% 
    distinct(Sample_Point, Suburb) %>% 
    arrange(Suburb, Sample_Point) 

suburbs <- sample_points %>% 
    distinct(Suburb) %>% 
    mutate(p = 100 * c(1, 2, 3, 1, 2, 4, 3),
           q = 100 * c(1, 2, 1, 3, 4, 1, 2))

sample_points %>% 
    left_join(suburbs) %>% 
    mutate(x = p + sample(-40:40, n()),
           y = q + sample(-40:40, n())) %>% 
    select(Sample_Point, Suburb, x, y) %>% 
    write_csv("data/sample_points.csv")