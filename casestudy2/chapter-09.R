# Analysing customer experience

rm(list = ls())
source("casestudy2/customer_clean.R")

pii <- select(customers, customer_id, starts_with("p")) %>%
    mutate(p01 = 8 - p01,
           p02 = 8 - p02,
           p07 = 8 - p07,
           p08 = 8 - p08,
           p09 = 8 - p09,
           p10 = 8 - p10)

pii <- select(customers, customer_id, p01:p10)

pii <- select(customers, customer_id, starts_with("p")) %>% 
  mutate_at(c("p01", "p02", "p07", "p08", "p09", "p10"), function(p) 8 - p)

pii %>%
    pivot_longer(-customer_id, names_to = "Item", values_to = "Response") %>%
    ggplot(aes(Item, Response)) +
    geom_boxplot()

# Reliability

# Correlations
ggplot(pii, aes(p01, p02)) + 
  geom_point()

library(ggplot2)
ggplot(pii, aes(p01, p02)) + 
  geom_jitter(width = .5, height = .5, alpha = .5, size = 2) + 
  labs(title = "Scatterplot of items p01 and p02") + 
  theme_bw(base_size = 10) 
  
# geom_smooth(method = "lm")

cor(pii$p01, pii$p02)

c_matrix <- cor(pii[, -1] , use = "complete.obs")
round(c_matrix, 2)

library(corrplot)
corrplot(c_matrix, type = "lower", diag = FALSE)

c_test <- cor.test(pii$p01, pii$p02)
c_test

str(c_test)

c_test$p.value

# Covariance
with(customers, sum((p01 - mean(p01)) * (p02 - mean(p02)))) / (nrow(pii) - 1)

cov(pii$p01, pii$p02)

# Correlations
cov(pii$p01, pii$p02) / (sd(pii$p01) * sd(pii$p02))

cor(pii$p01, pii$p02)

round(cov(pii[, -1]), 2)

pii_cov <- cov(pii[, -1])
N <- ncol(pii_cov)
v <- mean(diag(pii_cov))
c <- mean(pii_cov[lower.tri(pii_cov)])
alpha <- (N * c) / (v + (N - 1) * c)
alpha

# Factor Analysis

library(GPArotation)
pii_ev <- eigen(c_matrix)
plot(pii_ev$values, type = "b", 
     xlab = "Factor", ylab = "Eigen Value", main = "PII Scree Plot")
abline(h = 1, col = "red")

pii_fa <- factanal(pii[, -1], factors = 2)
pii_fa

load <- pii_fa$loadings[, 1:2]
plot(load, type = "n")
text(load, labels = names(pii[, -1]))

# Uniqueness
pii_fa$uniquenesses

# Commonality
apply(pii_fa$loadings^2, 1, sum)
1 - apply(pii_fa$loadings^2, 1, sum)

# Three factors?
pii_fa2 <- factanal(pii[, -1], factors = 3)
pii_fa2
load2 <- pii_fa2$loadings[, 1:3]
par(mfrow = c(2, 2))
plot(load2, type = "n")
text(load2, labels = names(pii[, -1]), col = "blue")
plot(load2[, 2:3], type = "n")
text(load2[, 2:3], labels = names(pii[, -1]), col = "blue")
plot(load2[, c(1, 3)], type = "n")
text(load2[, c(1, 3)], labels = names(pii[, -1]), col = "blue")

library(psych)
describe(pii[, -1])

pairs.panels(pii[, -1])

corPlot(pii[, -1], upper = FALSE)

fa.parallel(pii[, -1], fa = "fa", fm= "ml", )

pii_fa <- fa(pii[, -1], nfactors = 2, rotate = "promax")
plot(pii_fa)
fa.diagram(pii_fa)

iclust(pii[, -1])

# Repeat this process for t01-t05 and f01-f13
