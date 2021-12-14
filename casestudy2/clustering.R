# Session 2b

library(tidyverse)
library(corrplot)

# Personal Involvement Index
source("casestudy2/customer-survey-clean.R")

pii <- customers %>% 
  select(id, p01:p10) %>% 
  mutate_at(c(1:2, 7:10) + 1, function(r) 8 - r)

cor(pii[, -1], use = "complete.obs") %>% 
  corrplot()

# Hierarchical Clustering
set.seed(1209)

customers <- tibble(id = LETTERS[1:10],
                    property_size = c(rnorm(5, 500, 100), rnorm(5, 1000, 200)),
                    consumption = c(rnorm(5, 500, 200), rnorm(5, 1000, 100)))

ggplot(customers, aes(property_size, consumption)) +
  geom_label(aes(label = id)) +
  labs(title = "Simulated property size and consumption",
       subtitle = "Cluster analysis example",
       x = "Property Size", y = "Annual consumption") +
  theme_minimal(base_size = 14)

# Pre-process not requires
# Features = columns (p01-p10)
# rows = observations

# Scaling

with(customers, (consumption - mean(consumption)) / sd(consumption))

customer_scaled <- scale(customers[, -1])

# Distance matrix
s <- matrix(c(1, 2, 1, 3), ncol = 2)

dist(s) #Euclidean
dist(s, method = "manhattan")
dist(s, method = "maximum")

customer_dist <- dist(customer_scaled)

# Clustering
customer_clusters <- hclust(customer_dist)

customer_clusters

plot(customer_clusters)

abline(h = 3, col = "red")

# Interpret
customers$segment <- cutree(customer_clusters, k = 2)

ggplot(customers, aes(property_size, consumption, fill = factor(segment))) +
  geom_label(aes(label = id)) +
  scale_fill_manual(values = c("dodgerblue", "lightgrey"), name = "Segment") +
  labs(title = "Simulated weekday and weekend consumption",
       subtitle = "Cluster analysis example",
       x = "Property Size", y = "Annual consumption") +
  theme_minimal(base_size = 14)

plot(rev(customer_clusters$height), type= "b")

# k-means
kmeans(customer_dist, centers = 2, iter.max = 1)


