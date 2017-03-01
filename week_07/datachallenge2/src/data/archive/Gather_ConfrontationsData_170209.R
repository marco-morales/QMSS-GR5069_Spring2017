#  ####################################################################### 
#       File-Name:      Gather_ConfrontationsData_170209.R
#       Version:        R 3.3.2
#       Date:           Feb 09, 2017
#       Author:         MM
#       Purpose:        Extract and transform raw database made public by
#                       the Program on Drug Policies (PDD) that compiles 
#                       violent confrontations between armed forces and 
#                       organized crime in MX between 2007-2011
#       Input Files:    A-E.xlsx    (raw data on confrontations)
#                       ARCH535.csv (name equivalence tables)
#       Output Files:   NONE
#       Data Output:    ConfrontationsData_170209.csv
#       Previous files: NONE
#       Dependencies:   NONE
#       Required by:    NONE 
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

# or, you could just load the tidyverse 
# library(tidyverse)

# ::::::: SOME USEFUL DEFINITIONS :::::::::::::::::::::::::::::::::::::::::::::  

# set the general path for the project at its root, specific files will define 
# their own branches individually
# NOTE that specifying your path will be different in Windows

path <- "~//Dropbox//GR5069_Spring2017//GR5069//week_05//datachallenge1"

# define additional paths for files you will use. In each case, determine
# appropriate additions to the path

inFileName1  <- "data//raw//A-E.xlsx"           # raw data on confrontations
inFileName2  <- "data//external//ARCH535.csv"   # name equivalence tables
outFileName1 <- "data//processed/ConfrontationsData_170209.csv" # output file name


# ::::::: APPLY INITIAL DEFINITIONS ::::::::::::::::::::::::::::::::::::::::::: 

# set your path to that defined above, and confirm it
setwd(path)   
getwd()

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
# :::::::::::::::::::::: LOADS DATA :::::::::::::::::::::::::::::::::::::::::::  


# ::::::: LOADING RAW DATA
# the original file uses 9999 as a sentinel value for missing values changing 
# back to null upon loading

Confrontations <- read_excel(inFileName1, 
                             sheet = 1,
                             na = "9999"   # converting sentinel value to null
)  

# rough validations that data was correctly loaded
names(Confrontations)
nrow(Confrontations)
summary(Confrontations)


# :::::: LOADING NAME CONVERSION TABLE
# the original file treats numeric codes as strings, must convert to integers
# upon loading. Also, names of municipalities are in Spanish, so must specify
# the encoding as the file is read

NameTable <- read_csv(inFileName2, 
                      col_types = cols(
                          CVE_ENT = col_integer(),    # must convert to integer
                          NOM_ENT = col_character(),
                          NOM_ABR = col_character(),
                          CVE_MUN = col_integer(),    # must convert to integer
                          NOM_MUN = col_character()
                          ),
                      locale = locale(encoding = "ISO-8859-1") # to read accents properly
                      )

# rough validations that data was correctly loaded
names(NameTable)
nrow(NameTable)
summary(NameTable)

# :::::::::::::::::::::: SOME DATA PROCESSING :::::::::::::::::::::::::::::::::  

# as released, the database is not immediately usable, so some data processing
# is needed to start exploring the data

# 1. add actual names of states and municipalities from a Census table;
#    currently the database only has their numeric codes
# 2. rename columns from Spanish to English (not everyone speaks both languages)
# 3. convert UNIX timestamp variable to a time object; this will be useful to 
#    seamlessly create a date variable, and extract month names for graphing
# 4. some additional string changes in state abbreviations that will be useful 
#    when graphing
# 5. replace all missing values with 0; this will come in handy as we start to
#    explore the data futher


fullData <- 
    Confrontations %>% 
        # adding State and Municipality names to dataframe
        left_join(., NameTable, 
                  by = c("ESTADO" = "CVE_ENT",
                         "Municipio" = "CVE_MUN")
        ) %>%    
        # renaming variables to intelligible English  
        rename(day.orig = DIA, 
               month.orig = MES, 
               year.orig = AÑO, 
               state_code = ESTADO,
               mun_code = Municipio, 
               state = NOM_ENT, 
               state.abbr = NOM_ABR,
               municipality = NOM_MUN, 
               event.id = ID, 
               unix.timestamp = TIMESTAMP,
               detained = DE, 
               total.people.dead = PF, 
               military.dead = MIF,
               navy.dead = MAF, 
               federal.police.dead = PFF, 
               afi.dead = AFIF, 
               state.police.dead = PEF,
               ministerial.police.dead = PMF,
               municipal.police.dead = PMUF, 
               public.prosecutor.dead = AMPF, 
               organized.crime.dead = DOF, 
               civilian.dead = CIF, 
               total.people.wounded = PL, 
               military.wounded = MIL, 
               navy.wounded = MAL, 
               federal.police.wounded = PFL,
               afi.wounded = AFIFL,
               state.police.wounded = PEL,
               ministerial.police.wounded = PML, 
               municipal.police.wounded = PMUL,
               public.prosecutor.wounded = AMPL,
               organized.crime.wounded = DOL, 
               civilian.wounded = CIL,
               long.guns.seized = ARL,
               small.arms.seized = ARC,
               cartridge.sezied = CART, 
               clips.seized = CARG,
               vehicles.seized = VE
        ) %>%
        # creating date by converting unix timestamp, other time-related information
        # can later be extracted from this variable
        # also modifying state abbreviations by capitalizing and droping period 
        # to "beautify" graph labels later on
        mutate(date = as.Date(as.POSIXct(unix.timestamp, origin="1970-01-01")),
               state.abbr = str_to_upper(str_replace_all(state.abbr, "[[:punct:]]", "")) 
        ) %>%
        # keeping only necessary variables
        select(event.id, unix.timestamp, date, 
               state_code, state, state.abbr, mun_code, municipality, 
               detained, total.people.dead, military.dead, navy.dead, 
               federal.police.dead, afi.dead, state.police.dead, ministerial.police.dead,
               municipal.police.dead, public.prosecutor.dead, organized.crime.dead,
               civilian.dead, total.people.wounded, military.wounded, navy.wounded,
               federal.police.wounded, afi.wounded, state.police.wounded, 
               ministerial.police.wounded, municipal.police.wounded, 
               public.prosecutor.wounded, organized.crime.wounded, civilian.wounded,
               long.guns.seized, small.arms.seized, cartridge.sezied, clips.seized,
               vehicles.seized
        ) %>% 
        # filling in NAs with zeros, to facilitate graphing and basic computations
        # replace_na() requires a list of columns and rules to apply. Code below 
        # provides that
        replace_na(
            setNames(            # creates an object with numeric column names
                lapply(          # applies a function that links numeric column names 
                                 # with the asignment of 0 
                    vector("list", length(select_if(., is.numeric))), # creates a list length 25
                            function(x) x <- 0),  # defines assignment of 0 to numeric col names
                names(select_if(., is.numeric)))  # provides numeric column names
        )

# :::::::::::::::::::::: SAVING PROCESSED FILE ::::::::::::::::::::::::::::::::

write_csv(fullData, outFileName1)

