############################################
# R4H2O 9: Segmentation and Cluster Analysis
############################################

# Clustering Example

library(tidyverse)
set.seed(123)
customers <- tibble(id = LETTERS[1:10],
                    property_size = c(rnorm(5, 500, 100), rnorm(5, 1000, 200)),
                    consumption = c(rnorm(5, 500, 200), rnorm(5, 1000, 10)))
ggplot(customers, aes(property_size, consumption)) +
  geom_label(aes(label = id)) +
  labs(title = "Simulated weekday and weekend consumption",
       subtitle = "Cluster analysis example",
       x = "Property Size", y = "Annual consumption") +
  theme_minimal(base_size = 12)

# Scaling the data

# Manual Scaling

with(customers, (consumption - mean(consumption)) / sd(consumption))

# Scaling function

customers_scaled <- scale(customers[, -1])
customers_scaled

# Distance matrix

customers_dist <- dist(customers_scaled)
round(customers_dist, 2)

# Hierarchical clustering

customer_clusters <- hclust(customers_dist)

customer_clusters

# Visualise the clusters

plot(customer_clusters,
     main = "Clustering Example",
     sub = "Simulated data",
     labels = customers$id)

customers$segment <- cutree(customer_clusters, k = 2)

ggplot(customers, aes(property_size, consumption, fill = factor(segment))) +
    geom_label(aes(label = id)) +
    scale_fill_manual(values = c("dodgerblue", "lightgrey"), name = "Segment") +
    labs(title = "Simulated weekday and weekend consumption",
         subtitle = "Cluster analysis example",
         x = "Property Size", y = "Annual consumption") +
    theme_bw(base_size = 10)

plot(rev(customer_clusters$height), type = "b")
