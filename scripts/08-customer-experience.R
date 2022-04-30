##############################
# R4H2O 8: Customer Experience
##############################

# Load the data

source("customer_clean.R")

# Correct reverse polarity

pii <- select(customers, customer_id, starts_with("p")) %>%
    mutate(p01 = 8 - p01,
           p02 = 8 - p02,
           p07 = 8 - p07,
           p08 = 8 - p08,
           p09 = 8 - p09,
           p10 = 8 - p10)

pii <- select(customers, customer_id, starts_with("p")) %>% 
  mutate_at(c("p01", "p02", "p07", "p08", "p09", "p10"), function(p) 8 - p)

# Visualise PII

pii %>%
    pivot_longer(-customer_id, names_to = "Item", values_to = "Response") %>%
    ggplot(aes(Item, Response)) +
    geom_boxplot()

# Correlations

cor(pii$p01, pii$p02, use = "complete.obs")

# Remove missing data in pii

pii <- pii %>%
  rowwise() %>%
  mutate(missing = sum(c_across(p01:p10))) %>%
  filter(!is.na(missing)) %>%
  select(-missing)

# Correlation matrix

c_matrix <- cor(pii[, -1])
round(c_matrix, 2)

# Scatterplot p01 and p02

library(ggplot2)
ggplot(pii, aes(p01, p02)) + 
    geom_jitter(width = .5, height = .5, alpha = .5, size = 2) + 
    labs(title = "Scatterplot of items p01 and p02") + 
    theme_bw(base_size = 10)

# Visualise correlation matrix

library(ggcorrplot)
ggcorrplot(c_matrix, outline.col = "white")

# Significance Testing for Correlations

c_test <- cor.test(pii$p01, pii$p02)
c_test

str(c_test)

c_test$p.value

# Cronbach's Alpha

with(pii, sum((p01 - mean(p01)) * (p02 - mean(p02)))) / (nrow(pii) - 1)

cov(pii$p01, pii$p02)

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

pii_fa <- factanal(pii[, -1], factors = 2, rotation = "varimax")
pii_fa

library(psych)

describe(pii[, -1])

pii_fa <- fa(pii[, -1], nfactors = 2)
fa.diagram(pii_fa)
