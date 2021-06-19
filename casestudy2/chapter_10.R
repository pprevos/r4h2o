## R4H2O: Data Science for Water Professionals
## Chapter 10: Analysing the Customer Experience

## Read data
library(readr)
pii_long <- read_csv("casestudy2/pii_long.csv")

## Transform data
library(tidyr)
pii_wide <- pivot_wider(pii_long, names_from = Item, values_from = Response)

## Correlations
cor(pii_wide$p01, pii_wide$p02)
c_matrix <- cor(pii_wide[, -1])
round(c_matrix, 2)

cor.test(pii_wide$p01, pii_wide$p02)

## Visualise correlations
ggplot(pii_wide, aes(p01, p02)) + 
    geom_jitter() + 
    labs(title = "Scatterplot of p01 and p02") + 
    theme_bw(base_size = 10)
ggsave("manuscript/resources/10_surveys/scatterplot.png", width = 9, height = 5)

library(corrplot)

png("manuscript/resources/10_surveys/corplot_01.png", width = 1024, height = 1024, pointsize = 24)
corrplot(c_matrix, type = "lower")
dev.off()

## Hierarchical clustering

## Clustering example
set.seed(1969)
customers <- tibble(id = LETTERS[1:10],
                    weekday = c(rnorm(5, 155 * 2.7, 200), rnorm(5, 750, 200)),
                    weekend = c(rnorm(5, 250 * 2.7, 200), rnorm(5, 50, 10)))

ggplot(customers, aes(weekday, weekend)) +
    geom_label(aes(label = id)) +
    labs(title = "Simulated weekday and weekend consumption",
         subtitle = "Cluster analysis example",
         x = "Average weekday consumption", y = "Average weekend consumption") +
    theme_bw(base_size = 10)
ggsave("manuscript/resources/10_surveys/clustering_example.png", width = 9, height = 5)

## Correlations
cor(customers[, -1])

customers_scaled <- scale(customers[, -1])
customers_dist <- dist(customers_scaled)
customer_clusters <- hclust(customers_dist)

png("manuscript/resources/10_surveys/example_dendogram.png", width = 1920, height = 1080, pointsize = 32)
plot(customer_clusters,
     main = "Clustering Example",
     sub = "Simulated data",
     labels = customers$id,
     lwd = 2)
dev.off()

customers$Segment <- cutree(customer_clusters, 2)
ggplot(customers, aes(weekday, weekend)) +
    geom_label(aes(label = id, fill = factor(Segment))) +
    scale_fill_manual(values = c("lightblue", "dodgerblue")) + 
    labs(title = "Simulated weekday and weekend consumption",
         subtitle = "Cluster analysis example",
         x = "Average weekday consumption", y = "Average weekend consumption",
         fill = "Segment") +
    theme_bw(base_size = 10)
ggsave("manuscript/resources/10_surveys/customer_segments.png", width = 9, height = 5)

## Cluster involvement data
pii_trans <- t(pii_wide[, -1])

pii_clusters <- pii_trans %>%
    scale() %>%
    dist() %>%
    hclust()

png("manuscript/resources/10_surveys/pii_dendogram.png", width = 1920, height = 1080, pointsize = 32)
plot(pii_clusters,
     main = "Tap Water Consumer Involvement survey clusters",
     sub = "Personal Involvement Index items",
     labels = names(pii_wide[, -1]), 
     lwd = 2)
rect.hclust(pii_clusters, k = 2, border = 3:4)
dev.off()

## Calculate the PII index
library(dplyr)
pii <- pii_wide %>%
    group_by(survey_id) %>%
    summarise(Cognitive = p01 + p02 + p03 + p04 + p05,
              Affective = p06 + p07 + p08 + p09 + p10,
              Involvement = Cognitive + Affective) %>%
    pivot_longer(Cognitive:Involvement, 
                 names_to = "Dimension",
                 values_to = "Score")

ggplot(pii, aes(Score, fill = Dimension)) + 
    geom_histogram(bins = 30) + 
    facet_wrap(~Dimension, scales = "free_x") + 
    labs(title = "Personal Involvement Index",
         subtitle = "Tap Water Customers in Gormsey") + 
    theme_bw(base_size = 10)
ggsave("manuscript/resources/10_surveys/pii_scores.png", width = 9, height = 5)
