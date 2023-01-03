library(tidyverse)
labdata <- read_csv("data/water_quality.csv")
chlorine <- filter(labdata, Measure == "Chlorine Total")

par(mar = c(8, 4, 4, 1))
boxplot(Result ~ Suburb, data = chlorine, pch = 19, cex = .5,
        las = 2, xlab = NULL, ylab = "Chlorine level [mg/l]")
abline(h = c(0.25, 0.6), col = "red", lty = 2)

ggplot(chlorine, aes(Date, Result)) + 
  geom_line() + 
  geom_hline(yintercept = 0.6, col = "red") + 
  scale_x_date(date_breaks = "year", date_labels = "%Y") + 
  facet_wrap(~Suburb) + 
  theme_minimal() + 
  labs(title = "Gormsey chlorine levels", x = NULL)

chlorine_suburb <- group_by(chlorine, Suburb)

chlorine_results <- summarise(chlorine_suburb,
                              Minimum = min(Result),
                              Mean = mean(Result),
                              Max = max(Result),
                              Taste = round(sum(Result > 0.6) / n() * 100))

arrange(chlorine_results, Taste)

arrange(chlorine_results, desc(Taste)) %>%
  top_n(3) %>%
  mutate(across(c(Minimum, Mean, Max), round, 2)) %>% 
  select(Suburb, `Minimum Cl` = Minimum, 'Mean Cl' = Mean,
         `Maximum Cl` = Max, `Negative taste %` = Taste)

(a <- sqrt(777))

round(a) # Show as integer

round(a, digits = 2) # Round to two digits

round(a, digits = -1) # Rounding to a power of ten

floor(a) # Remove all digits

ceiling(a) # Round up to the nearest integer

signif(a, 5) # Show 5 characters

format(2^32, big.mark =",")

format(2^128, big.mark =",")

format(2^128, big.mark =",", scientific = FALSE)

paste("Mean THM value is", round(mean(thm$Result), 2), "Mg/l", sep = ": ")
