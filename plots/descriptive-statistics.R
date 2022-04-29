########################################
# R4H2O: Descriptive statistics examples
########################################

# Central Tendency

library(tidyverse)
library(gridExtra)

titles <- c("Mean", "Median", "Mode")

d <- tibble(x = seq(0, 5, .01),
            y = dlnorm(seq(0, 5, .01), meanlog = 0, sdlog = .8))

g <- ggplot(d, aes(x, y)) + 
    geom_area(alpha = 0.2) +
    theme_void() 

m <- exp(0 + .4^2)

g1 <- g + 
    geom_vline(xintercept = m, linetype = 5) +
    geom_point(data = tibble(x = m, y = 0), aes(x, y), size = 3, col = "darkgrey")

g2 <- g + 
    geom_vline(xintercept = 1, linetype = 5) + 
    annotate("text", x = c(.5, 1.5), y = c(.1, .1), label = "50%")

g3 <- g + 
    geom_vline(xintercept = d$x[which.max(d$y)], linetype = 5) + 
    geom_hline(yintercept = max(d$y), linetype = 2, col = "grey")

plots = mapply(arrangeGrob, list(g1, g2, g3), 
               bottom = titles, SIMPLIFY = FALSE)

grid.arrange(grobs = plots, ncol = 3)

# Skewness

d <- tibble(x = 1:101,
            `Negative skew` = dbeta(seq(0, 1, .01, ), shape1 = 5, shape2 = 1.5),
            Symmetric = dnorm(seq(-3, 3, length.out = 101)),
            `Positive skew` = dbeta(seq(0, 1, .01, ), shape1 = 1.5, shape2 = 5)) %>% 
    pivot_longer(-x, values_to = "y") %>% 
    mutate(name = fct_inorder(name))

d$y2 <- rep(dnorm(seq(-3, 3, length.out = 101)), each = 3)
d$y2[d$name != "Symmetric"] <- d$y2[d$name != "Symmetric"] * 6.1 

ggplot(d, aes(x, y)) + 
    geom_line(lty = 2) +
    facet_wrap(~name, scales = "free_y", strip.position = "bottom") + 
    theme_void() +
    theme(strip.text.x = element_text(size = 12)) + 
    geom_area(aes(x, y2), alpha = 0.2)

# Kurtosis
# Based on https://twitter.com/bolkerb/status/1518312191711223810

s <- seq(-5, 5, length.out = 101)
d <- tibble(x = 1:101,
            Platykurtic = dnorm(s, sd = 2),
            Mesokurtic  = dnorm(s, sd = 1),
            Leptokurtic = dnorm(s, sd = .5)) %>% 
    pivot_longer(-x, values_to = "y") %>% 
    mutate(name = fct_inorder(name))

summarise(group_by(d, name), kurtosis = moments::kurtosis(y))

d$y2 <- rep(dnorm(s), each = 3)
d$y2[d$name == "Leptokurtic"] <- d$y2[d$name == "Leptokurtic"]
d$y2[d$name == "Platykurtic"] <- d$y2[d$name == "Platykurtic"]

ggplot(d, aes(x, y)) + 
    geom_line(lty = 2) +
    facet_wrap(~name,strip.position = "bottom", scales = "free_y") + 
    theme_void() +
    theme(strip.text.x = element_text(size = 12)) + 
    geom_area(aes(x, y2), alpha = 0.2)
