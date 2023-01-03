############################
#
# R4H2O 9: Linear Regression
#
############################

# Linear Regression Principles

set.seed(1066)
 d <- tibble(x = sample(22:38, 8),
             y = runif(1) * x + rnorm(8))

beta_1 <- cor(d$y, d$x) * sd(d$y) / sd(d$x)
beta_1

beta_0 <- mean(d$y) - beta_1 * mean(d$x)
beta_0

# Extract hardship data

source("scripts/07-customer_clean.R")

cont_hard <- select(customers, contact, hardship)
cont_hard <- cont_hard[complete.cases(cont_hard), ]

# Visualise Data

count(cont_hard, hardship, contact) %>% 
  ggplot() + 
    geom_point(aes(contact, hardship, size = n), col = "darkgrey") +
    scale_size(guide = "none", range = c(0, 20)) + 
    geom_smooth(data = customers, aes(contact, hardship), method = "lm") + 
    labs(title = "Gormsey Customer Survey",
         x = "Contact frequency", y = "Financial hardship") +
    theme_light(base_size = 10)

# The lm function

hc_model <- lm(hardship ~ contact, data = cont_hard)

hc_model

# Assessing Linear Relationship Models

summary(hc_model)

# Residuals

cont_hard %>%
  filter(!is.na(hardship) & !is.na(contact)) %>%
  mutate(prediction = predict(hc_model),
         residual = residuals(hc_model),
         res_calc = hardship - prediction,
         res_lm = hc_model$residuals)

summary(hc_model$residuals)

hist(residuals(hc_model), breaks = 20)

# Test for normality

shapiro.test(hc_model$residuals)

# Coefficients

coef(hc_model)

# Residual Standard Error

n <- nrow(cont_hard)
k <- length(hc_model$coefficients) - 1
ss_fit <- sum(hc_model$residuals^2)
df <- n - (k + 1)
rse <- sqrt(ss_fit / df)
rse

# R-Squared

summary(hc_model)$r.squared

ss_fit <- sum(hc_model$residuals^2)

ss_mean <- sum((cont_hard$hardship - mean(cont_hard$hardship))^2)

(ss_mean - ss_fit) / ss_mean

1 - (ss_fit / ss_mean) * (n - 1) / df

# F Statistic

(ss_mean - ss_fit) / (ss_fit) * df

# Graphical Assessment

par(mfrow = c(2, 2))
plot(hc_model, pch = 19, col = "grey", cex = .5)

# Removing Outliers

hc_model2 <- lm(hardship ~ contact, data = cont_hard,
                subset = c(-194, -197, -316))

# Plynomial Regression Example

set.seed(1969)
g <- 9.81
b <- 0.5
Cd <- 0.62 

h <- seq(from = 0, to = 0.2, by = 0.01)
q_observed <- 2/3 * sqrt(2 * g) * b *
  rnorm(length(h), mean = Cd, sd = .1) * h^(2/3) 
q_theory <- 2/3 * sqrt(2 * g) * b * Cd * h^(2/3) 

model <- lm(q_observed ~ I(h^(2/3)) - 1)

par(mar = c(4, 4, 1, 1), mfrow = c(1, 1))
plot(h, q_observed, pch = 19)
lines(h, q_theory, lty = 2)
lines(h, predict(model))
legend("topleft", lty = c(1, 2), legend = c("Model", "Theory"))

model$coefficients[1] / (2 / 3 * sqrt(2 * g) * b)
