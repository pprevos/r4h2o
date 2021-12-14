# Service Quality

library(tidyverse)
source("casestudy2/customer-survey-clean.R")

sq <- customers %>% 
  mutate_at(c(1:2, 7:10) + 2, function(r) 8 - r) %>% 
  mutate(pii = p01 + p02 + p03 + p04 + p05 + p06 + p07 + p08 + p09 + p10,
         sq = f01 + f03 + f05 + f07 + f08 + f09 + f10 + f12 + f13) %>% 
  select(id, pii, contact, hardship, sq)


sq %>% 
  pivot_longer(-id, names_to = "Variable", values_to = "Score") %>% 
  ggplot(aes(Score)) + 
  geom_histogram() + 
  facet_wrap(~Variable, scales = "free")

sq_model <- lm(sq ~ contact + hardship + pii, data = sq)

summary(sq_model)

par(mfrow = c(2, 2))
plot(sq_model)

sq_model2 <- lm(sq ~contact + hardship + pii, data = sq, subset = c(-18, -168, -194, -327))
summary(sq_model2)
plot(sq_model2)


sq$c <- grey.colors(7)[sq$hardship]
  
library(rgl)
with(sq, plot3d(pii, contact, sq, col = c, size = 10))

