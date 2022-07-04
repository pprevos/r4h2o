# Regression images

# Linear regression example
library(tidyverse)

set.seed(1066)
d <- tibble(x = c(sample(22:38, 8), 20, 40),
            y = round(runif(1), 2) * x +
              sample(5:10 , 1) + rnorm(10) * 3)

d$y[d$x %in% c(20, 40)] <- NA
ab <- lm(y ~ x, d)
a <- coef(ab)[2]
b <- coef(ab)[1]
d$yhat <- a * d$x + b

ggplot(d, aes(x, y)) +
  geom_segment(aes(x = x, xend = x, y = y, yend = yhat),
               col = "red", linetype = 3, size = 1) + 
  geom_point(size = 3) +
  geom_line(aes(x, yhat), col = "blue") +
  scale_x_continuous(limits = c(20, 40), name = "x", minor_breaks = NULL, 
                     breaks = seq(22, 38, 2)) +
  scale_y_continuous(minor_breaks = NULL, name = "y", 
                     breaks = seq(round(min(d$y, na.rm = TRUE)), round(max(d$y, na.rm = TRUE)), 2)) +
  theme_minimal(base_size = 12) +
  coord_fixed()

# Ordinary Minimum Least Squares method

a1 <- -a / 2
b1 <- mean(d$y, na.rm = TRUE) - a1 * mean(d$x, na.rm = TRUE)

a2 <- a / 2
b2 <- mean(d$y, na.rm = TRUE) - a2 * mean(d$x, na.rm = TRUE)

d1 <- d %>%
  mutate(Mean = mean(y, na.rm = TRUE),
         `Rotate 1`= a1 * x + b1,
         `Rotate 2`= a2 * x + b2) %>%
  select(x, y, Mean, `Rotate 1`, `Rotate 2`, `Best Fit` = yhat) %>%
  pivot_longer(-1:-2) %>%
  mutate(name = fct_relevel(name, c("Mean", "Rotate 1", "Rotate 2", "Best Fit")))

ss <- d1 %>%
  group_by(name) %>%
  summarise(meanx = mean(x),
            meany = mean(y, na.rm = TRUE),
            SS = sum(abs(value - y)^2, na.rm = TRUE),
            SSt = paste("SS =", round(SS, 2))) 

ggplot(d1) +
  geom_segment(aes(x = x, xend = x, y = y, yend = value), col = "red", linetype = 2) + 
  geom_point(aes(x, y), size = 2) +
  geom_line(aes(x, value), col = "blue") +
  geom_point(data = ss, aes(meanx, meany), col = "blue", size = 2) +
  geom_text(data = ss, aes(x = mean(d1$x), y = (min(d1$value) + 5), label = SSt)) + 
  facet_wrap(~name, ncol = 2) +
  coord_equal() +
  theme_minimal(base_size = 14) +
  theme(panel.spacing = unit(2, "lines"))
