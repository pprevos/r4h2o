############################
#
# R4H2O 9: LINEAR REGRESSION
#
############################

# Linear Regression Principles



set.seed(10)
d <- tibble(x = sample(22:38, 8),
                y = runif(1) * x + rnorm(8))

plot(d$x, d$y, pch = 19, cex = 2, col = "blue", xlab = NA, ylab = NA)

beta_1 <- cor(d$y, d$x) * sd(d$y) / sd(d$x)
beta_1

beta_0 <- mean(d$y) - beta_1 * mean(d$x)
beta_0

abline(a = beta_0, b = beta_1, lwd = 3., col = "red")

# Extract hardship data

source("scripts/07-customer-clean.R")

cont_hard <- select(customers, contact, hardship)

visdat::vis_miss(cont_hard)

cont_hard <- cont_hard[complete.cases(cont_hard), ]

plot(cont_hard$contact, cont_hard$hardship, cex = 2, pch = 19, col = "blue")

plot(jitter(cont_hard$contact), 
     jitter(cont_hard$hardship), 
     cex = 1, pch = 19, col = "blue")

# Visualise Data
library(ggplot2)
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

str(hc_model)

hc_model$coefficients

coef(hc_model)

# Assessing Linear Relationship Models

summary(hc_model)

# Residuals

cont_hard %>%
  mutate(prediction = predict(hc_model),
         res_calc = hardship - prediction,
         residual = residuals(hc_model),
         res_lm = hc_model$residuals)

summary(hc_model$residuals)

hist(residuals(hc_model), breaks = 20)

# Test for normality

shapiro.test(hc_model$residuals)

# Residual Standard Error: how well a regression model fits the data

n <- nrow(cont_hard)
k <- length(hc_model$coefficients) - 1 # Number of independent vars
ss_fit <- sum(hc_model$residuals^2)
df <- n - (k + 1) # the number of values that are free to vary
(rse <- sqrt(ss_fit / df))

# R-Squared

summary(hc_model)$r.squared

ss_mean <- sum((cont_hard$hardship - mean(cont_hard$hardship))^2)

(ss_mean - ss_fit) / ss_mean

1 - (ss_fit / ss_mean) * (n - 1) / df

# F Statistic

(ss_mean - ss_fit) / (ss_fit) * df

summary(hc_model)

# Graphical Assessment

par(mfrow = c(2, 2), mar = c(4, 4, 2, 1))
plot(hc_model, pch = 19, col = "grey", cex = .5)

# Removing Outliers

hc_model2 <- lm(hardship ~ contact, data = cont_hard,
                subset = c(-194, -197, -316))

summary(hc_model2)

# Polynomial Regression Example

set.seed(1969)
g <- 9.81
b <- 0.5
Cd <- 0.62 

h <- seq(from = 0, to = 0.2, by = 0.01)
q_observed <- 2/3 * sqrt(2 * g) * b *
  rnorm(length(h), mean = Cd, sd = .1) * h^(2/3) 

par(mar = c(4, 4, 1, 1), mfrow = c(1, 1))
plot(h, q_observed, pch = 19)

q_theory <- 2/3 * sqrt(2 * g) * b * Cd * h^(2/3) 

lines(h, q_theory, lty = 2)

flow_model <- lm(q_observed ~ I(h^(2/3)) - 1)

lines(h, predict(flow_model))
legend("topleft", lty = c(1, 2), legend = c("Model", "Theory"))

(cd <- coef(flow_model)[1] / (2 / 3 * sqrt(2 * g) * b))

