#  ####################################################################### 
#       File-Name:      Analysis_ViolenceData_170223.R
#       Version:        R 3.3.2
#       Date:           Feb 23, 2017
#       Author:         MM
#       Purpose:        Perform statistical analyses on transformed data from
#                       the Program on Drug Policies (PDD) that compiles 
#                       violent confrontations between armed forces and 
#                       organized crime in MX between 2007-2011
#       Input Files:    AllViolenceData_170216.csv (cleaned data on violence)
#       Output Files:   NONE
#       Data Output:    NONE
#       Previous files: NONE
#       Dependencies:   Gather_ViolenceData_170216.R
#       Required by:    NONE 
#       Status:         IN PROGRESS
#       Machine:        Mac laptop
#  ####################################################################### 

rm(list=ls(all=TRUE))   # cleans everything in the workspace

library(readr)          # easier reading of flat files
library(caret)          # ML package


# or, you could just load the tidyverse 
# library(tidyverse)

# ::::::: SOME USEFUL DEFINITIONS :::::::::::::::::::::::::::::::::::::::::::::  

# set the general path for the project at its root, specific files will define 
# their own branches individually
# NOTE that specifying your path will be different in Windows

path <- "~//Dropbox//GR5069_Spring2017//GR5069//week_07//datachallenge2"

# define additional paths for files you will use. In each case, determine
# appropriate additions to the path

inFileName1   <- "data//processed/AllViolenceData_170216.csv"     # cleaned data on violence

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
# :::::::::::::::::::::: SOME INITIAL GRAPHING ::::::::::::::::::::::::::::::::  

# 1) ORDINARY LEAST SQUARES

# one quick spin-up of OLS


summary(
  lm(organized.crime.dead ~ organized.crime.wounded +
       afi + army + navy + federal.police +
       long.guns.seized+ small.arms.seized + 
       clips.seized + cartridge.sezied, 
     data = AllData) 
  )


# another quick-spinup of OLS with multiplicative interactions

ols.interaction <-
  lm(organized.crime.dead ~ organized.crime.wounded +
       afi*long.guns.seized + 
       army*long.guns.seized + 
       navy*long.guns.seized + 
       federal.police*long.guns.seized +
       afi*cartridge.sezied + 
       army*cartridge.sezied + 
       navy*cartridge.sezied + 
       federal.police*cartridge.sezied +
       small.arms.seized + 
       clips.seized , 
     data = AllData) 
summary(ols.interaction) 



# how do we correctly compute interactive effects?
# first, extract the vector with the estimated coefficients, 
# and the estimated covariance matrix

beta <- coef(ols.interaction)                # extracts a vector of betas
varcov <- as.matrix(vcov(ols.interaction))   # extracts estimated covariance matrix
se <- sqrt(diag(vcov(ols.interaction)))      # extracts a vector with standard errors

# define some useful value for your marginal effect, 
# in this case, if the event reports 30 long guns seized
long.guns <- 5 

# compute marginal effect 1: marginal effect of the number of long.guns.seized
# on number of dead, where the navy intervenes, per formulas in slides
mfx.1 <- as.numeric(beta["navy"]) + 
  as.numeric(beta["long.guns.seized:navy"])*long.guns
mfx.1.se <- se["navy"] + 
  long.guns^2*se["long.guns.seized:navy"] +
  2*long.guns*varcov["navy", "long.guns.seized:navy"]


# marginal effect 2: marginal effect of zero long.guns.seized
# on number of dead, where the army intervenes per formulas in slides
mfx.2 <- as.numeric(beta["army"]) + 
  as.numeric(beta["long.guns.seized:army"])*0
mfx.2.se <- se["army"] + 
  0^2*se["long.guns.seized:army"] +
  2*0*varcov["navy", "long.guns.seized:army"]


# 2) LOGISTIC REGRESSION

# first we ned to convert the continuous death variables into a
# binary indicator
AllData$organized.crime.death <- ifelse(AllData$organized.crime.dead > 1, 1, 0)


# then, we estimate a similar model attempting to analyze deaths
summary(
  glm(organized.crime.death ~ organized.crime.wounded +
       afi + army + navy + federal.police +
       long.guns.seized+ small.arms.seized + 
       clips.seized + cartridge.sezied, 
      family = binomial(link = "logit"), 
     data = AllData) 
)



# 3) RANDOM FOREST
