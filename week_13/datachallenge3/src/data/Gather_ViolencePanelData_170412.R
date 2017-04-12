#  ####################################################################### 
#       File-Name:      Gather_ViolencePanelData_170412.R
#       Version:        R 3.3.2
#       Date:           Apr 12, 2017
#       Author:         HX/MM
#       Purpose:        Select a subset of municipalities and convert into 
#                       balanced month/municipality panel data
#       Input Files:    AllViolenceData_170216.csv (cleaned data on violence)
#       Output Files:   NONE
#       Data Output:    ViolencePanelData_170412.csv (processed panel data)
#       Previous files: NONE
#       Dependencies:   NONE
#       Required by:    Analysis_ViolencePanelData_170412.R 
#       Status:         IN PROGRESS
#       Machine:        Mac laptop
#  ####################################################################### 

rm(list=ls(all=TRUE))   # cleans everything in the workspace

library(readr)          # easier reading of flat files
library(readxl)         # easier reading of excel files
library(dplyr)          # data manipulation functions
library(tidyr)          # tools for tidy datasets
library(magrittr)       # ceci n'est pas un pipe
library(lubridate)      # easier manipulation of time objects
library(stringr)        # easier manipulation of strings
library(reshape2)       # a much more flexible reshaping for our purpose here
library(plm)

# or, you could just load the tidyverse 
# library(tidyverse)

# ::::::: SOME USEFUL DEFINITIONS :::::::::::::::::::::::::::::::::::::::::::::  

# set the general path for the project at its root, specific files will define 
# their own branches individually
# NOTE that specifying your path will be different in Windows

#path <- "~//Dropbox//GR5069_Spring2017//GR5069//week_13//datachallenge3"

path <- "C:\\Users\\206455361\\Dropbox (Personal)\\GR5069_Spring2017\\GR5069\\week_13\\datachallenge3"

# define additional paths for files you will use. In each case, determine
# appropriate additions to the path

inFileName1  <- "data//processed//AllViolenceData_170216.csv"       # cleaned data on violence

outFileName1 <- "data//processed//ViolencePanelData_170412.csv"     # processed panel data


# ::::::: APPLY INITIAL DEFINITIONS ::::::::::::::::::::::::::::::::::::::::::: 

# set your path to that defined above, and confirm it
setwd(path)   
getwd()

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
# :::::::::::::::::::::: LOADS DATA :::::::::::::::::::::::::::::::::::::::::::  

# ::::::: LOADING RAW DATA
# note that read_csv() guesses column types, so that date is read as a date 
# very useful for plotting time series

AllData <- read_csv(inFileName1) 

# rough validations that data was correctly loaded
names(AllData)
nrow(AllData)
summary(AllData)

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
# ::::::::::::::::::::: SOME DATA PROCESSING ::::::::::::::::::::::::::::::::::

# select relevant columns to create panel data
vars <- c("date", "state_code", "mun_code", "state.abbr",  "municipality" ,
          "organized.crime.dead", "organized.crime.wounded")  

sub <- AllData %>% 
  subset(select = vars) %>%
  unite(id, state_code, mun_code) %>% 
  # combine state and mun codes to create unique municipality id
  group_by(id) %>%
  mutate(event_count = n()) %>%
  # count the number of events that happened in each municipality
  arrange(desc(event_count))
# sort event_count in descending order to select municipalities where
# violent events take place most frequently

# get the cutpoint value of event_count to subset 10 municipalities with the
# highest number of events
count_value_10th <- unique(sub[, c("id", "event_count")])[10, "event_count"]

sub_10mun <- sub %>%
  filter(event_count >= count_value_10th) %>% 
  # subset the first 10 municipalities with the highest event_count
  transform(id = as.numeric(as.factor(id))) %>% 
  # generate unique id 1:10 for 10 municipalities
  arrange(date) %>%
  separate(date, c("year", "month", "day")) %>%
  group_by(year, month, id, state.abbr, municipality) %>%
  summarise(organized.crime.dead = sum(organized.crime.dead),
            organized.crime.wounded = sum(organized.crime.wounded)) %>%
  # aggregate by month instead of days, sum up Y and X by each month/municipality
  unite(date, year, month, sep = "-") %>%
  mutate(date = as.Date(paste0(date, "-01")))
# create Date variable solely based on year-month, fill day with default 01

# convert unbalanced to balanced panel data, 
panel <- make.pbalanced(sub_10mun, 
                        balance.type = "fill", # fill: union of available time
                        # periods over all ids. Missing
                        # time periods for individuals
                        # are inserted and filled with NA
                        index = c("id", "date"))

# a quick whipping of hack to fill in names on all rows
panel %<>%
  mutate(municipality = ifelse(id == 1, "Acapulco de Ju\U00E1rez",
                               ifelse(id == 2, "Monterrey",
                               ifelse(id == 3, "Tijuana",
                                      ifelse(id == 4, "Culiac\U00E1n",
                                             ifelse(id == 5, "Matamoros",
                                                    ifelse(id == 6, "Nuevo Laredo",
                                                           ifelse(id == 7, "Reynosa",
                                                                  ifelse(id == 8, "Torre\U00F3n",
                                                                         ifelse(id == 9, "Chihuahua",
                                                                                "Ju\U00E1rez"
                                                                                ))))))))))


panel[is.na(panel)] <- 0  # fill NAs with 0: missing values of one municipality
# in particular month shows no violent events happen

# convert variable date back to obejct of class "Date"
panel$date <- as.Date(panel$date, origin = "1970-01-01")

# create lag variables for both Y and X
panel <- panel %>%
  group_by(id) %>%
  mutate(organized.crime.dead.L1 = lag(organized.crime.dead),
         organized.crime.wounded.L1 = lag(organized.crime.wounded))

# :::::::::::::::::::::: SAVING PROCESSED FILE ::::::::::::::::::::::::::::::::

write_csv(panel, outFileName1)
