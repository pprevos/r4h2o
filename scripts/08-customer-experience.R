##############################
#
# R4H2O 8: CUSTOMER EXPERIENCE
#
##############################

# Load the data

source("scripts/07-customer-clean.R")

# Correct polarity

pii <- select(customers, customer_id, starts_with("p")) %>%
  mutate(p01 = 8 - p01,
         p02 = 8 - p02,
         p07 = 8 - p07,
         p08 = 8 - p08,
         p09 = 8 - p09,
         p10 = 8 - p10)

# Remove missing values (use complete cases)
visdat::vis_miss(pii)
pii <- pii[complete.cases(pii), ]

# Visualise PII

library(ggplot2)
library(tidyr) # For the pivoting function

pii %>%
  pivot_longer(-customer_id, names_to = "Item", values_to = "Response") %>%
  ggplot(aes(Item, Response)) +
  geom_boxplot(fill = "cadetblue3") +
  theme_minimal()

colors()

# RELIABILITY

# Correlations

cor(pii$p01, pii$p02)

# Correlation matrix

c_matrix <- cor(pii[, -1])
round(c_matrix, 2)

# Visualise correlation matrix
# Install
# if(!require(devtools)) install.packages("devtools")
# devtools::install_github("kassambara/ggcorrplot")

library(ggcorrplot)
ggcorrplot(c_matrix, outline.col = "white") +
  labs(title = "Personal Inventory Index",
       subtitle = "Correlation Matrix")

# Significance Testing for Correlations

(c_test <- cor.test(pii$p01, pii$p02))

# Only plot significant correlations
# c_matrix[5, ] <- 0

ggcorrplot(c_matrix, insig = "blank", show.diag = FALSE)

# Cronbach's Alpha

with(pii, sum((p01 - mean(p01)) * (p02 - mean(p02)))) / (nrow(pii) - 1)

cov(pii$p01, pii$p02)

cov(pii$p01, pii$p02) / (sd(pii$p01) * sd(pii$p02))

cor(pii$p01, pii$p02)

round(cov(pii[, -1]), 2)

pii_cov <- cov(pii[, -1])
k <- ncol(pii_cov)
v <- mean(diag(pii_cov))
c <- mean(pii_cov[lower.tri(pii_cov)])
alpha <- (k * c) / (v + (k - 1) * c)
alpha

alpha <- psych::alpha(pii[, -1])
alpha$total

# Factor Analysis

library(psych, quietly = TRUE)
library(GPArotation)

pii_fa <- fa(pii[, -1], nfactors = 2, rotate = "oblimin")
pii_fa$loadings

par(mfcol = c(1, 2))
fa.none <- factanal(pii[, -1], factors = 2, rotation = "none")
fa.oblimin <- factanal(pii[, -1], factors = 2, rotation = "oblimin")

plot(fa.none$loadings[,1], 
     fa.none$loadings[,2],
     pch = 19, col = "darkgrey",
     xlab = "Factor 1", ylab = "Factor 2", 
     ylim = c(-1,1), xlim = c(-1,1),
     main = "No rotation")
abline(h = 0, col = "grey")
abline(v = 0, col = "grey")

plot(fa.oblimin$loadings[,1], 
     fa.oblimin$loadings[,2],
     pch = 19, col = "darkgrey",
     xlab = "Factor 1", ylab = "Factor 2", 
     ylim = c(-1,1), xlim = c(-1,1),
     main = "Oblimin rotation")
abline(h = 0, col = "grey")
abline(v = 0, col = "grey")

text(fa.oblimin$loadings[,1] + 0.04, fa.oblimin$loadings[,2] + 0.04,
     colnames(pii[, -1]), cex = 0.7)
par(mfcol = c(1, 1))

library(psych)
pii_fa <- fa(pii[, -1], nfactors = 2, rotate = "oblimin", fm = "ml")
fa.diagram(pii_fa, main = NULL)

library(tidyr)
pii_scores <- pii %>%
  mutate(cognitive = p01 + p02 + p03 + p04 + p05,
         affective = p06 + p07 + p08 + p09 + p10) %>%
  select(customer_id, cognitive, affective)

pivot_longer(pii_scores, cols = -customer_id) %>%
  ggplot(aes(value)) +
  geom_histogram(fill = "dodgerblue 4") +
  facet_wrap(~name) +
  theme_minimal(base_size = 12) +
  labs(title = "Consumer Involvement with Tap Water",
       subtitle = "Personal Involvement Index")

