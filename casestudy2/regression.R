# Linear regression

library(tidyverse)
source("casestudy2/customer-survey-clean.R")

#Explore

ggplot(customers, aes(contact, hardship)) + 
  geom_point()

ggplot(customers, aes(contact, hardship)) + 
  geom_jitter() + #alpha, width, height
  theme_minimal()

count(customers, hardship, contact) %>%
  ggplot() +
  geom_point(aes(contact, hardship, size = n), col = "darkgrey") +
  scale_size(range = c(0, 20)) + #guide = "none"
  geom_smooth(data = customers, aes(contact, hardship), method = "lm") +
  labs(title = "Gormsey Customer Survey",
       x = "Contact frequency", y = "Financial hardship") +
  theme_light(base_size = 14)

cor(customers$contact, customers$hardship, use = "complete.obs")

cor.test(customers$contact, customers$hardship, use = "complete.obs")

# Model
cont_hard <- customers %>%
  select(id, contact, hardship) %>%
  filter(!is.na(contact) & !is.na(hardship))

sum(is.na(cont_hard$hardship))

cor(cont_hard$contact, cont_hard$hardship) * sd(cont_hard$hardship) / sd(cont_hard$contact)

b1 <- with(cont_hard, cor(contact, hardship) * sd(hardship) / sd(contact))
b0 <- with(cont_hard, mean(hardship) - b1 * mean(contact))

b0
b1

hc_model <- lm(hardship ~ contact, data = cont_hard)

hc_model

hc_model$coefficients

coef(hc_model)

# Analyse
summary(hc_model)

# Residuals
predict(hc_model)

cont_hard <- cont_hard %>% 
  mutate(predict = predict(hc_model),
         residual = hardship - predict)

hist(cont_hard$residual)

hist(residuals(hc_model))

shapiro.test(residuals(hc_model))

# Residual Standard Error
sigma(hc_model)

sqrt(sum(residuals(hc_model)^2) / (nrow(cont_hard) - length(coef(hc_model))))

# R^2
summary(hc_model)$r.squared

var_fit <- mean(residuals(hc_model)^2)

var_mean <- mean((mean(cont_hard$hardship) - cont_hard$hardship)^2)

(var_fit - var_mean) / var_mean


# Graphical Assessment

par(mfrow = c(2, 2))
plot(hc_model)


# Fine-tuning
hc_model2 <- lm(hardship ~ contact, data = cont_hard, subset = c(-197, -316, -194))
summary(hc_model2)

par(mfrow = c(2, 1))
hist(residuals(hc_model2))
hist(residuals(hc_model))
shapiro.test(residuals(hc_model2))


hc_model3 <- lm(hardship ~ contact - 1, data = cont_hard)
summary(hc_model3)
par(mfrow = c(2, 2))
plot(hc_model3)

# Multiple Linear regression

# install.packages("rgl")
library(rgl)

n <- 100
s <- 20

b0 <- 10
b1 <- 2.5
b2 <- 3.2
e <- 10

d <- tibble(p = sample(1:n, s),
            q = sample(n:(2 * n - 1), s),
            r = (b1 * p + rnorm(s) * e) + (b2 * q + rnorm(s) * e) + b0)

fit <- lm(r ~ p + q, d)

plot3d(fit, which = 1:3, size = 5, col = "red", plane.col = "blue", plane.alpha = .5)
















