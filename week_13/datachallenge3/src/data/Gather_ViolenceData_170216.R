#  ####################################################################### 
#       File-Name:      Gather_ConfrontationsData_170216.R
#       Version:        R 3.3.2
#       Date:           Feb 16, 2017
#       Author:         MM
#       Purpose:        Extract and transform raw database made public by
#                       the Program on Drug Policies (PDD) that compiles 
#                       violent confrontations and aggression between armed 
#                       forces and organized crime in MX between 2007-2011.
#                       ADDS agressions data and consolidates into a single 
#                       database.
#                       ADDS table specifying federal force involved in 
#                       Confrontation event
#       Input Files:    A-E.xlsx    (raw data on confrontations)
#                       A-A.xlsx    (raw data on aggressions)
#                       ARCH535.csv (name equivalence tables)
#                       tabla9-A-E.xlsx (federal forces involved in confrontations)
#                       tabla9-A-A.xlsx (federal forces involved in aggressions)
#                       LookupAuthorityNames.csv (conversion tables for federal forces codes)
#       Output Files:   NONE
#       Data Output:    AllViolenceData_170216.csv
#       Previous files: Gather_ConfrontationsData_170209.R
#       Dependencies:   NONE
#       Required by:    Graph_ConfrontationsData_170216.R 
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

# or, you could just load the tidyverse 
# library(tidyverse)

# ::::::: SOME USEFUL DEFINITIONS :::::::::::::::::::::::::::::::::::::::::::::  

# set the general path for the project at its root, specific files will define 
# their own branches individually
# NOTE that specifying your path will be different in Windows

path <- "~//Dropbox//GR5069_Spring2017//GR5069//week_06//datachallenge1"

# define additional paths for files you will use. In each case, determine
# appropriate additions to the path

inFileName1  <- "data//raw//A-E.xlsx"                           # raw data on confrontations
inFileName2  <- "data//external//ARCH535.csv"                   # name equivalence tables
inFileName3  <- "data//raw//tabla9-A-E.xlsx"                    # id of federal forces involved in confrontation event
inFileName4  <- "data//external//LookupAuthorityNames.csv"      # name of federal forces involved
inFileName5  <- "data//raw//A-A.xlsx"                           # raw data on agressions
inFileName6  <- "data//raw//tabla9-A-A.xlsx"                    # id of federal forces involved in agression event

outFileName1 <- "data//processed/AllViolenceData_170216.csv" # output file name


# ::::::: APPLY INITIAL DEFINITIONS ::::::::::::::::::::::::::::::::::::::::::: 

# set your path to that defined above, and confirm it
setwd(path)   
getwd()

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
# :::::::::::::::::::::: LOADS DATA :::::::::::::::::::::::::::::::::::::::::::  


# ::::::: LOADING RAW DATA FOR CONFRONTATIONS
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


# :::::: LOADING TABLE OF FEDERAL FORCES INVOLVED IN CONFRONTATIONS
# the original file uses 9999 as a sentinel value for missing values changing 
# back to null upon loading

ForcesTable.Confrontations <- read_excel(inFileName3, 
                             sheet = 1,
                             na = "9999"   # converting sentinel value to null
)  

# rough validations that data was correctly loaded
names(ForcesTable.Confrontations)
nrow(ForcesTable.Confrontations)
summary(ForcesTable.Confrontations)

# :::::: LOADING NAME CONVERSION TABLE FOR FEDERAL FORCES NAMES
# the original file treats numeric codes as strings, must convert to integers
# upon loading. Also, names of municipalities are in Spanish, so must specify
# the encoding as the file is read

ForcesNameLookup <- read_csv(inFileName4)

# rough validations that data was correctly loaded
names(ForcesNameLookup)
nrow(ForcesNameLookup)
summary(ForcesNameLookup)


# ::::::: LOADING RAW DATA FOR AGGRESSIONS
# the original file uses 9999 as a sentinel value for missing values changing 
# back to null upon loading

Aggressions <- read_excel(inFileName5, 
                             sheet = 1,
                             na = "9999"   # converting sentinel value to null
)  

# rough validations that data was correctly loaded
names(Aggressions)
nrow(Aggressions)
summary(Aggressions)


# :::::: LOADING TABLE OF FEDERAL FORCES INVOLVED IN AGGRESSIONS
# the original file uses 9999 as a sentinel value for missing values changing 
# back to null upon loading

ForcesTable.Aggressions <- read_excel(inFileName6, 
                                         sheet = 1,
                                         na = "9999"   # converting sentinel value to null
)  

# rough validations that data was correctly loaded
names(ForcesTable.Aggressions)
nrow(ForcesTable.Aggressions)
summary(ForcesTable.Aggressions)

# :::::::::::::::::::::: DEFINE SOME FUNCTIONS ::::::::::::::::::::::::::::::::

dataMunger <- function(baseEventData, StateNames, ForcesTable, SourceString){

    # ::::::::: DESCRIPTION
    #
    # The function performs the following transformations in the data to 
    # produce the desired output data:
    #
    # 1. add actual names of states and municipalities from a Census table;
    #    currently the database only has their numeric codes
    # 2. rename columns from Spanish to English (not everyone speaks both languages)
    # 3. convert UNIX timestamp variable to a time object; this will be useful to 
    #    seamlessly create a date variable, and extract month names for graphing
    # 4. some additional string changes in state abbreviations that will be useful 
    #    when graphing
    # 5. adding a new variable that indicates the armed force involved in the 
    #    confrontation event 
    # 6. replace all missing values with 0; this will come in handy as we start to
    #    explore the data futher
    #
    # ::::: INPUTS
    #
    # i)   BaseEventData - the raw database to be munged
    # ii)  StatesName - a table with State/Municipality names
    # iii) ForcesTable - a table that identifies which armed forces were involved in the event
    # iv)  SourceString  - a string that will identify origin of the table
    #
    #:::::: OUTPUT
    #
    # the function returns a dataframe
    
    fullData <- baseEventData %>% 
        # adding State and Municipality names to dataframe
        left_join(., StateNames, 
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
        # adding new variables to the dataframe that:
        # 1) create a date by converting unix timestamp, other time-related information
        # can later be extracted from this variable
        # 2) modify state abbreviations by capitalizing and droping period 
        # to "beautify" graph labels later on
        # 3) adding a column that indicates the source of the data
        mutate(date = as.Date(as.POSIXct(unix.timestamp, origin="1970-01-01")),
               state.abbr = str_to_upper(str_replace_all(state.abbr, "[[:punct:]]", "")),
               source = SourceString 
        ) %>%
        # adding a variable that indicates which armed force was involved in the 
        # confrontation event
        inner_join(., ForcesTable, by = c("event.id" = "ID") 
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
               vehicles.seized, 
               afi, army, federal.police, ministerial.police, municipal.police, 
               navy, other,state.police, source      
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
    return(fullData)
    }




TableWrangler <- function(ForcesTable, ForcesNameLookup){
    # ::::::::: DESCRIPTION
    #
    # The function munges table that contains the armed forces participating
    # on each event, and needs to be merged with their actual names. Since 
    # certain events have more that one armed force participating, further
    # wrangling needs to happen to produce a single row per event and not 
    # losing information, hence that information is placed in additional 
    # columns.
    #
    # 1. add actual names of armed forces from a manually input table gathered from
    #    data documentation
    # 2. converts a variable containing the names of armed forces into columns
    # 3. remove duplicate records where more than one armed force participated in  
    #    the event
    # 4. keep only needed variables 
    #
    # ::::: INPUTS
    #
    # i)   ForcesTable - the raw additional table to be transformed
    # ii)  ForcesNameLookup - a lookup table with corresponding names for codes
    #
    #:::::: OUTPUT
    #
    # the function returns a dataframe

    parsedTable <- ForcesTable %>%
        # appends the names from the lookup table
        left_join(., ForcesNameLookup, by = c("KEY"= "authority.id")) %>%
        # creates a count variable that will populate corresponding columns
        mutate(., count = 1) %>%
        # fills in with "unknown" all cases where no code is present for 
        # armed forces. Needed to create the corresponding column
        replace_na(., replace = list(authority = "unknown")) %>%
        # converts all values in the authority variable to columns
        spread(., key = authority, value = count) %>%
        # fills in all missing values in these new columns with zeroes
        # needed for the group_by
        replace_na(
            setNames(            # creates an object with numeric column names
                lapply(          # applies a function that links numeric column names 
                    # with the asignment of 0 
                    vector("list", length(select_if(., is.numeric))), # creates a list length 25
                    function(x) x <- 0),  # defines assignment of 0 to numeric col names
                names(select_if(., is.numeric)))  # provides numeric column names
        ) %>%
        # groups by event ID and collapses duplicate values to have one row 
        # per event
        group_by(., ID) %>%
        summarise_each(funs(max)) %>%
        # selects just the necessar variables
        select(ID, afi, army, federal.police, ministerial.police, 
               municipal.police, navy, other, state.police)           
    return(parsedTable)
}



# ::::::::::::::::::::: SOME DATA PROCESSING ::::::::::::::::::::::::::::::::::

# munges table identifying which armed forces participated on each event
Forces.Confrontations <- TableWrangler(ForcesTable.Confrontations, ForcesNameLookup)

Forces.Aggressions <- TableWrangler(ForcesTable.Aggressions, ForcesNameLookup)



# processing all confrontations data
Confrontations.processed <- dataMunger(Confrontations, NameTable, 
                                       Forces.Confrontations, "confrontations")

# processing all aggressions data
Aggressions.processed <- dataMunger(Aggressions, NameTable, 
                                       Forces.Aggressions, "aggressions")

# binds all dataframes into a single one
AllData <- Confrontations.processed %>%
    bind_rows(., Aggressions.processed)
    
# creates new features 
AllData %<>%
    mutate(.,
           # computes lethality indices as defined by Chevigny: dead/wounded
           organized.crime.lethality = organized.crime.dead/organized.crime.wounded,
           army.lethality = military.dead / military.wounded,
           navy.lethality = navy.dead / navy.wounded,
           federal.police.lethality = federal.police.dead / federal.police.wounded,
           
           # computes an alternate measure of the difference between dead and wounded
           organized.crime.lethality.diff = organized.crime.dead-organized.crime.wounded,
           army.lethality.diff = military.dead - military.wounded,
           navy.lethality.diff = navy.dead - navy.wounded,
           federal.police.lethality.diff = federal.police.dead - federal.police.wounded,
           
           # computes new index
           organized.crime.NewIndex = 
               (organized.crime.dead-organized.crime.wounded) / 
               (organized.crime.dead+organized.crime.wounded),
           army.NewIndex = (military.dead - military.wounded)/ 
               (military.dead + military.wounded),
           navy.NewIndex = (navy.dead - navy.wounded)/(navy.dead + navy.wounded),
           federal.police.NewIndex = (federal.police.dead - federal.police.wounded) /
               (federal.police.dead + federal.police.wounded),
           
           # adds perfect lethality indicator
           perfect.lethality = ifelse(is.infinite(organized.crime.lethality) , 1,0), 
           # adss category
           category = ifelse(is.infinite(organized.crime.lethality), "perfect.lethality",
                             ifelse(is.nan(organized.crime.lethality), "no.dead.wounded",
                                    ifelse(organized.crime.lethality == 0, "just.wounded",
                                           "dead.wounded"))),
           
           # global id indicator, since ID is only unique by data source
           global.id = 1:nrow(AllData)
    )



# :::::::::::::::::::::: SAVING PROCESSED FILE ::::::::::::::::::::::::::::::::

write_csv(AllData, outFileName1)

