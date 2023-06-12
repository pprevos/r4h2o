## Erlang-C Functions
intensity <- function(rate, duration, interval = 60) {
    (rate / interval) * duration
}

erlang_c <- function(agents, rate, duration, interval = 60) {
    int <- intensity(rate, duration, interval)
    erlang_b_inv <- 1
    for (i in 1:agents) {
        erlang_b_inv <- 1 + erlang_b_inv * i / int
    }
    erlang_b <- 1 / erlang_b_inv
    agents * erlang_b / (agents - int * (1 - erlang_b))
}

service_level <- function(agents, rate, duration, target, interval = 60) {
    pw <- erlang_c(agents, rate, duration, interval)
    int <- intensity(rate, duration, interval)
    1 - (pw * exp(-(agents - int) * (target / duration)))
}

resource <- function(rate, duration, target, gos_target, interval = 60) {
    agents <- round(intensity(rate, duration, interval) + 1)
    gos <- service_level(agents, rate, duration, target, interval)
    while (gos < gos_target * (gos_target > 1) / 100) {
        agents <- agents + 1
        gos <- service_level(agents, rate, duration, target, interval)
    }
    return(c(agents, gos))
}

library(tidyverse)

intensity_mc <- function(rate_m, rate_sd, duration_m, duration_sd, interval = 60, sims = 1000) {
  (rnorm(sims, rate_m, rate_sd) / (60 * interval)) * rnorm(sims, duration_m, duration_sd)
}

intensity_mc(100, 10, 180, 20, interval = 30) %>%
  summary()

erlang_c_mc <- function(agents, rate_m, rate_sd, duration_m, duration_sd, interval = 60) {
  int <- intensity_mc(rate_m, rate_sd, duration_m, duration_sd, interval)
  erlang_b_inv <- 1
  for (i in 1:agents) {
    erlang_b_inv <- 1 + erlang_b_inv * i / int
  }
  erlang_b <- 1 / erlang_b_inv
  agents * erlang_b / (agents - int * (1 - erlang_b))
}

service_level_mc <- function(agents, rate_m, rate_sd, duration_m, duration_sd, target, interval = 60, sims = 1000) {
  pw <- erlang_c_mc(agents, rate_m, rate_sd, duration_m, duration_sd, interval)
  int <- intensity_mc(rate_m, rate_sd, duration_m, duration_sd, interval, sims)
  1 - (pw * exp(-(agents - int) * (target / rnorm(sims, duration_m, duration_sd))))
}

tibble(ServiceLevel = service_level_mc(agents = 14,
                                       rate_m = 100,
                                       rate_sd = 10,
                                       duration_m = 180,
                                       duration_sd = 20,
                                       target = 20,
                                       interval = 30,
                                       sims = 1000)) %>%
  ggplot(aes(ServiceLevel)) +
  geom_histogram(binwidth = 0.05, fill = "#008da1") +
  scale_x_continuous(labels = scales::percent) + 
  theme_bw(base_size = 10) +
  labs(title = "Call Centre Monte Carlo Simulation")
