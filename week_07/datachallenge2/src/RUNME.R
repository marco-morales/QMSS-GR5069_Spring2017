#  ####################################################################### 
#       File-Name:      RUNME.R
#       Version:        R 3.3.2
#       Date:           Feb 16, 2017
#       Author:         MM
#       Purpose:        Script that should be run in order to replicate 
#                       full project. File names indicated on this file 
#                       correspond to the latest files for the project 
#       Input Files:    NONE
#       Output Files:   NONE
#       Data Output:    NONE
#       Previous files: NONE
#       Dependencies:   NONE
#       Required by:    NONE 
#       Status:         IN PROGRESS
#       Machine:        Mac laptop
#  ####################################################################### 

rm(list=ls(all=TRUE))   # cleans everything in the workspace

# ::::::: SOME USEFUL DEFINITIONS :::::::::::::::::::::::::::::::::::::::::::::  

# set the general path for the project at its root, specific files will define 
# their own branches individually
# NOTE that specifying your path will be different in Windows

path <- "~//Dropbox//GR5069_Spring2017//GR5069//week_07//datachallenge2"

# ::::::: APPLY INITIAL DEFINITIONS ::::::::::::::::::::::::::::::::::::::::::: 

# set your path to that defined above, and confirm it
setwd(path)   
getwd()

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
# ::::::::::::::: RUN ALL SCRIPTS IN APPROPRIATE ORDER ::::::::::::::::::::::::


# :::::::: DATA PROCESSING

# run latest script to create the base data
source("src//data//Gather_ViolenceData_170216.R")


# :::::::: DATA VISUALIZATION AND EXPLORATION

# run latest script to create appropriate exploratory graphs 
source("src//visualizations/Graph_ViolenceData_170216.R")

# run latest script to create appropriate diagnostic graphs 
source("src//visualizations/Graph_ViolenceData_170223.R")

# :::::::: DATA VISUALIZATION AND EXPLORATION

# run latest script to create appropriate exploratory graphs 
source("src//models/Analysis_ViolenceData_170223.R")
