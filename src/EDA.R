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
  mutate(homs_sum = as.integer(ifelse(months_reported >= 8 & months_reported < 12,
                              (homs_sum/months_reported)*12, homs_sum)),
         rape_sum = as.integer(ifelse(months_reported >= 8 & months_reported < 12, 
                              (rape_sum/months_reported)*12, rape_sum)),
         rob_sum = as.integer(ifelse(months_reported >= 8 & months_reported < 12, 
                              (rob_sum/months_reported)*12, rob_sum)),
         agg_ass_sum = as.integer(ifelse(months_reported >= 8 & months_reported < 12, 
                              (agg_ass_sum/months_reported)*12, agg_ass_sum)),
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

View(crime_data %>% filter(months_reported == 8))

crime_data <- crime_data %>% 
  mutate(State=gsub('[0-9]+','', x=ORI))

# Export as Clean Csv file 
write_csv(crime_data,'..\\data\\ucr_crime_1975_2015_scaled_Clean.csv')

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



