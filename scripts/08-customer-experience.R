##############################
#
# R4H2O 8: Customer Experience
#
##############################

# Load the data

source("scripts/customer_clean.R")

# Correct polarity

pii <- select(customers, customer_id, starts_with("p")) %>%
  mutate(p01 = 8 - p01,
         p02 = 8 - p02,
         p07 = 8 - p07,
         p08 = 8 - p08,
         p09 = 8 - p09,
         p10 = 8 - p10)

# Reverse polarity of PII variables

pii <- select(customers, customer_id, p01:p10) %>% 
  mutate_at(c("p01", "p02", "p07", "p08", "p09", "p10"),
            function(p) 8 - p)

# Remove missing values

pii <- pii[complete.cases(pii), ]

# Visualise PII

library(ggplot2)
library(tidyr) # For the pivoting function

pii %>%
  pivot_longer(-customer_id, names_to = "Item", values_to = "Response") %>%
  ggplot(aes(Item, Response)) +
  geom_boxplot() +
  theme_minimal()

# Correlations

cor(pii$p01, pii$p02)

# Correlation matrix

c_matrix <- cor(pii[, -1])
round(c_matrix, 2)

# Scatterplot p01 and p02

library(ggplot2)
ggplot(pii, aes(p01, p02)) + 
  geom_jitter(width = .5, height = .5, alpha = .5, size = 2) + 
  labs(title = "Scatterplot of items p01 and p02",
       subtitle = paste("Correlation:",
                        round(cor(pii$p01, pii$p02), 2))) + 
  theme_bw(base_size = 10)

# Visualise correlation matrix

library(ggcorrplot)
ggcorrplot(c_matrix, outline.col = "white") +
  labs(title = "Personal Inventory Index",
       subtitle = "Correlation Matrix")

# Some ggcorplot examples
ggcorrplot(c_matrix, method = "circle")
ggcorrplot(c_matrix, type = "lower", lab = TRUE)

# Significance Testing for Correlations

(c_test <- cor.test(pii$p01, pii$p02))

str(c_test)

c_test$p.value

# Only plot significant correlations

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
alpha$total$raw_alpha

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
