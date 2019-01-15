library(tidyverse)
library(naniar)
suppressPackageStartupMessages('tidyverse')

# Load Data 
crime_data <- read.csv('..\\data\\ucr_crime_1975_2015.csv')

# removed the source and Url columns which were empty
crime_data <- crime_data %>% select(-source, -url)

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

crime_data <- crime_data %>% 
  mutate(State=gsub('[0-9]+','', x=ORI))

california <- c('CA')
texas <- c('TX','TXSPD','TXHPD')
newyork <- c('NY')
Ohio <- c('OHCOP','OHCLP','OHCIP')
arizona <- c('AZ')
florida <- c('FL')
colorado <- c('CO','CODPD')

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

# merge crime type into a single variable

crime_total <- crime_data_states %>% 
  select(-ORI, -months_reported, -State) %>% 
  select(year, US_State, department_name, homs_sum, rape_sum, rob_sum, agg_ass_sum, violent_crime) %>% 
  gather('homs_sum','rape_sum','rob_sum','agg_ass_sum', key = "crime_type", value = "counts") %>% 
    mutate(crime_type = case_when(crime_type == "homs_sum" ~ "homicide",
                                  crime_type == "rape_sum"~"rape",
                                  crime_type == "rob_sum"~ "robbery",
                                  crime_type == "agg_ass_sum"~'aggressive_assault')) %>% 
    mutate(crime_type = as.factor(crime_type))

crime_100k <- crime_data_states %>% 
     select(-ORI, -months_reported, -State) %>% 
     select(year, US_State, department_name, homs_per_100k, rape_per_100k, rob_per_100k, agg_ass_per_100k, violent_per_100k) %>% 
     gather('homs_per_100k','rape_per_100k','rob_per_100k','agg_ass_per_100k', key = "crime_type", value = "counts_per_100k") %>% 
     mutate(crime_type = case_when(crime_type == "homs_per_100k" ~ "homicide",
                                   crime_type == "rape_per_100k"~"rape",
                                   crime_type == "rob_per_100k"~ "robbery",
                                   crime_type == "agg_ass_per_100k"~'aggressive_assault')) %>% 
     mutate(crime_type = as.factor(crime_type)) 

crime_data_states <- full_join(crime_total, crime_100k, by = c("year", "US_State", "department_name", "crime_type")) %>% 
  select(year, US_State, department_name, total_crime_count = violent_crime, total_crime_per_100k = violent_per_100k, crime_type, counts, counts_per_100k)

write.csv(crime_data_states,'..\\data\\ucr_crime_1975_2015_Final_Clean.csv')
