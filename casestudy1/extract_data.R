## R4H2O: Data Science for Water Professionals
## Data extracted from Coliban Water data warehouse for case study 1

## Libraries
library(RODBC)
library(tidyverse)
library(stringr)
library(lubridate)

## Extract laboratory data from database
dwh <- odbcDriverConnect("driver={SQL Server};
                         server=datawarehouse;
                         database=datawarehouse;
                         trusted_connection=true")

labdata <- sqlQuery(dwh, "SELECT Sample_No, Date_Sampled AS Date, Subsite_Code AS Sample_Point, 
                                 System, Zone, Measure, Result, Units  
                          FROM WSL_retic_Sample_results 
                          WHERE Subsite_Type='Customer Tap' AND
                                Measure IN ('Turbidity', 'THMs', 'E Coli', 'Chlorine') AND
                                Date_sampled>='2017-01-01' AND 
                                Date_sampled<='2018-12-31' AND
                                System IN ('Bendigo')")
odbcCloseAll()

labdata$Date <- as.Date(labdata$Date, tz = "")
year(labdata$Date) <- 2069

## List of sample points per zone
sample_points <- labdata %>%
    distinct(Sample_Point, .keep_all = TRUE) %>%
    select(Zone, Sample_Point)

## Assign fictitious town names to randomised zones
towns <- tibble(Zone = sample(unique(sample_points$Zone), 
                                length(unique(sample_points$Zone))),
                  Town = c("Southwold",
                           "Wakefield",
                           "Tarnstead",
                           "Blancathey",
                           "Swadlincote",
                           "Merton",
                           "Snake's Canyon",
                           "Bellmoral",
                           "Paethsmouth",
                           "Pontybridge",
                           "Strathmore"))

## Assign random sample point names
g_sample_points <- tibble(Sample_Point = unique(sample_points$Sample_Point),
                          Sample_Point_new = sample(1E4:2E4, length(unique(sample_points$Sample_Point)), replace = FALSE))

## Collate the data
gormsey <- sample_points %>% 
    left_join(towns) %>% 
    left_join(g_sample_points) %>%
    select(Sample_Point, Town, Sample_Point_new) %>%
    right_join(labdata) %>%
    select(Sample_No, Date, Sample_Point = Sample_Point_new, Town,
           Measure, Result, Units) %>%
    mutate(Sample_No = sample(6E5:7E5, nrow(labdata)),
           Sample_Point = paste0(toupper(str_sub(Town, 1, 2)), "_", Sample_Point),
           Measure = str_replace_all(Measure, "E Coli", "E. coli"),
           Measure = str_replace_all(Measure, "THMs", "THM"))

glimpse(gormsey)

## Modify data to make it more interesting
set.seed(1969)

e.coli <- which(gormsey$Measure == "E. coli")
gormsey$Result[sample(e.coli, 3)] <- sample(1:5, 3)
summary(gormsey$Result[gormsey$Measure == "E. coli"])

thms <- which(gormsey$Measure == "THM" & gormsey$Town %in% c("Merton", "Southwold"))
gormsey$Result[sample(thms, 5)] <- round(runif(5, 0.21, 1), 5)
summary(gormsey$Result[gormsey$Measure == "THM"])

turbidity <- which(gormsey$Measure == "Turbidity" & gormsey$Town %in% c("Strathmore", "Pontybridge"))
gormsey$Result[sample(turbidity, 12)] <- round(runif(12, 5, 9), 2)
summary(gormsey$Result[gormsey$Measure == "Turbidity"])

## Write to disk
write_csv(gormsey, "casestudy1/gormsey.csv")
