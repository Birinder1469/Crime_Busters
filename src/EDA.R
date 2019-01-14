library(tidyverse)
library(naniar)
suppressPackageStartupMessages('tidyverse')

# Load Data 
crime_data <- read.csv('..\\data\\ucr_crime_1975_2015.csv')

# removed the source and Url columns which were empty
crime_data <- crime_data %>% select(-source, -url)

View(crime_data %>% 
  group_by(year) %>% 
  summarise(n=n()))

View(crime_data %>% 
  group_by(department_name) %>% 
  summarise(n=n()))

#Dropped Department with Na values 
crime_data <- drop_na(crime_data)

#Change all entry with less than 8 months reported with NA
crime_data <- crime_data %>% 
  mutate(homs_sum = replace(homs_sum, months_reported < 8, NA),
         rape_sum = replace(rape_sum, months_reported < 8, NA),
         rob_sum = replace(rob_sum, months_reported < 8, NA),
         agg_ass_sum = replace(agg_ass_sum, months_reported < 8, NA),
         violent_crime = replace(violent_crime, months_reported < 8, NA),
         homs_per_100k = replace(homs_per_100k, months_reported < 8, NA),
         rape_per_100k = replace(rape_per_100k, months_reported < 8, NA),
         rob_per_100k = replace(rob_per_100k, months_reported < 8, NA),
         agg_ass_per_100k = replace(agg_ass_per_100k, months_reported < 8, NA),
         violent_per_100k = replace(violent_per_100k, months_reported < 8, NA))

#Scale entries with 8 to 11 months reported to estimate crimes in the whole year
crime_data <- crime_data %>% 
  mutate(homs_sum = ifelse(months_reported >= 8 & months_reported < 12,
                              (homs_sum/months_reported)*12, homs_sum),
         rape_sum = ifelse(months_reported >= 8 & months_reported < 12, 
                              (rape_sum/months_reported)*12, rape_sum),
         rob_sum = ifelse(months_reported >= 8 & months_reported < 12, 
                              (rob_sum/months_reported)*12, rob_sum),
         agg_ass_sum = ifelse(months_reported >= 8 & months_reported < 12, 
                              (agg_ass_sum/months_reported)*12, agg_ass_sum),
         violent_crime = ifelse(months_reported >= 8 & months_reported < 12, 
                              (violent_crime/months_reported)*12,violent_crime),
         homs_per_100k = ifelse(months_reported >= 8 & months_reported < 12, 
                              (homs_per_100k/months_reported)*12, homs_per_100k),
         rape_per_100k = ifelse(months_reported >= 8 & months_reported < 12, 
                                   (rape_per_100k/months_reported)*12, rape_per_100k),
         rob_per_100k = ifelse(months_reported >= 8 & months_reported < 12, 
                                   (rob_per_100k/months_reported)*12, rob_per_100k),
         agg_ass_per_100k = ifelse(months_reported >= 8 & months_reported < 12, 
                                   (agg_ass_per_100k/months_reported)*12, agg_ass_per_100k),
         violent_per_100k = ifelse(months_reported >= 8 & months_reported < 12, 
                                   (violent_per_100k/months_reported)*12, violent_per_100k))

crime_data <- crime_data %>% 
  mutate(State=gsub('[0-9]+','', x=ORI))

# Export as Clean Csv file 
write_csv(crime_data,'..\\data\\ucr_crime_1975_2015_Clean.csv')

