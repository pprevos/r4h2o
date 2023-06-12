## Consumer Involvement
library(tidyverse)
library(psych)

# Suburb dimension table
suburbs_dim <- tibble(suburb = 1:3,
                      suburb_name = c("Merton", 
                                      "Tarnstead", 
                                      "Wakefield"))

# Clean data
customers <- read_csv("data/customer_survey.csv")[-1, ] %>%
  type_convert() %>%
  filter(is.na(term)) %>%
  left_join(suburbs_dim) %>% 
  rename(customer_id = V1) %>%
  select(c(1, 52, 21:51, -33))

# Correct polarity

pii <- select(customers, customer_id, starts_with("p")) %>%
  mutate(p01 = 8 - p01,
         p02 = 8 - p02,
         p07 = 8 - p07,
         p08 = 8 - p08,
         p09 = 8 - p09,
         p10 = 8 - p10)

# Remove missing values

pii <- pii[complete.cases(pii), ]

# Visualise PII

pii %>%
  pivot_longer(-customer_id, names_to = "Item", values_to = "Response") %>%
  ggplot(aes(Item, Response)) +
  geom_boxplot(fill = "#f7941d") +
  theme_bw(base_size = 12) + 
  labs(title = "personal Involvement Index",
       subtitle = paste("Tap Water Consumers USA and Australia (n =",
                        nrow(pii), ")"))

# Visualise correlation matrix
c_matrix <- cor(pii[, -1])

library(ggcorrplot)

ggcorrplot(c_matrix, outline.col = "white") +
  labs(title = "Personal Inventory Index",
       subtitle = "Correlation Matrix")

library(psych)
pii_fa <- fa(pii[, -1], nfactors = 2, rotate = "oblimin", fm = "ml")
fa.diagram(pii_fa, main = NULL)

# Calculating the PII

pii_scores <- pii %>%
  mutate(cognitive = p01 + p02 + p03 + p04 + p05,
         affective = p06 + p07 + p08 + p09 + p10) %>%
  select(customer_id, cognitive, affective)

pivot_longer(pii_scores, cols = -customer_id) %>%
  ggplot(aes(value)) +
  geom_histogram(fill = "dodgerblue 4", binwidth = 1) +
  facet_wrap(~name) +
  theme_minimal(base_size = 12) +
  labs(title = "Consumer Involvement with Tap Water",
       subtitle = "Personal Involvement Index")
