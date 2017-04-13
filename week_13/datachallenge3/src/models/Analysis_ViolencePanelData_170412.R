#  ####################################################################### 
#       File-Name:      Analysis_ViolencePanelData_170412.R
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

library(ggplot2)        # pretty graphs made easy
library(plm)            # linear models for panel data
library(lmtest)
library(car)

# ::::::: SOME USEFUL DEFINITIONS :::::::::::::::::::::::::::::::::::::::::::::  

# set the general path for the project at its root, specific files will define 
# their own branches individually
# NOTE that specifying your path will be different in Windows

path <- "~//Dropbox//GR5069_Spring2017//GR5069//week_13//datachallenge3"

# define additional paths for files you will use. In each case, determine
# appropriate additions to the path

inFileName1  <- "data//processed//ViolencePanelData_170412.csv"    # processed panel data

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

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
# ::::::::::::::::::::::::::: UNIT-ROOTS TESTS ::::::::::::::::::::::::::::::::  

# check to see if the estimate of a regression of Y_t on Y_{t-1} is close to 1
summary(unit.root.test <- lm(organized.crime.dead ~ organized.crime.dead.L1, 
                             data = panel))

# check to see if the estimate of a regression on residulals on 
# lagged residuals is close to 1
res <- residuals(test.1) # extract residuals from test.1 model, keep NAs
n <- length(res)
summary(test.2 <- lm(res[-1] ~ res[-n]))

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
# :::::::::::::::::::::: FURTHER ANALYSIS :::::::::::::::::::::::::::::::::::::

# 1) CROSS-SECTION EXPLORATION VIA OLS

# pooled model
summary(ols.1 <- lm(organized.crime.dead ~
                    organized.crime.dead.L1 + 
                    organized.crime.wounded +
                    organized.crime.wounded.L1,
                  data = panel))
vif(ols.1)

# fixed effects model
summary(ols.2 <- lm(organized.crime.dead ~
                      organized.crime.dead.L1 + 
                      organized.crime.wounded +
                      organized.crime.wounded.L1 +
                      factor(municipality),
                    data = panel))
vif(ols.2)

# random coefficients model
summary(ols.3 <- lm(organized.crime.dead ~
                     factor(municipality) * organized.crime.dead.L1 +
                     factor(municipality) * organized.crime.wounded +
                     factor(municipality) * organized.crime.wounded.L1,
                   data = panel))
vif(ols.3)


# 2) CALCULATE QOIs

# extract coefficients from the pooled model
(coef <- ols.1$coefficients)

alpha0 <- unname(coef)[1]
alpha1 <- unname(coef)[2]
beta0 <- unname(coef)[3]
beta1 <- unname(coef)[4]

# speed of adjustment
(s <- 1 - alpha1)

# immediate effect
(beta0)

# long-run multiplier
(k1 <- (beta0 + beta1) /(1 - alpha1))

# mean lag length
(mu <- beta1 / (beta0 + beta1) - (-alpha1) / (1 - alpha1))



# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
# :::::::::::::::::::::: MODEL RECONSIDERED :::::::::::::::::::::::::::::::::::


# find correct specification for the lags for the pooled model 
summary(ols.4 <- lm(organized.crime.dead ~
                      organized.crime.dead.L1 + 
                      organized.crime.dead.L2 + 
                      organized.crime.dead.L3 + 
                      organized.crime.dead.L4 + 
                      organized.crime.dead.L5 + 
                      organized.crime.wounded +
                      organized.crime.wounded.L1 ,
                    organized.crime.wounded.L2 +
                      organized.crime.wounded.L3 +
                      organized.crime.wounded.L4 +
                      organized.crime.wounded.L5,
                    data = panel))

# based on the coefficients on lags in ols.4
summary(ols.5 <- lm(organized.crime.dead ~
                      organized.crime.dead.L1 + 
                      organized.crime.dead.L2 + 
                      organized.crime.wounded +
                      organized.crime.wounded.L1 +
                      factor(municipality),
                    data = panel))



