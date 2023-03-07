# Under- and Over-fitting

library(ggplot2)
library(gridExtra)
set.seed(1969)
x <- seq(0, 10, .5)
y <- 0.5 * x^2 - 8 * x + 3 + 8 * runif(n = length(x))

p <- ggplot(data.frame(x, y)) +
  aes(x, y) +
  geom_point(size = 3, col = "darkgray") +
  theme_minimal() +
  theme(axis.title.x = element_blank(),
        axis.text.x  = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y  = element_blank(),
        axis.ticks.y = element_blank())

under <- p +
  geom_smooth(method = "lm", se = FALSE, col = "black") +
  ggtitle("Underfitting")

fit <- p +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2),
              se = FALSE, col = "black") +
  ggtitle("Good fit")

over <- p +
  geom_smooth(method = "lm", formula = y ~ poly(x, 10),
              se = FALSE, col = "black") + 
  ggtitle("Overfitting")
grid.arrange(under, fit, over, ncol = 3)
