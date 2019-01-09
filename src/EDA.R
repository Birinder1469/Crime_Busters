library(tidyverse)
suppressPackageStartupMessages('tidyverse')

# Load Data 
crime_data <- read.csv('..\\data\\ucr_crime_1975_2015.csv')

View(crime_data)
summary(crime_data)
str(crime_data)

crime_data %>% 
  filter(department_name=='Arlington, Texas')

crime_data %>% 
  select(-source, -url)

unique(crime_data$department_name)
unique(crime_data$months_reported)
crime_data %>% filter(is.na(months_reported))

# removed the source and Url columns which were empty
crime_data <- crime_data %>% select(-source, -url)
str(crime_data)

View(crime_data %>% 
  group_by(year) %>% 
  summarise(n=n()))

View(crime_data %>% 
  group_by(department_name) %>% 
  summarise(n=n()))

str(drop_na(data = crime_data))
summary(crime_data)

summary(drop_na(crime_data,c('ORI')))

#Dropped Na values 
crime_data <- drop_na(crime_data)

crime_data[, crime_data$months_reported!=12]

# Chose the data for only the states where 12 month crime data has been reported
crime_data <- crime_data %>% 
  filter(months_reported==12)

View(crime_data)

# Export as Clean Csv file 
write_csv(crime_data,'..\\data\\ucr_crime_1975_2015_Clean.csv')
