
#Load Libs
library(readr)
library(dplyr)
library(tidyr)
library(knitr)
library(stringr)
library(selectr)
library(xml2)
library(rvest)

options("scipen"=100, "digits"=4)
setwd("G:\\My Drive\\Projects\\COVID_USA\\data")


# replace  mutate(date = as.Date(yes_date))  replace yes_date with time

today_date <- as.Date(Sys.Date(), "%y%m%d/") -
yes_date <- as.Date(Sys.Date(), "%y%m%d/") -1
today_date_mmddyy <- format(today_date, "%m-%d-%Y")
yes_date_mmddyy <- format(yes_date, "%m-%d-%Y")

urlfile="https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/"
today_url = paste(urlfile, today_date_mmddyy, ".csv", sep="")
yes_url <- paste(urlfile, yes_date_mmddyy, ".csv", sep="")
today_data <- read_csv(url(today_url))
yes_data <- read_csv(url(yes_url))


colnames(today_data) <- c('FIPS', 'Admin', "State", "Country", "time", "Latitude", "Longitude", "Confirmed", "Deaths", "Recovered", "Active", 'combinedkey')
today_data <- today_data %>% mutate(date = as.Date(time)) %>% filter(date==today_date) %>%
  select(-c(Latitude, Longitude, combinedkey, FIPS, date, time))


colnames(yes_data) <- c('FIPS', 'Admin', "State", "Country", "time", "Latitude", "Longitude", "Confirmed", "Deaths", "Recovered", "Active", 'combinedkey')
yes_data <- yes_data %>% mutate(date = as.Date(time))  %>% filter(date==yes_date) %>% 
  select(-c(Latitude, Longitude, combinedkey, FIPS, date, time))



new_data <- merge(today_data, yes_data, by.x=c("Country", "State", "Admin"), by.y=c("Country", "State", "Admin"))

state_country_df <- new_data %>% select(State, Country) %>% filter(!is.na(State)) %>% unique()

new_data_state <- new_data %>% filter(!is.na(State)) %>% select(-c(Admin, Country)) %>% group_by(State) %>%
  summarise_all(funs(sum)) %>% mutate(Admin=NA) %>%
  merge(state_country_df, by='State', all.x = TRUE, all.y = FALSE)


new_data_country <- new_data %>% filter(!is.na(State)) %>% select(-c(State, Admin)) %>% group_by(Country) %>%
  summarise_all(funs(sum)) %>% mutate(State=NA, Admin=NA)

world <- new_data %>% select(-c(Country, State, Admin)) %>% summarise_all(funs(sum)) %>%
  mutate(Country='World', State=NA, Admin=NA)

final_data <- rbind(new_data_state, new_data, new_data_country, world) %>%
  mutate(region = str_replace(str_replace(paste(Country, '_', State,'_', Admin, sep=''),pattern="_NA",replacement=''),pattern="_NA",replacement=''))



final_data <- final_data %>%
  transmute(region = region,
            `Total Confirmed` = Confirmed.x,
            `Total Recovered` = Recovered.x,
            `Total Deaths` = Deaths.x,
            `Total Active` = Active.x,
            `New Confirmed` = Confirmed.x-Confirmed.y,
            `New Recovered` = Recovered.x-Recovered.y,
            `New Deaths` = Deaths.x - Deaths.y,
            `New Active`  = Active.x - Active.y)

write.csv(final_data, "country_state_list_2.csv", row.names = FALSE)


#Load Libs
library(readr)
library(dplyr)
library(tidyr)
library(knitr)
library(stringr)
library(selectr)
library(xml2)
library(rvest)

options("scipen"=100, "digits"=4)
setwd("G:\\My Drive\\Projects\\COVID_USA\\data")


# replace  mutate(date = as.Date(yes_date))  replace yes_date with time

today_date <- as.Date(Sys.Date(), "%y%m%d/") -1
yes_date <- as.Date(Sys.Date(), "%y%m%d/") -2
today_date_mmddyy <- format(today_date, "%m-%d-%Y")
yes_date_mmddyy <- format(yes_date, "%m-%d-%Y")

urlfile="https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/"
today_url = paste(urlfile, today_date_mmddyy, ".csv", sep="")
yes_url <- paste(urlfile, yes_date_mmddyy, ".csv", sep="")
today_data <- read_csv(url(today_url))
yes_data <- read_csv(url(yes_url))


colnames(today_data) <- c('FIPS', 'Admin', "State", "Country", "time", "Latitude", "Longitude", "Confirmed", "Deaths", "Recovered", "Active", 'combinedkey')
today_data <- today_data %>% mutate(date = as.Date(time)) %>% filter(date==today_date) %>%
  select(-c(Latitude, Longitude, combinedkey, FIPS, date, time))


colnames(yes_data) <- c('FIPS', 'Admin', "State", "Country", "time", "Latitude", "Longitude", "Confirmed", "Deaths", "Recovered", "Active", 'combinedkey')
yes_data <- yes_data %>% mutate(date = as.Date(time))  %>% filter(date==yes_date) %>% 
  select(-c(Latitude, Longitude, combinedkey, FIPS, date, time))



new_data <- merge(today_data, yes_data, by.x=c("Country", "State", "Admin"), by.y=c("Country", "State", "Admin"))

state_country_df <- new_data %>% select(State, Country) %>% filter(!is.na(State)) %>% unique()

new_data_state <- new_data %>% filter(!is.na(State)) %>% select(-c(Admin, Country)) %>% group_by(State) %>%
  summarise_all(funs(sum)) %>% mutate(Admin=NA) %>%
  merge(state_country_df, by='State', all.x = TRUE, all.y = FALSE)


new_data_country <- new_data %>% filter(!is.na(State)) %>% select(-c(State, Admin)) %>% group_by(Country) %>%
  summarise_all(funs(sum)) %>% mutate(State=NA, Admin=NA)

world <- new_data %>% select(-c(Country, State, Admin)) %>% summarise_all(funs(sum)) %>%
  mutate(Country='World', State=NA, Admin=NA)

final_data <- rbind(new_data_state, new_data, new_data_country, world) %>%
  mutate(region = str_replace(str_replace(paste(Country, '_', State,'_', Admin, sep=''),pattern="_NA",replacement=''),pattern="_NA",replacement=''))



final_data <- final_data %>%
  transmute(region = region,
            `Total Confirmed` = Confirmed.x,
            `Total Recovered` = Recovered.x,
            `Total Deaths` = Deaths.x,
            `Total Active` = Active.x,
            `New Confirmed` = Confirmed.x-Confirmed.y,
            `New Recovered` = Recovered.x-Recovered.y,
            `New Deaths` = Deaths.x - Deaths.y,
            `New Active`  = Active.x - Active.y)

write.csv(final_data, "country_state_list_2_yest.csv", row.names = FALSE)

