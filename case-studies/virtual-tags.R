# Virtual tag simulation

# Generate turbidity measurements
set.seed(1234)
n <- 300
wtp <- data.frame(timestamp = seq.POSIXt(ISOdate(1910, 1, 1), length.out = n, by = 60),
                  turbidity = rlnorm(n, log(.1), .01))

library(ggplot2)

p1 <- ggplot(wtp) +
  aes(x = timestamp, y = turbidity) +
  geom_line(colour = "grey") +
  ylim(0.09, 0.11) + 
  theme_bw(base_size = 10) + 
  labs(title = "Turbidity simulation", x = "Timestamp", y = "Turbidity")

p1

# Historise using dead banding
threshold <- 0.03
h <- 1 # First historised point

wtp$historised <- FALSE
wtp$historised[c(1, n)] <- TRUE # Testing for delta > threshold

for (i in 2:nrow(wtp)) {
  delta <- wtp$turbidity[i] / wtp$turbidity[h] 
  if (delta > (1 + threshold) | delta < (1 - threshold)) {
    wtp$historised[i] <- TRUE
    h <- i
  }
}

historian <- subset(wtp, historised)

p2 <- p1 + 
  geom_point(data = historian, 
             aes(x = timestamp, y = turbidity), 
             size = 3, alpha = .5, color = "blue") +
  labs(title = "Historised data")

p2

# Virtual Tags extrapolation

vt <- function(t) {
  approx(historian$timestamp, historian$turbidity, xout = t, method = "constant")
}

turbidity <- lapply(as.data.frame(wtp$timestamp), vt)

wtp$virtual_tag <- turbidity[[1]]$y

p3 <- p2 +
  geom_line(data = wtp,
            aes(x = timestamp, y = virtual_tag), colour = "red") +
  ggtitle("Virtual Tags")
p3
