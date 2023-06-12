###############################
#
# R4H2O: 12 - ANOMALY-DETECTION
#
###############################

library(readr)
library(dplyr)
library(ggplot2)

chlorine <- read_csv("data/water_quality.csv") %>%
  filter(Measure == "Chlorine Total")

ggplot(chlorine, aes(Suburb, Result)) +
  geom_boxplot()

cl_merton <- filter(chlorine, Suburb == "Merton")

# Z-scores

outliers <- which(abs(cl_merton$Result - mean(cl_merton$Result)) /
                  sd(cl_merton$Result) >= 3)

cl_merton[outliers, c("Sample_No", "Sample_Point", "Result", "Units")]

# Means and medians

x <- sample(1:100, 10) # Ten random integers between 1 and 100
mean(x)
mean(c(x, Inf))
median(x)
median(c(x, Inf))

# Median Absolute Deviation from the Median (MAD)
1.4826 * median(abs(cl_merton$Result - median(cl_merton$Result)))

mad(cl_merton$Result)

(cl_p75 <- quantile(cl_merton$Result, 0.75, names = FALSE))
(cl_mad <- mad(cl_merton$Result, constant = 1 / cl_p75))

median(cl_merton$Result) + 3 * cl_mad

outliers <- which(abs(cl_merton$Result - median(cl_merton$Result)) / cl_mad >= 3)
cl_merton$outlier <- FALSE
cl_merton$outlier[outliers] <- TRUE

par(mar = c(4, 4, 1, 1))
plot(Result ~ Date, data = cl_merton, pch = (!outlier) + 20, type = "b")

# Grub's Test
outliers::grubbs.test(cl_merton$Result)

# Spike Detection
runlength <- rle(cl_merton$Result > 1)
runlength

cl_merton$outlier <- rep(runlength$lengths >= 4 & runlength$value,
                         runlength$lengths)

ggplot(cl_merton, aes(Date, Result, col = outlier)) +
  geom_line(col = "gray") +
  scale_x_date(date_labels = "%b %Y") +
  geom_point(size = 2) +
  scale_color_grey(start = 0.8, end = 0.2, name = "Outlier") +
  theme_bw() +
  theme(legend.position = "bottom")

# Function for Kindsvater-Carter formula

channel_flow <- function(h, b, cd = 0.62, g = 9.81) {
    q <- (2/3) * cd * sqrt(2 * g) * b * h^(3/2)
    return(q)
}

channel_flow(h = c(100, 75, 120) / 1000, b = 0.5)

channel_flow(h = 100 / 1000, b = 0.5, cd = 0.62, g = 9.81)
channel_flow(100 / 1000, 0.5)
channel_flow(100 / 1000, 0.5, g = 3.72)

channel_flow

sum

cd <- 12
channel_flow(100 / 1000, 0.5)

q <- 0
channel_flow(100 / 1000, 0.5, g = 3.72)
q

q <- 0
channel_flow2 <- function(h, b, cd = 0.62, g = 9.81) {
  q <<- (2/3) * cd * sqrt(2 * g) * b * h^(3/2)
  return(q)
}
channel_flow2(100 / 1000, 0.5, g = 3.72)
q

diurnal <- round(c(1.36, 1.085, 0.98, 1.05, 1.58, 3.87,
                   9.37, 13.3, 12.1, 10.3, 8.44, 7.04,
                   6.11, 5.68, 5.58, 6.67, 8.32, 10.0,
                   9.37, 7.73, 6.59, 5.18, 3.55, 2.11, 1)) - 1

ggplot(tibble(Time = (0:24) * 3600,
              Flow = diurnal)) +
  aes(Time, Flow) +
  geom_area(fill = "gray") +
  scale_x_time(labels = scales::label_time(format = '%H:%M'),
               breaks = seq(0, 24, 6) * 3600) +
  theme_minimal() +
  labs(title = "Diurnal curve internal water consumption",
       x = "Hour", y = "Per capita water consumption (l/p/h)")

leaks <- meter_reads %>%
  group_by(device_id) %>%
  mutate(time = as.numeric(timestamp - lag(timestamp)),
         volume = 5 * (count - lag(count, default = 0)),
         flow = volume / time) %>%
  summarise(min_flow = min(flow, na.rm = TRUE)) %>%
  filter(min_flow > 0)

detect_leaks <- function(reads) {
  tibble(reads) %>%
    mutate(volume = 5 * (reads - lag(reads, default = 0))) %>%
    summarise(min_volume = min(volume, na.rm = TRUE)) %>%
    pull(min_volume)
}

detect_leaks(meter_reads$count[meter_reads$device_id == 1515776])
detect_leaks(meter_reads$count[meter_reads$device_id == 1873453])

set.seed(12345)
x <- c(rnorm(100, 10, 3), rnorm(100, 20, 1))
y <- c(rnorm(100, 10, 3), rnorm(100, 20, 1))
xy <- data.frame(x, y)

# Multivariate anomaly detection

library(FNN)
xy_knn <- get.knn(xy, k = 5)
xy$`k-Nearest Neighbours` <- rowMeans(xy_knn$nn.dist)

library(dbscan)
xy$`Local Outlier Factor` <- lof(xy, minPts = 5)

library(tidyverse)
tibble(xy) %>%
  pivot_longer(-1:-2, names_to = "Method") %>%
  ggplot(aes(x, y, size = value, col = value > 2.5)) +
  geom_point() +
  scale_color_manual(values = c("black", "gray")) +
  facet_wrap(~Method, strip.position = "bottom") +
  theme_void() +
  theme(legend.position = "none",
        strip.text.x = element_text(margin = margin(10, 0, 2 ,0, "mm"),
                                    size = 11))
