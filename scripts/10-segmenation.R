############################
#
# R4H2O 10: CLUSTER ANALYSIS
#
############################

# Clustering Example

library(tidyverse)

set.seed(314)
consumption <- tibble(id = LETTERS[1:10],
                      property_size = c(rnorm(5, 500, 100),
                                        rnorm(5, 800, 100)),
                      volume = c(rnorm(5, 500, 200),
                                 rnorm(5, 1000, 100)))

head(consumption, n = 5)

p <- ggplot(consumption, aes(property_size, volume, label = id)) +
  geom_label() +
  labs(title = "Cluster analysis example",
       x = "Property Size", y = "Volume") +
  theme_minimal(base_size = 12)
p

# Step 1: Scaling the data

# Manual Scaling

(consumption$volume - mean(consumption$volume)) / sd(consumption$volume)

with(consumption, (volume - mean(volume)) / sd(volume))

# Scaling function (scaled, mean and sd)

(consumption_scaled <- scale(consumption[, -1]))

# Step 2: Distance matrix (Euclidean)

consumption_dist <- dist(consumption_scaled)
round(consumption_dist, 2)

# Manhattan method

dist(consumption_scaled, method = "manhattan")

# Hierarchical clustering

customer_clusters <- hclust(consumption_dist)

customer_clusters

# Visualise the clusters

plot(customer_clusters,
     main = "Clustering Example",
     sub = "Simulated data", xlab = NA,
     labels = consumption$id)

consumption$segment <- cutree(customer_clusters, k = 2)

p + aes(fill = factor(segment))

# Scree plot

plot(rev(customer_clusters$height), type = "b",
     main = "Scree Plot Hierarchical Clustering",
     xlab = "Clusters", ylab = "Distance")
abline(v = 2, lty = 2, col = "red")

# k-means clustering

k_clust <- kmeans(consumption[, -1], centers = 2)

p + aes(fill = factor(k_clust$cluster))

# Elbow Method

within_ss <- vector()

for(k in 1:(nrow(consumption) - 1)) {
  cl <- kmeans(consumption[, -1], centers = k)
  within_ss[k] <- cl$tot.withinss
}

plot(within_ss, type = "b",
     main = "Scree Plot k-means clustering",
     xlab = "Clusters", ylab = "within-Cluster Sum of Squares")
abline(v = 2, lty = 2, col = "red")

# Categorical Data

(segments <- read_csv("data/customer_segments.csv"))

# Convert numbers to catgeorical

segments$involvement_cat <- cut(segments$involvement,
                              breaks = c(5, 15, 25, 35),
                              labels = c("Low", "Medium", "High"))
segments

# Visualise all four segmentation variables

ggplot(segments, aes(household, fill = involvement_cat)) + 
  geom_bar() +
  scale_fill_manual(values = c("dodgerblue", "darkseagreen", "firebrick")) + 
  facet_grid(garden ~ ownership) + 
  theme_minimal() + 
  labs(title = "Segmentation data")

# Dummy Variables

library(fastDummies)
segments_dummy <- dummy_cols(segments,
                             remove_selected_columns = TRUE) %>%
  select(-involvement, -garden_No, -ownership_Renter)

glimpse(segments_dummy)

# Similarity matrix

round(dist(segments_dummy[1:5, ], method = "binary"), 2)
segments_dist <- dist(segments_dummy, method = "binary")

# Elbow method

library(factoextra)
fviz_nbclust(segments_dummy, kmeans, method = "wss") +
  geom_vline(xintercept = 3, lty = 2)

# k-means clustering

segments_k <- kmeans(segments_dist, centers = 3)

segments$k <- segments_k$cluster

ggplot(segments, aes(household, involvement,
                     colour = factor(k))) + 
  geom_jitter(size = 2) +
  scale_shape(name = "Segment") +
  theme_minimal()

filter(segments, k == 2) %>% 
    count(garden, involvement_cat)

