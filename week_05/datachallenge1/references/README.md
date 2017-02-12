
# Data dictionary

The dataset `ConfrontationsData_170209.csv` cointans information on **Confrontations** between Mexican armed forces and criminal organizations between December 2006 and November 2011 in Mexico. The data is a transformation of the dataset released by the [Drug Policy Program (PPD)](http://www.politicadedrogas.org/) and is preserved at the  event level. 


## Definition

The original government definition - to which PDD subscribes - defines **Confrontations** as sporadic and isolated acts of violence, crimes or other affrays carried out by organized crime involving firearmas and military-grade equipment. In particular, a **Confrontation** must involve 

* at least three (3) organized crime members, or less if using military-grade equipment and explosives  
* violent resistance to armes forces and other government authorities
* a response to an "aggression" wehere fire is exchanged
* events where criminals cannot be subdued on a single tactical manouver
* extraordinarily, skirmishes within penitentiaries involving organized crime


As defined above, Confrontations can take place:

1. Against (federal, state, municipal) government authorities
  * during an operation aiming to combat organized crime
  * during routine activities where a crime is being committed
  * during operations prompted by civilian denounciations

2. Between or within criminal organizations:
  * skirmishes with rival organizations
  * skirmishes happening in "known" territories of a criminal organizaton
  * disciplinary acts within an organization


## Raw data

The original Confrontations dataset was downloaded from the 
[Drug Policy Program (PPD)](http://www.politicadedrogas.org/) site on 2/9/2017 at 19:23 hrs (EST) from 
http://www.data-ppd.net/PPD/documentos/CIDE-PPD/Zip/A-E.zip

An additional input is a conversion table for State and Municipality names, was obtained from Mexico's [National Institute for Statistics and Geography (INEGI)](http://www.inegi.org.mx/). 

The dataset was manipulated using the script `Gather_ConfrontationsData_170209.R`

## Variables 

The manipulated dataset `ConfrontationsData_170209.csv` contains the following variables:

Variable |  description 
--- | --- 
`event.id` | a unique id for every "event" in the database
`unix.timestamp` | UNIX (numeric) timestamp  
`date` | date when the "event" took place 
`state_code` | a unique numeric code per state as defined by INEGI 
`state`      | full state name as defined by INEGI
`state.abbr` | state name abbreviation as defined by INEGI 
`mun_code`  | a unique numeric code per municipality as defined by INEGI
`municipality` | full municipality name as defined by INEGI
`detained` | number of people detained in the event
`total.people.dead` | number of people killed in the event
`military.dead` | number Army personnel killed in the event
`navy.dead` | number Navy personnel killed in the event
`federal.police.dead` | number Federal Police personnel killed in the event
`afi.dead` | number AFI (Federal Investigation Agency) personnel killed in the event
`state.police.dead` | number state police personnel killed in the event
`ministerial.police.dead` | number ministerial police personnel killed in the event
`municipal.police.dead` | number municipal police personnel killed in the event
`public.prosecutor.dead` | number public prosecutors killed in the event
`organized.crime.dead` | number alleged criminals  killed in the event
`civilian.dead` | number civilians killed in the event
`total.people.wounded` | number of people wounded in the event
`military.wounded` | number of Army personnel wounded in the event
`navy.wounded` | number of Navy personnel wounded in the event
`federal.police.wounded` | number of Federal Police personnel wounded in the event
`afi.wounded` | number of AFI personnel wounded in the event
`state.police.wounded` | number of state police personnel wounded in the event
`ministerial.police.wounded` | number of ministerial police personnel wounded in the event
`municipal.police.wounded` | number of municipal police personnel wounded in the event
`public.prosecutor.wounded` | number of public prosecutors wounded in the event
`organized.crime.wounded` | number of alleged criminals wounded in the event
`civilian.wounded` | number of civilians wounded in the event
`long.guns.seized` | number of long guns seized in the event
`small.arms.seized` | number of small arms seized in the event
`cartridge.sezied` | number of cartridged seized in the event
`clips.seized` | number of clips seized in the event
`vehicles.seized` | number vehicles seized in the event


## Summary statistics for the dataset

```
    event.id      unix.timestamp           date              state_code       state          
 Min.   :   1.0   Min.   :1.169e+09   Min.   :2007-01-16   Min.   : 1.00   Length:3835       
 1st Qu.: 959.5   1st Qu.:1.255e+09   1st Qu.:2009-10-12   1st Qu.:12.00   Class :character  
 Median :1918.0   Median :1.285e+09   Median :2010-09-20   Median :19.00   Mode  :character  
 Mean   :1918.0   Mean   :1.276e+09   Mean   :2010-06-09   Mean   :18.95                     
 3rd Qu.:2876.5   3rd Qu.:1.304e+09   3rd Qu.:2011-05-03   3rd Qu.:28.00                     
 Max.   :3835.0   Max.   :1.322e+09   Max.   :2011-11-27   Max.   :32.00                     
 
  state.abbr           mun_code      municipality          detained      total.people.dead
 Length:3835        Min.   :  0.00   Length:3835        Min.   : 0.000   Min.   : 0.000   
 Class :character   1st Qu.: 13.00   Class :character   1st Qu.: 0.000   1st Qu.: 0.000   
 Mode  :character   Median : 27.00   Mode  :character   Median : 0.000   Median : 1.000   
                    Mean   : 35.29                      Mean   : 1.344   Mean   : 1.417   
                    3rd Qu.: 39.00                      3rd Qu.: 2.000   3rd Qu.: 2.000   
                    Max.   :469.00                      Max.   :40.000   Max.   :29.000   
 
 military.dead       navy.dead        federal.police.dead    afi.dead        state.police.dead
 Min.   :0.00000   Min.   :0.000000   Min.   :0.00000     Min.   :0.000000   Min.   :0.00000  
 1st Qu.:0.00000   1st Qu.:0.000000   1st Qu.:0.00000     1st Qu.:0.000000   1st Qu.:0.00000  
 Median :0.00000   Median :0.000000   Median :0.00000     Median :0.000000   Median :0.00000  
 Mean   :0.02973   Mean   :0.004954   Mean   :0.02112     Mean   :0.003911   Mean   :0.02086  
 3rd Qu.:0.00000   3rd Qu.:0.000000   3rd Qu.:0.00000     3rd Qu.:0.000000   3rd Qu.:0.00000  
 Max.   :6.00000   Max.   :3.000000   Max.   :8.00000     Max.   :6.000000   Max.   :6.00000  
 
 ministerial.police.dead municipal.police.dead public.prosecutor.dead organized.crime.dead
 Min.   :0.00000         Min.   :0.00000       Min.   :0              Min.   : 0.000      
 1st Qu.:0.00000         1st Qu.:0.00000       1st Qu.:0              1st Qu.: 0.000      
 Median :0.00000         Median :0.00000       Median :0              Median : 0.000      
 Mean   :0.01956         Mean   :0.03651       Mean   :0              Mean   : 1.183      
 3rd Qu.:0.00000         3rd Qu.:0.00000       3rd Qu.:0              3rd Qu.: 2.000      
 Max.   :7.00000         Max.   :7.00000       Max.   :0              Max.   :29.000      
 
 civilian.dead      total.people.wounded military.wounded  navy.wounded     federal.police.wounded
 Min.   : 0.00000   Min.   : 0.0000      Min.   :0.0000   Min.   :0.00000   Min.   : 0.00000      
 1st Qu.: 0.00000   1st Qu.: 0.0000      1st Qu.:0.0000   1st Qu.:0.00000   1st Qu.: 0.00000      
 Median : 0.00000   Median : 0.0000      Median :0.0000   Median :0.00000   Median : 0.00000      
 Mean   : 0.09804   Mean   : 0.9854      Mean   :0.1666   Mean   :0.01617   Mean   : 0.06962      
 3rd Qu.: 0.00000   3rd Qu.: 1.0000      3rd Qu.:0.0000   3rd Qu.:0.00000   3rd Qu.: 0.00000      
 Max.   :10.00000   Max.   :30.0000      Max.   :9.0000   Max.   :9.00000   Max.   :16.00000      
 
  afi.wounded        state.police.wounded ministerial.police.wounded municipal.police.wounded
 Min.   : 0.000000   Min.   :0.00000      Min.   :0.00000            Min.   :0.0000          
 1st Qu.: 0.000000   1st Qu.:0.00000      1st Qu.:0.00000            1st Qu.:0.0000          
 Median : 0.000000   Median :0.00000      Median :0.00000            Median :0.0000          
 Mean   : 0.008866   Mean   :0.04511      Mean   :0.04329            Mean   :0.0837          
 3rd Qu.: 0.000000   3rd Qu.:0.00000      3rd Qu.:0.00000            3rd Qu.:0.0000          
 Max.   :15.000000   Max.   :8.00000      Max.   :7.00000            Max.   :8.0000          
 
 public.prosecutor.wounded organized.crime.wounded civilian.wounded  long.guns.seized 
 Min.   :0.000000          Min.   : 0.0000         Min.   : 0.0000   Min.   :  0.000  
 1st Qu.:0.000000          1st Qu.: 0.0000         1st Qu.: 0.0000   1st Qu.:  0.000  
 Median :0.000000          Median : 0.0000         Median : 0.0000   Median :  0.000  
 Mean   :0.001043          Mean   : 0.3841         Mean   : 0.1703   Mean   :  2.288  
 3rd Qu.:0.000000          3rd Qu.: 0.0000         3rd Qu.: 0.0000   3rd Qu.:  3.000  
 Max.   :2.000000          Max.   :30.0000         Max.   :27.0000   Max.   :144.000  
 
 small.arms.seized cartridge.sezied   clips.seized     vehicles.seized  
 Min.   : 0.0000   Min.   :    0.0   Min.   :   0.00   Min.   :  0.000  
 1st Qu.: 0.0000   1st Qu.:    0.0   1st Qu.:   0.00   1st Qu.:  0.000  
 Median : 0.0000   Median :    0.0   Median :   0.00   Median :  0.000  
 Mean   : 0.6694   Mean   :  373.5   Mean   :  16.19   Mean   :  1.337  
 3rd Qu.: 1.0000   3rd Qu.:   55.0   3rd Qu.:   6.00   3rd Qu.:  1.000  
 Max.   :34.0000   Max.   :86365.0   Max.   :4000.00   Max.   :354.000  
```