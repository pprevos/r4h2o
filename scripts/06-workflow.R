##################################
# R4H2O: 7 - Data Science Workflow
##################################

# Prepare: Load and Tidy data

library(tidyverse)
labdata <- read_csv("data/labdata.csv")
chlorine <- filter(labdata, Measure == "Chlorine Total")

# Understand: Explore

par(mar = c(8, 4, 4, 1))
boxplot(Result ~ Suburb, data = chlorine, pch = 19, cex = .5, las = 2)
abline(h = c(0.25, 0.6), col = "red", lty = 2)

ggplot(chlorine, aes(Date, Result)) + 
  geom_line() + 
  geom_hline(yintercept = 0.6, col = "red") + 
  scale_x_date(date_breaks = "year", date_labels = "%Y") + 
  facet_wrap(~Suburb) + 
  theme_minimal() + 
  labs(title = "Gormsey chlorine levels",
       caption = "Source: Laboratory data",
       x = NULL)

# Understand: Model

chlorine_suburb <- group_by(chlorine, Suburb)

chlorine_results <- summarise(chlorine_suburb,
                              Minimum = min(Result),
                              Mean = mean(Result),
                              Max = max(Result),
                              Taste = round(sum(Result > 0.6) / n() * 100))

arrange(chlorine_results, Taste)

knitr::kable(arrange(chlorine_results, Taste), digits = 2,
             col.names = c("Suburb", "Minimum Cl", "Mean Cl", 
                           "Maximum Cl", "Negative taste %"))

# Presenting numbers

a <- sqrt(777)
print(a)

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
