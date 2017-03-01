#  ####################################################################### 
#       File-Name:      Graph_ConfrontationsData_170209.R
#       Version:        R 3.3.2
#       Date:           Feb 09, 2017
#       Author:         MM
#       Purpose:        Extract and transform raw database made public by
#                       the Program on Drug Policies (PDD) that compiles 
#                       violent confrontations between armed forces and 
#                       organized crime in MX between 2007-2011
#       Input Files:    Confrontations_170209.csv (cleaned data on confrontations)
#       Output Files:   NONE
#       Data Output:    NONE
#       Previous files: NONE
#       Dependencies:   Gather_ConfrontationsData_170209.R
#       Required by:    NONE 
#       Status:         IN PROGRESS
#       Machine:        Mac laptop
#  ####################################################################### 

rm(list=ls(all=TRUE))   # cleans everything in the workspace

library(readr)          # easier reading of flat files
library(ggplot2)        # pretty graphs made easy
library(lubridate)      # easier manipulation of time objects

# or, you could just load the tidyverse 
# library(tidyverse)

# ::::::: SOME USEFUL DEFINITIONS :::::::::::::::::::::::::::::::::::::::::::::  

# set the general path for the project at its root, specific files will define 
# their own branches individually
# NOTE that specifying your path will be different in Windows

path <- "~//Dropbox//GR5069_Spring2017//GR5069//week_05//datachallenge1"

# define additional paths for files you will use. In each case, determine
# appropriate additions to the path

inFileName1   <- "data//processed/ConfrontationsData_170209.csv"  # cleaned data on confrontations
outFileName1  <- "graphs//Confrontations_LineGraph1.pdf"          # output file name
outFileName2  <- "graphs//Confrontations_LineGraph2.pdf"          # output file name
outFileName3  <- "graphs//Confrontations_DotPlot1.pdf"            # output file name
outFileName4  <- "graphs//Confrontations_DotPlot2.pdf"            # output file name
outFileName5  <- "graphs//Confrontations_DotPlot3.pdf"            # output file name
outFileName6  <- "graphs//Confrontations_DotPlot4.pdf"            # output file name
outFileName7  <- "graphs//Confrontations_DotPlot5.pdf"            # output file name
outFileName8  <- "graphs//Confrontations_DotPlot6.pdf"            # output file name
outFileName9  <- "graphs//Confrontations_DotPlot7.pdf"            # output file name
outFileName10 <- "graphs//Confrontations_DotPlot8.pdf"            # output file name
outFileName11 <- "graphs//Confrontations_Histogram1.pdf"          # output file name


# ::::::: APPLY INITIAL DEFINITIONS ::::::::::::::::::::::::::::::::::::::::::: 

# set your path to that defined above, and confirm it
setwd(path)   
getwd()

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
# :::::::::::::::::::::: LOADS DATA :::::::::::::::::::::::::::::::::::::::::::  


# ::::::: LOADING RAW DATA
# note that read_csv() guesses column types, so that date is read as a date 
# very useful for plotting time series

Confrontations <- read_csv(inFileName1) 
    
# rough validations that data was correctly loaded
names(Confrontations)
nrow(Confrontations)
summary(Confrontations)


# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
# :::::::::::::::::::::: SOME INITIAL GRAPHING ::::::::::::::::::::::::::::::::  

# we start by defining the data and aesthetics for the raw data and call it "base"
# then we can add bells and whistles at will 
base <- ggplot(data = Confrontations, aes(date, total.people.dead)) 

# let's start simple... it's a time-series after all
base + geom_line() + scale_x_date(date_labels = "%b %Y")
ggsave(file = outFileName1, 
       width = 300, height = 180, units = "mm", dpi = 300)


# hmmm it's daily data, so line graphs may not reveal too much. Is it a labelling issue?
base + geom_line() + scale_x_date(date_breaks = "1 year", date_labels = "%b %Y")
ggsave(file = outFileName2, 
       width = 300, height = 180, units = "mm", dpi = 300)


# lines are too distracting with data that's so dense... maybe there's some merit
# in looking at the raw scattered data 
base + geom_point() 
ggsave(file = outFileName3, 
       width = 300, height = 180, units = "mm", dpi = 300)


# there's something of a there there, but not yet too clear. Could we find some sort of 
# pattern if we do local averages?
base + geom_point() + geom_smooth(method = "loess") 
ggsave(file = outFileName4, 
       width = 300, height = 180, units = "mm", dpi = 300)


# not much of a local average pattern. Perhaps we can learn something from
# overlaying just organized-crime deaths...
base + geom_point() + 
    geom_point(aes(date, organized.crime.dead), color = "red")
ggsave(file = outFileName5, 
       width = 300, height = 180, units = "mm", dpi = 300)


# a slicker way to present differences between two data points in a graph
base + geom_point(aes(date, organized.crime.dead), color = "red", alpha = 1/3) + 
    geom_point(aes(date, total.people.dead), shape = 1) +
    geom_linerange(aes(ymin = organized.crime.dead, ymax = total.people.dead), color = "gray")
ggsave(file = outFileName6, 
       width = 300, height = 180, units = "mm", dpi = 300)


# let's clean it up a little bit from visual clutter
base + geom_point(aes(date, organized.crime.dead), color = "red", alpha = 1/3) + 
  geom_point(aes(date, total.people.dead), shape = 1) +
  geom_linerange(aes(ymin = organized.crime.dead, ymax = total.people.dead), color = "gray") +
  theme_minimal() +
  scale_x_date("", date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous("total deaths")
ggsave(file = outFileName7, 
       width = 300, height = 180, units = "mm", dpi = 300)

# let's see if we can find some seasonal patterns here, when we break it down by year
base + geom_point(aes(date, organized.crime.dead), color = "red", alpha = 1/3) + 
    geom_point(aes(date, total.people.dead), shape = 1) +
    geom_linerange(aes(ymin = organized.crime.dead, ymax = total.people.dead), color = "gray") +
    theme_minimal() + 
    facet_wrap(~year(date), scales = "free", ncol = 1) +
    scale_x_date("", date_breaks = "1 month", date_labels = "%b") +
    scale_y_continuous("total deaths")
ggsave(file = outFileName8, 
       width = 300, height = 180, units = "mm", dpi = 300)


# always, always explain what you're looking at... may be clear to you now, but not in the future
base + geom_point(aes(date, organized.crime.dead, color = "organized crime"), alpha = 1/3) + 
    geom_point(aes(date, total.people.dead), shape = 1) +
    geom_linerange(aes(ymin = organized.crime.dead, ymax = total.people.dead, color = "total")) +
    theme_minimal() + 
    facet_wrap(~year(date), scales = "free", ncol = 1) +
    scale_x_date("", date_breaks = "1 month", date_labels = "%b") +
    scale_y_continuous("total deaths") +
    scale_color_manual(values=c("organized crime" = "red", "total"="gray")) +
    theme(legend.title = element_blank())
ggsave(file =outFileName9, 
       width = 300, height = 180, units = "mm", dpi = 300)


# adding a rug may help (or not..)
base + geom_point(aes(date, organized.crime.dead, color = "organized crime"), alpha = 1/3) + 
  geom_point(aes(date, total.people.dead), shape = 1) +
  geom_linerange(aes(ymin = organized.crime.dead, ymax = total.people.dead, color = "total")) +
  theme_minimal() + 
  geom_rug(sides = "l") +
  facet_wrap(~year(date), scales = "free", ncol = 1) +
  scale_x_date("", date_breaks = "1 month", date_labels = "%b") +
  scale_y_continuous("total deaths") +
  scale_color_manual(values=c("organized crime" = "red", "total"="gray")) +
  theme(legend.title = element_blank())
ggsave(file =outFileName10, 
       width = 300, height = 180, units = "mm", dpi = 300)



# what if we aggregate data by month, do we get a better sense of the data?
# we have to create first a month variable
Confrontations$Month  <- as.Date(cut(Confrontations$date, breaks = "month"))

# then change the ggplot data to use our new month variable as date
base.monthly <- ggplot(data = Confrontations, aes(Month, total.people.dead))

# then plot the data with a summary stat that's flexible enough
base.monthly + 
    stat_summary(fun.y = sum, geom = "bar", aes(Month,total.people.dead,fill = "total")) +
    stat_summary(aes(Month,organized.crime.dead, fill = "organized crime"), fun.y = sum, geom = "bar") +
    theme_minimal() + 
    facet_wrap(~year(date), scales = "free_x", ncol = 1) +
    scale_x_date("", date_labels ="%b",date_breaks = "1 month") +
    scale_y_continuous("total deaths") +
    scale_fill_manual(values=c("organized crime" = "red", "total"="gray")) +
    theme(legend.title = element_blank())
ggsave(file =outFileName11, 
       width = 300, height = 180, units = "mm", dpi = 300)

