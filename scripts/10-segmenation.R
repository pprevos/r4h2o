############################################
# R4H2O 10: Segmentation and Cluster Analysis
############################################

# Clustering Example

library(tidyverse)

set.seed(314)
consumption <- tibble(id = LETTERS[1:10],
                      property_size = c(rnorm(5, 500, 100), rnorm(5, 800, 100)),
                      volume = c(rnorm(5, 500, 200), rnorm(5, 1000, 100)))

ggplot(consumption, aes(property_size, volume, label = id)) +
  geom_label() +
  labs(title = "Cluster analysis example",
       x = "Property Size", y = "Volume") +
  theme_minimal(base_size = 12)

head(consumption, n = 3)

# Scaling the data

# Manual Scaling

with(consumption, (volume - mean(volume)) / sd(volume))

# Scaling function

consumption_scaled <- scale(consumption[, -1])
consumption_scaled

# Distance matrix (Euclidean)

consumption_dist <- dist(consumption_scaled)
round(consumption_dist, 2)

# Manhatten method

dist(consumption_scaled, method = "manhattan")

# Hierarchical clustering

customer_clusters <- hclust(consumption_dist)

customer_clusters

# Visualise the clusters

plot(customer_clusters,
     main = "Clustering Example",
     sub = "Simulated data",
     labels = customers$id)

consumption$segment <- cutree(customer_clusters, k = 2)

ggplot(consumption, aes(property_size, volume, fill = factor(segment))) +
  geom_label(aes(label = id)) +
  scale_fill_manual(values = c("grey90", "grey60"), name = "Segment") +
  labs(title = "Simulated weekday and weekend consumption",
       subtitle = "Cluster analysis example",
       x = "Property Size", y = "Annual volume") +
  theme_bw(base_size = 10)

# Scree plot

plot(rev(customer_clusters$height), type = "b",
     xlab = "Clusters", ylab = "Distance")
abline(v = 2, lty = 2, col = "grey50")

k_clust <- kmeans(consumption[, -1], centers = 2)
k_clust

withinss <- vector()

for (k in 1:nrow(consumption)) {
  cl <- kmeans(consumption[, -1], centers = k)
  withinss[k] <- cl$tot.withinss
}

plot(withinss, type = "b",
     xlab = "Clusters", ylab = "within-clusters sum of squares")
