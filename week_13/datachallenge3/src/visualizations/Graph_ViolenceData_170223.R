#  ####################################################################### 
#       File-Name:      Graph_ViolenceData_Analysis_170223.R
#       Version:        R 3.3.2
#       Date:           Feb 23, 2017
#       Author:         MM
#       Purpose:        Graph violence data that accompanies statistical
#                       analyses when applying three basic algorithms:
#                       OLS, logistic regression and random forest
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
library(ggplot2)        # pretty graphs made easy
library(reshape2)       # nice correlation plots
library(magrittr)       # ceci n'est pas une pipe


# ::::::: SOME USEFUL DEFINITIONS :::::::::::::::::::::::::::::::::::::::::::::  

# set the general path for the project at its root, specific files will define 
# their own branches individually
# NOTE that specifying your path will be different in Windows

path <- "~//Dropbox//GR5069_Spring2017//GR5069//week_07//datachallenge2"

path <- "C://Users//206455361//Dropbox (Personal)//GR5069_Spring2017//GR5069//week_07//datachallenge2"

# define additional paths for files you will use. In each case, determine
# appropriate additions to the path

inFileName1   <- "data//processed/AllViolenceData_170216.csv"      # cleaned data on violence
outFileName1  <- "graphs//Corrplot1.pdf"                           # output file name
outFileName2  <- "graphs//AllData_Hist2.pdf"                       # output file name
outFileName3  <- "graphs//AllData_Hist3.pdf"                       # output file name
outFileName4  <- "graphs//AllData_Hist4.pdf"                       # output file name


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

# a simple correlation plot among all variables in the model to assess
# structure and facilitate model diagnosis and interpretation 

# to create the correlation plot, we need to:
# first define the subset of variables to those variables that we are focusing on

col_vector <- c("organized.crime.dead", "organized.crime.wounded", "afi", "army",
          "navy", "federal.police", "long.guns.seized", "small.arms.seized",
          "clips.seized", "cartridge.sezied")

# then create a dataframe that creates the combinations from the correlation 
# matrix
correlations <- AllData %>% 
  select_(.dots = col_vector) %>%
  cor(.) %>%
  round(2) %>%
  melt()

# and then we graph
ggplot(correlations, aes(x=Var1, y=Var2, fill= value))+
  geom_tile(color = "white") +
  theme_minimal() +
  scale_x_discrete("") +
  scale_y_discrete("") +
  theme(axis.text.x = element_text(angle =30, vjust =1, hjust =1)) +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") 
ggsave(file = outFileName1, 
       width = 300, height = 180, units = "mm", dpi = 300)



# a look at the distribution of the DV
ggplot(data = AllData) +
  geom_bar(aes(x=organized.crime.dead), fill = "blue") +
  theme_minimal() +
  scale_x_continuous("", breaks = c(0, 1,2,3,4,5,10,15,20,30),
                     labels = c("0", "1","2","3","4", "5","10","15","20","30")) +
  scale_y_continuous("") +  
  theme(axis.text.y = element_text(size=14), 
        axis.text.x = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()
  ) 
ggsave(file = outFileName2, 
       width = 300, height = 180, units = "mm", dpi = 300)



# a look at the distribution of the logged DV
ggplot(data = AllData) +
  geom_bar(aes(x=log(organized.crime.dead+1)), fill = "blue") +
  theme_minimal() +
  scale_x_continuous("", breaks = c(0, 1,2,3,4,5,10,15,20,30),
                     labels = c("0", "1","2","3","4", "5","10","15","20","30")) +
  scale_y_continuous("") +  
  theme(axis.text.y = element_text(size=14), 
        axis.text.x = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()
  ) 
ggsave(file = outFileName3, 
       width = 300, height = 180, units = "mm", dpi = 300)






# first we ned to convert the continuous death variables into a
# binary indicator
AllData$organized.crime.death <- ifelse(AllData$organized.crime.dead > 1, 1, 0)

ggplot(data = AllData) +
  geom_bar(aes(x=organized.crime.death,
               y = (..count..)/sum(..count..)), fill = "brown4") +
  scale_y_continuous("", labels = scales::percent) +
  scale_x_continuous("", breaks = c(0, 1),
                     labels = c("no deaths", "deaths")) +
  theme_minimal() +
  theme(axis.text.y = element_text(size=14), 
        axis.text.x = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()
  ) 
ggsave(file = outFileName4, 
       width = 300, height = 180, units = "mm", dpi = 300)










# WHAT PERCENTAGE OF ALL DEATHS HAPPENED IN EVENTS OF "PERFECT LETHALITY"?

print(paste0(
    round((sum(AllData$organized.crime.dead[AllData$perfect.lethality == 1])/
               sum(AllData$organized.crime.dead))*100, digits = 2), 
    " percent of organized crime deaths happened in events of perfect lethality" 
))

# building a nice graph to show this

base <- ggplot(data = AllData) 

base + 
    geom_bar(aes(x=factor(perfect.lethality), 
                 y = (..count..)/sum(..count..)), fill = "orangered2") + 
    scale_y_continuous("", labels = scales::percent) +
    scale_x_discrete("", labels = element_blank()) +
    annotate("text", x = factor(0), y = .60, 
             label = "dead > 0 \n wounded = 0", fontface = 2, 
             color = "white", size = 8) +
    annotate("text", x = factor(1), y = .18, 
             label = "dead > 0 \n wounded > 0", fontface = 2, 
             color = "white", size = 8) +
    theme_minimal() +
    theme(axis.text.y = element_text(size=16)) 
ggsave(file = outFileName1, 
       width = 300, height = 180, units = "mm", dpi = 300)

# what are we really talking about in terms of data

# first, to sort the graph we need to make "category"
# a factor variable with the ordering of levels we need
AllData$category <- factor(AllData$category, 
                           levels = c("no.dead.wounded",
                                      "perfect.lethality",
                                      "dead.wounded",
                                      "just.wounded")) 

# since we modified the base data, we need to reset the data
# in ggplot for this graph

ggplot(data = AllData) +
    geom_bar(aes(x=category, 
                 y = (..count..)/sum(..count..)), fill = "brown4") +
    scale_y_continuous("", labels = scales::percent) +
    scale_x_discrete("", labels = c(
        "no.dead.wounded" = "neither dead \n nor wounded", 
        "perfect.lethality" = "perfect \n lethality",
        "dead.wounded" = "both dead \n and wounded", 
        "just.wounded" = "just wounded")) +
    
    annotate("text", x = "no.dead.wounded", y = .50, 
             label = "dead = 0 \n wounded = 0", fontface = 2, 
             color = "white", size = 8) +
    annotate("text", x = "perfect.lethality", y = .20, 
             label = "dead > 0 \n wounded = 0", fontface = 2, 
             color = "white", size = 8) +
    annotate("text", x = "dead.wounded", y = .04, 
             label = "dead > 0 \n wounded > 0", fontface = 2, 
             color = "white", size = 8) +
    annotate("text", x = "just.wounded", y = .04, 
             label = "dead = 0 \n wounded > 0", fontface = 2, 
             color = "white", size = 8) +
    theme_minimal() +
    theme(axis.text.y = element_text(size=16),
          axis.text.x = element_text(size=12)) 
ggsave(file = outFileName2, 
       width = 300, height = 180, units = "mm", dpi = 300)


# let's look at the cases of the lethality index
ggplot(data = AllData[is.infinite(AllData$organized.crime.lethality)==F,],
       aes(date, organized.crime.lethality)) + 
    geom_point(alpha = 1/2, size = 3) +
    theme_minimal() +
    scale_x_date("", date_breaks = "1 year", date_labels = "%Y")  +
    scale_y_continuous("") +
    theme(axis.text.y = element_text(size=16),
          axis.text.x = element_text(size=12)) 
ggsave(file = outFileName3, 
       width = 300, height = 180, units = "mm", dpi = 300)


# not terribly informative, what of we compute the difference and plot it
ggplot(data = AllData,
       aes(date, organized.crime.lethality.diff)) + 
    geom_point(alpha = 1/2, size = 3) +
    theme_minimal() +
    geom_hline(yintercept = 0, color = "gray", linetype = 2) +
    annotate("text", x = as.Date("2007-06-20"), y =  28, size = 6,
             label = "casualties > wounded", fontface = 2, color = "gray52") +
    annotate("text", x = as.Date("2007-06-20"), y = -19, size = 6,
             label = "wounded > casualties", fontface = 2, color = "gray52") +
    scale_x_date("", date_breaks = "1 year", date_labels = "%Y")  +
    scale_y_continuous("") +
    theme(axis.text.y = element_text(size=16),
          axis.text.x = element_text(size=12)) 
ggsave(file = outFileName4, 
       width = 300, height = 180, units = "mm", dpi = 300)


# much better if we normalize the index by the total of deaths/casualties

ggplot(data = AllData, 
               aes(date, organized.crime.NewIndex)) +
    geom_point(alpha = 1/2, size = 3) +
    geom_hline(yintercept = 0, color = "gray", linetype = 2) +
    annotate("text", x = as.Date("2007-03-20"), y =  .9, size = 6,
             label = "all casualties", fontface = 2, color = "gray52") +
    annotate("text", x = as.Date("2007-03-20"), y = -.9, size = 6,
             label = "all wounded", fontface = 2, color = "gray52") +
    theme_minimal() +
    scale_x_date("", date_breaks = "1 year", date_labels = "%Y") +
    scale_y_continuous("")  +
    theme(axis.text.y = element_text(size=16),
          axis.text.x = element_text(size=12)) 
ggsave(file = outFileName5, 
       width = 300, height = 180, units = "mm", dpi = 300)


# also, let's plot the number of dead per event in events of perfect lethality
ggplot(data = subset(AllData, category == "perfect.lethality")) +
    geom_rect(aes(xmin = 0.5, xmax = 3.5, ymin = 0, ymax =.5), 
              fill = "gray80", alpha = 1/8) +
    geom_bar(aes(x=organized.crime.dead, 
        y = (..count..)/sum(..count..)), fill = "orangered2") +
    annotate("text", x = 2, y = .48, size = 8,
             label = "80%", fontface = 2, color = "white") +
    theme_minimal() +
    scale_x_continuous("", breaks = c(1,2,3,5,10,15,20,30),
                     labels = c("1","2","3","5","10","15","20","30")) +
    scale_y_continuous("", labels = scales::percent) +  
    theme(axis.text.y = element_text(size=14), 
         axis.text.x = element_text(size=12),
         panel.grid.major.x = element_blank(),
         panel.grid.minor.x = element_blank(),
         panel.grid.minor.y = element_blank()
         ) 
ggsave(file = outFileName6, 
       width = 300, height = 180, units = "mm", dpi = 300)



# also, let's plot the number of dead per event in events of perfect lethality
ggplot(data = AllData) +
  geom_bar(aes(x=organized.crime.dead), fill = "blue") +
  theme_minimal() +
  scale_x_continuous("", breaks = c(0, 1,2,3,4,5,10,15,20,30),
                     labels = c("0", "1","2","3","4", "5","10","15","20","30")) +
  scale_y_continuous("") +  
  theme(axis.text.y = element_text(size=14), 
        axis.text.x = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank()
  ) 
ggsave(file = outFileName7, 
       width = 300, height = 180, units = "mm", dpi = 300)



