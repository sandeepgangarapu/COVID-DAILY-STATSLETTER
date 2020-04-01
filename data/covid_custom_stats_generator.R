
#Load Libs
library(readr)
library(dplyr)
library(tidyr)
library(knitr)
library(stringr)
options("scipen"=100, "digits"=4)
setwd("G:\\My Drive\\Projects\\COVID_USA")


today_date <- as.Date(Sys.Date(), "%y%m%d/") -1
yes_date <- as.Date(Sys.Date(), "%y%m%d/") -2


urlfile="https://raw.githubusercontent.com/datasets/covid-19/master/data/time-series-19-covid-combined.csv"
data_country_state <- read_csv(url(urlfile)) %>% select(-c(Lat, Long)) %>% rename(Country = `Country/Region`,
                                                                                  State = `Province/State`)

urlfile="https://raw.githubusercontent.com/datasets/covid-19/master/data/countries-aggregated.csv"
data_country <- read_csv(url(urlfile)) %>% mutate(State = NA)


urlfile="https://raw.githubusercontent.com/datasets/covid-19/master/data/worldwide-aggregated.csv"
data_world <- read_csv(url(urlfile)) %>% select(-`Increase rate`) %>%  mutate(State = NA, Country= 'World')

total_data <- rbind(data_country_state, data_country, data_world) %>% 
  mutate(Region = str_replace(paste(Country, '_', State, sep=''),pattern="_NA",replacement=''),)

today_data <- total_data %>% filter(Date==today_date) 
yes_data <- total_data %>% filter(Date==yes_date) 


final_data <- merge(today_data, yes_data, by.x=c("Region"), by.y=c("Region")) %>% select(-c(Date.y))


final_data <- final_data %>%
  transmute(Region = Region,
            `Total Confirmed` = Confirmed.x,
            `Total Recovered` = Recovered.x,
            `Total Deaths` = Deaths.x,
            `Total Active` = Confirmed.x-(Recovered.x+Deaths.x),
            `New Confirmed` = Confirmed.x-Confirmed.y,
            `New Recovered` = Recovered.x-Recovered.y,
            `New Deaths` = Deaths.x - Deaths.y,
            `New Active`  = `New Confirmed` - (`New Recovered`+`New Death`),
            `Perc Increase Confirmed` = `New Confirmed`/Confirmed.y,
            `Perc Increase Deaths` = `New Deaths`/Deaths.y,
            `Date` = Date.x)

write.csv(final_data, "country_state_list.csv", row.names = FALSE)

