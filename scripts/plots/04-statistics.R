######################################
# R4H2O: Descriptive statistics images
######################################

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

# Calculating percentiles

p <- c(1, 2, 3.5, 4, 5)
q <- 2 * p

par(mar=c(4, 4, 1, 1))
plot(p, q, pch = 19, 
     xlab = "Rank",  ylab = "Observation", 
     xaxt = "n", yaxt = "n", 
     frame.plot = FALSE)
axis(1, at = p,
     labels = c(1, expression(group(lfloor, r, rfloor)), "r", 
                expression(group(lceil, r, rceil)), "n"))
axis(2, at = q, labels = c(expression(y[1]),
                           expression(y[group(lfloor, r, rfloor)]), expression(y[r]),
                           expression(y[group(lceil, r, rceil)]), expression(y[n])))
lines(p[1:2], q[1:2], lty = 2)
lines(p[2:4], q[2:4], lty = 1)
lines(p[4:5], q[4:5], lty = 2)
abline(h = q[3], col = "gray", lwd = .5, lty = 5)
abline(v = p[3], col = "gray", lwd = .5, lty = 5)

# Percentiles methods example
# Create data
sample <- c(1:17, 63, 170, 300)

# Set parameters
m <- length(sample)
p <- 0.95

# Visualise
par(mar=c(4, 4, 1, 1))
plot(sample, type = "b",
     xlab = "Rank", ylab = "Result",
     cex.axis = 1,
     cex.lab = 1,
     cex.main = 1,
     cex.sub = 1,
     lwd = 1)

# Calculate rank
r_weibull <- p * (m + 1)
r_lin <- p * m

# Interpolate percentiles
x_weibull <- (1 - (r_weibull - floor(r_weibull))) * sample[floor(r_weibull)] + (r_weibull - floor(r_weibull)) * sample[ceiling(r_weibull)]
x_lin <- (1 - (r_lin - floor(r_lin))) * sample[floor(r_lin)] + (r_lin - floor(r_lin)) * sample[ceiling(r_lin)]

# Visualise
abline(v = r_weibull, col = "red", lwd = 1, lty = 3)
abline(v = r_lin, col = "blue", lwd = 1, lty = 2)

# Legend
legend("topleft", legend = c("Linear", "Weibull"), col = c("blue", "red"), lwd = 1, lty = c(2, 3))

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
  geom_area(aes(x, y2), alpha = 0.2) +
  facet_wrap(~name, scales = "free_y", strip.position = "bottom") + 
  theme_void() +
  theme(strip.text.x = element_text(margin = margin(0, 0, 2 ,0, "mm"),
                                    size = 12))

# Kurtosis
# Based on https://twitter.com/bolkerb/status/1518312191711223810

library(tidyverse)
s <- seq(-5, 5, length.out = 101)
d <- tibble(x = 1:101,
            Platykurtic = dnorm(s, sd = 2),
            Mesokurtic  = dnorm(s, sd = 1),
            Leptokurtic = dnorm(s, sd = .5)) %>% 
  pivot_longer(-x, values_to = "y") %>% 
  mutate(name = fct_inorder(name))

d$y2 <- rep(dnorm(s), each = 3)
d$y2[d$name == "Leptokurtic"] <- d$y2[d$name == "Leptokurtic"]
d$y2[d$name == "Platykurtic"] <- d$y2[d$name == "Platykurtic"]

ggplot(d, aes(x, y)) + 
  geom_line(lty = 2) +
  facet_wrap(~name,strip.position = "bottom", scales = "free_y") + 
  theme_void() +
  theme(strip.text.x = element_text(size = 12)) + 
  geom_area(aes(x, y2), alpha = 0.2)

# Visualise Anscombe's quartet

p <- anscombe %>%
        select(1:4) %>%
        pivot_longer(cols = 1:4, names_to = "set", values_to = "x") %>%
        mutate(set = str_remove(set, "x"))

      q <- anscombe %>%
        select(5:8) %>%
        pivot_longer(cols = 1:4, names_to = "set", values_to = "y") %>%
        mutate(set = str_remove(set, "y"))

      tibble(p, y = q$y) %>%
        mutate(set = paste("Set", set))  %>%
        ggplot(aes(x, y)) +
        geom_smooth(method = "lm", se = FALSE, col = "gray") +
        geom_point(size = 2.5, colour = "black", fill = "gray", shape = 21) +
        facet_wrap(~set) + 
        theme_minimal(base_size = 12) +
        labs(x = NULL, y = NULL)

# Explore Anscombe's Quartet

data(anscombe)
anscombe
