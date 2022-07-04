d <- filter(d, !is.na(y))
beta_1 <- cor(d$y, d$x) * sd(d$y) / sd(d$x)
beta_1

beta_0 <- mean(d$y) - beta_1 * mean(d$x)
beta_0

source("scripts/07-customer_clean.R")

contact_hardship <- select(customers, customer_id, contact, hardship)
contact_hardship <- contact_hardship[complete.cases(contact_hardship), ]

count(contact_hardship, hardship, contact) %>% 
  ggplot() + 
    geom_point(aes(contact, hardship, size = n), col = "darkgrey") +
    scale_size(guide = "none", range = c(0, 20)) + 
    geom_smooth(data = customers, aes(contact, hardship), method = "lm") + 
    labs(title = "Gormsey Customer Survey",
         x = "Contact frequency", y = "Financial hardship") +
    theme_light(base_size = 10)

cch <- contact_hardship %>% 
  select(customer_id, contact, hardship) %>% 
  filter(!is.na(contact) & !is.na(hardship))

hc_model <- lm(hardship ~ contact, data = contact_hardship)

hc_model

summary(hc_model)

contact_hardship %>%
  filter(!is.na(hardship) & !is.na(contact)) %>%
  mutate(prediction = predict(hc_model),
         residual = residuals(hc_model),
         res_calc = hardship - prediction,
         res_lm = hc_model$residuals) %>%
  select(hardship, contact, prediction, residual, res_calc, res_lm)

summary(hc_model$residuals)

hist(residuals(hc_model))

shapiro.test(hc_model$residuals)

coef(hc_model)

n <- nrow(contact_hardship)
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
