##############################
#
# R4H2O: 13 - MACHINE LEARNING
#
##############################

# Download data

url <- "http://archive.ics.uci.edu/ml/machine-learning-databases/concrete/
        compressive/Concrete_Data.xls"
download.file(url, destfile = "data/concrete-data.xls")

library(readxl)
library(tidyverse)

concrete <- read_excel("data/concrete-data.xls")
names(concrete) <- tolower(names(concrete))
names(concrete) <- str_remove_all(names(concrete), "[[:punct:]]")
names(concrete) <- str_remove(names(concrete), "component.*")
names(concrete) <- str_trim(names(concrete))
names(concrete) <- str_replace_all(names(concrete), " ", "_")
names(concrete)[9] <- "compressive_strength"
glimpse(concrete)

## MULTIPLE LINEAR REEGRESSION

## Create training and testing sets

set.seed(123)
n <- nrow(concrete)
train_id <- sample(1:n, 0.7 * n)

concrete_train <- concrete[train_id, ]
concrete_test <- concrete[-train_id, ]

t <- nrow(concrete_test)
test_id <- sample(1:t, 0.5 * t)

concrete_test1 <- concrete_test[test_id, ]
concrete_test2 <- concrete_test[-test_id, ]

## Explore training data

pivot_longer(concrete_train, -compressive_strength,
             names_to = "component", values_to = "amount") %>%
  mutate(component = str_replace_all(component, "_", " "),
         component = str_to_title(component)) %>%
  ggplot(aes(amount, compressive_strength)) +
  geom_point(alpha = .3, col = "darkgray") +
  facet_wrap(~component, scales = "free_x") +
  geom_smooth(method = "lm", se = FALSE, col = "black", linetype = 5) +
  theme_minimal() +
  labs(x = "Amount (kg)", y = "Strength (MPa)")

## Linear model with a simple mixture

(lm_min <- lm(compressive_strength ~ I(water / cement) +
                   coarse_aggregate + fine_aggregate + age_day - 1
               , data = concrete_train))

## Linear model with all variables

(lm_all <- lm(compressive_strength ~ . - 1, data = concrete_train))

## Predictions with test sets

concrete_test1$predict <- predict(lm_min, newdata = concrete_test1)
concrete_test2$predict <- predict(lm_all, newdata = concrete_test2)

## Root Mean Square Error (RMSE)

rmse <- function(yhat, y) {
  sqrt(mean((yhat - y)^2))
}

(rmse_min <- rmse(concrete_test1$predict, concrete_test1$compressive_strength))
(rmse_all <- rmse(concrete_test2$predict, concrete_test2$compressive_strength))

## Visualise prediction performance

par(mfcol = c(1, 2))
plot(predict ~ compressive_strength, data = concrete_test1,
     main = "Parsimonious model", pch = 20,
     sub = paste("RMSE =", round(rmse_min)))
abline(a = 0, b = 1, col = "red")
plot(predict ~ compressive_strength, data = concrete_test2,
     main = "All variables", pch = 20,
     sub = paste("RMSE =", round(rmse_all)))
abline(a = 0, b = 1, col = "red")

## DECISION TREES

## Create classes in concrete data

classes <- seq(0, 90, by = 20) # Create cutting points
concrete$class <- cut(round(concrete$compressive_strength),
                      breaks = classes, 
                      labels = paste0("C", classes[-length(classes)] + 10))
concrete_class <- dplyr::select(concrete, -compressive_strength)

set.seed(123)
n <- nrow(concrete_class)
train_id <- sample(1:n, 0.7 * n)

concrete_class_train <- concrete_class[train_id, ]
concrete_class_test <- concrete_class[-train_id, ]

t <- nrow(concrete_class_test)
test_id <- sample(1:t, 0.5 * t)

concrete_class_test1 <- concrete_class_test[test_id, ]
concrete_class_test2 <- concrete_class_test[-test_id, ]

## Grow decision trees

library(rpart)

tree_min <- rpart(class ~ I(water / cement) +
                    coarse_aggregate +
                    fine_aggregate +
                    age_day,
                  data = concrete_class_train, method = "class")

tree_all <- rpart(class ~ ., data = concrete_class_train,
                  method = "class")

## Visualise trees

library(rpart.plot)
tree_vis <- rpart(class ~ ., data = concrete_class_train,
                  method = "class", maxdepth = 3)
rpart.plot(tree_vis, extra = 2)

## Cross-Validation

predict_tree_min <- predict(tree_min,
                            newdata = concrete_class_test1, type = "class")

predict_tree_all <- predict(tree_all,
                            newdata = concrete_class_test2, type = "class")

confusion_matrix_min <- table(predict_tree_min, concrete_class_test1$class)
confusion_matrix_all <- table(predict_tree_all, concrete_class_test2$class)

confusion_matrix_all

cm <- confusion_matrix_all

(tp <- diag(cm))
(fn <- colSums(cm) - diag(cm))
(fp <- rowSums(cm) - diag(cm))
(tn <- sum(cm) - (colSums(cm) + rowSums(cm) - diag(cm)))

sum(diag(confusion_matrix_min) / sum(confusion_matrix_min))
sum(diag(confusion_matrix_all) / sum(confusion_matrix_all))

(sensitivity <- tp / (tp + fn))
(specificity <- tn / (tn + fp))

caret::confusionMatrix(predict_tree_all, concrete_class_test2$class)
