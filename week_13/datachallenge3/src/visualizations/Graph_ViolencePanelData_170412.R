#  ####################################################################### 
#       File-Name:      Graph_ViolencePanelData_170412.R
#       Version:        R 3.3.2
#       Date:           Apr 12, 2017
#       Author:         HX/MM
#       Purpose:        Perform statistical analyses on balanced panel data created
#                       from selected municipalities during all available months.
#       Input Files:    ViolencePanelData_170412.csv (processed panel data)
#       Output Files:   NONE
#       Data Output:    NONE
#       Previous files: NONE
#       Dependencies:   Gather_ViolencePanelData_170412.R
#       Required by:    NONE 
#       Status:         IN PROGRESS
#       Machine:        Mac laptop
#  ####################################################################### 

rm(list=ls(all=TRUE))   # cleans everything in the workspace

library(tidyverse)        # pretty graphs made easy

# ::::::: SOME USEFUL DEFINITIONS :::::::::::::::::::::::::::::::::::::::::::::  

# set the general path for the project at its root, specific files will define 
# their own branches individually
# NOTE that specifying your path will be different in Windows

# path <- YOUR PATH HERE

# define additional paths for files you will use. In each case, determine
# appropriate additions to the path

inFileName1  <- "data//processed//ViolencePanelData_170412.csv"    # processed panel data

outFileName1 <- "graphs//ViolencePanel_LineGraph1.pdf"             # output file name
outFileName2 <- "graphs//ViolencePanel_LineGraph2.pdf"             # output file name
outFileName3 <- "graphs//ViolencePanel_ViolinPlot1.pdf"            # output file name
outFileName4 <- "graphs//ViolencePanel_PACF.pdf"                   # output file name


# ::::::: APPLY INITIAL DEFINITIONS ::::::::::::::::::::::::::::::::::::::::::: 

# set your path to that defined above, and confirm it
setwd(path)
getwd()

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
# :::::::::::::::::::::: LOADS DATA :::::::::::::::::::::::::::::::::::::::::::  

# ::::::: LOADING RAW DATA
# note that read_csv() guesses column types, so that date is read as a date 
# very useful for plotting time series

panel <- read_csv(inFileName1) 

# rough validations that data was correctly loaded
names(panel)
nrow(panel)
summary(panel)


# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
# :::::::::::::::::::::: SOME INITIAL GRAPHING ::::::::::::::::::::::::::::::::  

# plot organized.crime.dead by sum of all municipalities
panel %>%
  group_by(date) %>%
  summarise(organized.crime.dead = sum(organized.crime.dead)) %>%
  ggplot() +
  geom_line(aes(x = date, y = organized.crime.dead)) +
  scale_x_date("", date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous("organized crime deaths \n (by month)") +
  theme_minimal() +
  ggsave(file = outFileName1,       
         width = 300, height = 180, units = "mm", dpi = 300)


# plot time series of organized.crime.dead by each one of 10 selected municipalities (10 plot)
ggplot(panel) +
  geom_line(aes(x = date, y = organized.crime.dead)) +
  facet_wrap(~ as.factor(municipality), scales = "fixed", ncol = 2) +
  scale_x_date("year", date_breaks = "1 year", date_labels = "%y") +
  scale_y_continuous("organized crime deaths \n (by month)") +
  theme_minimal()+
  ggsave(file = outFileName2,
         width = 300, height = 180, units = "mm", dpi = 300)

# plot organized.crime.dead by each one of 10 selected municipalities (10 plot)
ggplot(panel) +
  geom_violin(aes(x = municipality, y=organized.crime.dead)) +
  scale_x_discrete("") +
  scale_y_continuous("organized crime deaths \n (by month)") +
  theme_minimal() +
  ggsave(file = outFileName3,
         width = 300, height = 180, units = "mm", dpi = 300)




# get initial sense of the lags of organized.crime.dead (Y)
pdf(outFileName4)
pacf(panel$organized.crime.dead, lag.max = 40, main = "")
dev.off()

