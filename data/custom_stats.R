
#Load Libs
library(readr)
library(dplyr)
library(tidyr)
library(knitr)
library(stringr)
options("scipen"=100, "digits"=4)
setwd("G:\\My Drive\\Projects\\COVID_USA")


today_date <- as.Date(Sys.Date(), "%y%m%d/") 
yes_date <- as.Date(Sys.Date(), "%y%m%d/") -1
today_date_mmddyy <- format(today_date, "%m-%d-%Y")
yes_date_mmddyy <- format(yes_date, "%m-%d-%Y")

urlfile="https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/"
today_url = paste(urlfile, today_date_mmddyy, ".csv", sep="")
yes_url <- paste(urlfile, yes_date_mmddyy, ".csv", sep="")
today_data <- read_csv(url(today_url))
yes_data <- read_csv(url(yes_url))





colnames(today_data) <- c('FIPS', 'Admin', "State", "Country", "time", "Latitude", "Longitude", "Confirmed", "Deaths", "Recovered", "activ", 'combinedkey')
today_data <- today_data %>% mutate(date = as.Date(time)) %>% filter(date==today_date) 
today_data <- today_data %>% group_by(State, Country, date) %>% summarise(Confirmed = sum(Confirmed), Deaths = sum(Deaths), Recovered = sum(Recovered))

colnames(yes_data) <- c('FIPS', 'Admin', "State", "Country", "time", "Latitude", "Longitude", "Confirmed", "Deaths", "Recovered", "activ", 'combinedkey')

yes_data <- yes_data %>% mutate(date = as.Date(time)) %>% filter(date==yes_date)

yes_data <- yes_data %>% group_by(State, Country, date) %>% summarise(Confirmed = sum(Confirmed), Deaths = sum(Deaths), Recovered = sum(Recovered))





new_data <- merge(today_data, yes_data, by.x=c("Country", "State"), by.y=c("Country", "State")) %>% select(-c(date.x, date.y))

new_data_state <- new_data %>% filter(!is.na(State)) %>% select(-State) %>% group_by(Country) %>%
  summarise_all(funs(sum)) %>% mutate(State=NA)

world <- new_data %>% select(-c(Country, State)) %>% summarise_all(funs(sum)) %>% mutate(Country='World', State=NA)
  
final_data <- rbind(new_data_state, new_data, world)


final_data <- final_data %>%  
  transmute(country = Country,
            state= State,
    region = str_replace(paste(Country, '_', State, sep=''),pattern="_NA",replacement=''),
    new_c = Confirmed.x-Confirmed.y,
            new_r = Recovered.x-Recovered.y,
            new_d = Deaths.x - Deaths.y,
            new_a = new_c - (new_r+new_d),
            c = Confirmed.x,
            r = Recovered.x,
            d = Deaths.x,
            a = c-(r+d),
            date  = as.Date(Sys.Date()))

write.csv(final_data, "country_state_list.csv", row.names = FALSE)


# Code for yesterday's statistics so that we can get numbers like what it was yesterday

today_date <- as.Date(Sys.Date(), "%y%m%d/") -1
yes_date <- as.Date(Sys.Date(), "%y%m%d/") -2
today_date_mmddyy <- format(today_date, "%m-%d-%Y")
yes_date_mmddyy <- format(yes_date, "%m-%d-%Y")

urlfile="https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/"
today_url = paste(urlfile, today_date_mmddyy, ".csv", sep="")
yes_url <- paste(urlfile, yes_date_mmddyy, ".csv", sep="")
today_data <- read_csv(url(today_url))
yes_data <- read_csv(url(yes_url))





colnames(today_data) <- c('FIPS', 'Admin', "State", "Country", "time", "Latitude", "Longitude", "Confirmed", "Deaths", "Recovered", "activ", 'combinedkey')
today_data <- today_data %>% mutate(date = as.Date(time)) %>% filter(date==today_date) 
today_data <- today_data %>% group_by(State, Country, date) %>% summarise(Confirmed = sum(Confirmed), Deaths = sum(Deaths), Recovered = sum(Recovered))

colnames(yes_data) <- c('FIPS', 'Admin', "State", "Country", "time", "Latitude", "Longitude", "Confirmed", "Deaths", "Recovered", "activ", 'combinedkey')

yes_data <- yes_data %>% mutate(date = as.Date(time)) %>% filter(date==yes_date)

yes_data <- yes_data %>% group_by(State, Country, date) %>% summarise(Confirmed = sum(Confirmed), Deaths = sum(Deaths), Recovered = sum(Recovered))





new_data <- merge(today_data, yes_data, by.x=c("Country", "State"), by.y=c("Country", "State")) %>% select(-c(date.x, date.y))

new_data_state <- new_data %>% filter(!is.na(State)) %>% select(-State) %>% group_by(Country) %>%
  summarise_all(funs(sum)) %>% mutate(State=NA)

world <- new_data %>% select(-c(Country, State)) %>% summarise_all(funs(sum)) %>% mutate(Country='World', State=NA)

final_data <- rbind(new_data_state, new_data, world)


final_data <- final_data %>%  
  transmute(country = Country,
            state= State,
            region = str_replace(paste(Country, '_', State, sep=''),pattern="_NA",replacement=''),
            new_c = Confirmed.x-Confirmed.y,
            new_r = Recovered.x-Recovered.y,
            new_d = Deaths.x - Deaths.y,
            new_a = new_c - (new_r+new_d),
            c = Confirmed.x,
            r = Recovered.x,
            d = Deaths.x,
            a = c-(r+d),
            date  = as.Date(Sys.Date()))

write.csv(final_data, "country_state_list_yest.csv", row.names = FALSE)

