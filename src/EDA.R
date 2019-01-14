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

crime_data <- crime_data %>% 
  mutate(State=gsub('[0-9]+','', x=ORI))

# Export as Clean Csv file 
write_csv(crime_data,'..\\data\\ucr_crime_1975_2015_Clean.csv')

unique(crime_data$department_name)
length(unique(crime_data$State))

california <- c('CA')
texas <- c('TX','TXSPD','TXHPD')
newyork <- c('NY')
Ohio <- c('OHCOP','OHCLP','OHCIP')
arizona <- c('AZ')
florida <- c('FL')
colorado <- c('CO','CODPD')

head(crime_data)

crime_data_Texas <- crime_data %>% 
    filter(crime_data$State %in% texas) %>% 
    mutate(US_State='Texas')

crime_data_california <- crime_data %>% 
  filter(crime_data$State %in% california) %>% 
  mutate(US_State='California')

crime_data_newyork <- crime_data %>% 
  filter(crime_data$State %in% newyork) %>% 
  mutate(US_State='NewYork')

crime_data_arizona <- crime_data %>% 
  filter(crime_data$State %in% arizona) %>% 
  mutate(US_State='Arizona')

crime_data_florida <- crime_data %>% 
  filter(crime_data$State %in% florida) %>% 
  mutate(US_State='Florida')

crime_data_colorado <- crime_data %>% 
  filter(crime_data$State %in% colorado) %>% 
  mutate(US_State='Colorado')

crime_data_states <- rbind(crime_data_Texas,crime_data_newyork,crime_data_florida,crime_data_arizona,crime_data_colorado,crime_data_california)
View(crime_data_states)

write.csv(crime_data_states,'..\\data\\ucr_crime_1975_2015_US_States.csv')



