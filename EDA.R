library(tidyverse)
suppressPackageStartupMessages('tidyverse')

crime_data <- read.csv('data\\ucr_crime_1975_2015.csv')

View(crime_data)
summary(crime_data)
str(crime_data)

crime_data %>% 
  filter(department_name=='Arlington, Texas')

drop <- c('source','url')
crime_data %>% 
  filter(colnames(crime_data) %in% drop)

crime_data <- crime_data[ , !(names(crime_data) %in% drop)]

str(crime_data)

View(crime_data %>% 
  group_by(year) %>% 
  summarise(n=n()))
