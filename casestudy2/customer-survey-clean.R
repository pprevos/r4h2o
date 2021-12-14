# Clean customer survey data

rawdata <- read_csv("casestudy2/customer_survey.csv")

cities <- tibble(city = 1:3,
                 city_name = c("Merton", "Snake's Canyon", "Wakefield"))

customers <- rawdata[-1, ] %>%
  type_convert() %>%
  filter(is.na(term)) %>%
  left_join(cities) %>% 
  rename(id = V1) %>%
  select(c(1, 52, 21:51, -33)) 

rm(rawdata, cities)
