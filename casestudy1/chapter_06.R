## R4H2O: Data Science for Water Professionals
## Chapter 6: Visualise data

library(tidyverse)
gormsey <- read_csv("casestudy1/gormsey.csv")

ggplot(gormsey)

ggplot(gormsey, aes(Town))

ggplot(gormsey, aes(Town)) + 
    geom_bar()

turbidity <- filter(gormsey, Measure == "Turbidity")

ggplot(turbidity, aes(Date, Result, col = Town)) + 
    geom_line()

ggplot(turbidity, aes(Date, Result, col = Town)) + 
    geom_line() + 
    facet_wrap(~Town)

ggplot(turbidity, aes(Town, Result, fill = Town)) + 
    geom_boxplot() 

ggplot(turbidity, aes(Town, Result, fill = Town)) + 
    geom_boxplot() +
    scale_y_log10() +
    coord_flip()

thm <- filter(gormsey, Measure == "THM")
thm_date <- group_by(thm, Date)
thm_max <- summarise(thm_date, thm_max = max(Result))

ggplot(thm_max, aes(Date, thm_max)) + 
    geom_line() + 
    geom_smooth(method = "lm") + 
    geom_hline(yintercept = 0.25, col = "red")

ggplot(turbidity, aes(Date, Result)) + 
    geom_area(fill = "red", col = "black") + 
    facet_wrap(~Town, ncol = 1) + 
    theme_void()

ggplot(filter(turbidity, Town == "Strathmore"), aes(Date, Result)) + 
    geom_line() +
    labs(title = "Turbidity Results", 
         subtitle = "Strathmore customer taps",
         x = "Date sampled", y = "NTU") + 
    geom_hline(yintercept = 5, col = "red") + 
    theme_bw()

ggsave("manuscript/resources/05_visualisation/labels.png")
