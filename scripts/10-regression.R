library(tidyverse)

set.seed(123)
d <- tibble(x = c(sample(22:38, 8), 20, 40),
            y = round(runif(1), 2) * x + sample(5:10 , 1) + rnorm(10) * 2)

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

d <- filter(d, !is.na(y))
beta_1 <- cor(d$y, d$x) * sd(d$y) / sd(d$x)
beta_1

beta_0 <- mean(d$y) - a * mean(d$x)
beta_0

source("customer_clean.R")

cor.test(customers$contact, customers$hardship,
         use = "complete.obs")

count(customers, hardship, contact) %>% 
  ggplot() + 
    geom_point(aes(contact, hardship, size = n), col = "darkgrey") +
    scale_size(guide = "none", range = c(0, 20)) + 
    geom_smooth(data = customers, aes(contact, hardship), method = "lm") + 
    labs(title = "Gormsey Customer Survey",
         x = "Contact frequency", y = "Financial hardship") +
    theme_light(base_size = 10)

op <- par(mfrow = c(2, 2), mar = 0.1+c(4,4,1,1), oma =  c(0, 0, 2, 0))
ff <- y ~ x
mods <- setNames(as.list(1:4), paste0("lm", 1:4))
for(i in 1:4) {
  ff[2:3] <- lapply(paste0(c("y","x"), i), as.name)
  mods[[i]] <- lmi <- lm(ff, data = anscombe)
}
for(i in 1:4) {
  ff[2:3] <- lapply(paste0(c("y", "x"), i),  as.name)
  plot(ff, data = anscombe, col = "red", pch = 21, bg = "orange", cex = 1.2,
       xlim = c(3, 19), ylim = c(3, 13))
  abline(mods[[i]], col = "blue")
}
par(mfrow = c(1, 1))

data(anscombe)
anscombe

cch <- customers %>% 
  select(customer_id, contact, hardship) %>% 
  filter(!is.na(contact) & !is.na(hardship))

hc_model <- lm(hardship ~ contact, data = cch)

hc_model

summary(hc_model)

cch %>%
    mutate(prediction = predict(hc_model),
           res_calc = hardship - prediction,
           res_lm = hc_model$residuals) %>%
    select(-customer_id)

summary(hc_model$residuals)

hist(residuals(hc_model))

shapiro.test(hc_model$residuals)

coef(hc_model)

n <- nrow(cch)
k <- length(hc_model$coefficients) - 1
ss_fit <- sum(hc_model$residuals^2)
df <- n - (k + 1)
rse <- sqrt(ss_fit / df)
rse

summary(hc_model)$r.squared

ss_fit <- sum(hc_model$residuals^2)

ss_mean <- sum((cch$hardship - mean(cch$hardship))^2)

R2 <- (ss_mean - ss_fit) / ss_mean

R2

1 - (ss_fit / ss_mean) * (n - 1) / df

F <- (ss_mean - ss_fit) / (ss_fit) * df
F

par(mfrow = c(2, 2))
plot(hc_model, pch = 19, col = "grey", cex = .5)
