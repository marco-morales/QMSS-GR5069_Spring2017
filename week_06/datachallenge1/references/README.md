
# Data dictionary

The dataset `AllViolenceData_170216.csv` cointans information on **Confrontations** and **Aggressions** between armed forces and criminal organizations between December 2006 and November 2011 in Mexico. The data is a transformation of datasets released by the [Drug Policy Program (PPD)](http://www.politicadedrogas.org/) and is preserved at the  event level. 


## Definition

The original government definition - to which PDD subscribes - defines **Confrontations** as sporadic and isolated acts of violence, crimes or other affrays carried out by organized crime involving firearmas and military-grade equipment. In particular, a **Confrontation** must involve 

* at least three (3) organized crime members, or less if using military-grade equipment and explosives  
* violent resistance to armes forces and other government authorities
* a response to an "aggression" where fire is exchanged
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

<!-- ADD DEFINITION FOR AGGRESIONS -->

## Raw data

The original Confrontations dataset was downloaded from the 
[Drug Policy Program (PPD)](http://www.politicadedrogas.org/) site on `2/9/2017 at 19:23 hrs (EST)` from 
http://www.data-ppd.net/PPD/documentos/CIDE-PPD/Zip/A-E.zip and the original Aggressions data on `2/16/2017 at 7:23 hrs (EST)` from 
http://www.data-ppd.net/PPD/documentos/CIDE-PPD/Zip/A-A.zip 

Additional inputs: 
* a conversion table for State and Municipality names, was obtained from Mexico's [National Institute for Statistics and Geography (INEGI)](http://www.inegi.org.mx/)
* a conversion table for armed forces names that was manually transcribed from PDD's documentation 

The dataset was manipulated using the script `Gather_ViolenceData_170216.R`

## Variables 

The manipulated dataset `AllViolenceData_170216.csv` contains the following variables:

Variable |  description 
--- | --- 
`event.id` | original unique id for every "event" on each database
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
`afi` | binary indicator for participation of AFI
`army` | binary indicator for participation of the Army
`federal.police` | binary indicator for participation of the FederalPolice
`ministerial.police` | binary indicator for participation of Ministerial Police
`municipal.police` | binary indicator for participation of Municipal Police
`navy` | binary indicator for participation of the Navy  
`other` | binary indicator for participation of other armed forces or government entities
`state.police` | binary indicator for participation of State Police
`source` | string indicating whether event was on Confrontations or Aggresions database 
`organized.crime.lethality` | event-level lethality index for organized crime 
`army.lethality` | event-level lethality index for Army    
`navy.lethality` | event-level lethality index for Navy
`federal.police.lethality` | event-level lethality index for Federal Police 
`organized.crime.lethality.diff` | event-level difference between dead and wounded for organized crime 
`army.lethality.diff` | event-level difference between dead and wounded for Army
`navy.lethality.diff` | event-level difference between dead and wounded for Navy 
`federal.police.lethality.diff` | event-level difference between dead and wounded for Federal Police 
`organized.crime.NewIndex` | event-level new dead to wounded index for organized crime 
`army.NewIndex` | event-level new dead to wounded index for Army 
`navy.NewIndex` | event-level new dead to wounded index for Navy    
`federal.police.NewIndex` | event-level new dead to wounded index for Federal Police 
`perfect.lethality` | binay indicator for events of perfect lethality    
`category` | categorical variable indicating type of event {perfect.lethality, no.dead.wounded, dead.wounded, just.wounded}          
`global.id` | a unique ID for every event in the full data set   


## Summary statistics for the dataset

```
    event.id    unix.timestamp           date              state_code      state          
 Min.   :   1   Min.   :1.165e+09   Min.   :2006-12-02   Min.   : 1.0   Length:5396       
 1st Qu.: 675   1st Qu.:1.261e+09   1st Qu.:2009-12-15   1st Qu.:11.0   Class :character  
 Median :1350   Median :1.286e+09   Median :2010-09-30   Median :19.0   Mode  :character  
 Mean   :1589   Mean   :1.278e+09   Mean   :2010-07-02   Mean   :18.1                     
 3rd Qu.:2486   3rd Qu.:1.305e+09   3rd Qu.:2011-05-05   3rd Qu.:27.0                     
 Max.   :3835   Max.   :1.322e+09   Max.   :2011-11-27   Max.   :32.0                     
                                                                                          
  state.abbr           mun_code      municipality          detained      total.people.dead
 Length:5396        Min.   :  0.00   Length:5396        Min.   : 0.000   Min.   : 0.000   
 Class :character   1st Qu.: 12.00   Class :character   1st Qu.: 0.000   1st Qu.: 0.000   
 Mode  :character   Median : 28.00   Mode  :character   Median : 0.000   Median : 0.000   
                    Mean   : 35.62                      Mean   : 1.041   Mean   : 1.178   
                    3rd Qu.: 39.00                      3rd Qu.: 1.000   3rd Qu.: 2.000   
                    Max.   :551.00                      Max.   :40.000   Max.   :52.000   
                                                                                          
 military.dead      navy.dead        federal.police.dead    afi.dead       state.police.dead 
 Min.   :0.0000   Min.   :0.000000   Min.   : 0.00000    Min.   :0.00000   Min.   : 0.00000  
 1st Qu.:0.0000   1st Qu.:0.000000   1st Qu.: 0.00000    1st Qu.:0.00000   1st Qu.: 0.00000  
 Median :0.0000   Median :0.000000   Median : 0.00000    Median :0.00000   Median : 0.00000  
 Mean   :0.0252   Mean   :0.004077   Mean   : 0.02687    Mean   :0.00556   Mean   : 0.03595  
 3rd Qu.:0.0000   3rd Qu.:0.000000   3rd Qu.: 0.00000    3rd Qu.:0.00000   3rd Qu.: 0.00000  
 Max.   :6.0000   Max.   :3.000000   Max.   :12.00000    Max.   :6.00000   Max.   :12.00000  
                                                                                             
 ministerial.police.dead municipal.police.dead public.prosecutor.dead organized.crime.dead
 Min.   :0.00000         Min.   :0.00000       Min.   :0.0000000      Min.   : 0.0000     
 1st Qu.:0.00000         1st Qu.:0.00000       1st Qu.:0.0000000      1st Qu.: 0.0000     
 Median :0.00000         Median :0.00000       Median :0.0000000      Median : 0.0000     
 Mean   :0.03299         Mean   :0.09859       Mean   :0.0009266      Mean   : 0.8523     
 3rd Qu.:0.00000         3rd Qu.:0.00000       3rd Qu.:0.0000000      3rd Qu.: 1.0000     
 Max.   :8.00000         Max.   :7.00000       Max.   :1.0000000      Max.   :29.0000     
                                                                                          
 civilian.dead      total.people.wounded military.wounded  navy.wounded     federal.police.wounded
 Min.   : 0.00000   Min.   : 0.0000      Min.   :0.0000   Min.   :0.00000   Min.   : 0.00000      
 1st Qu.: 0.00000   1st Qu.: 0.0000      1st Qu.:0.0000   1st Qu.:0.00000   1st Qu.: 0.00000      
 Median : 0.00000   Median : 0.0000      Median :0.0000   Median :0.00000   Median : 0.00000      
 Mean   : 0.09563   Mean   : 0.9392      Mean   :0.1292   Mean   :0.01279   Mean   : 0.08358      
 3rd Qu.: 0.00000   3rd Qu.: 1.0000      3rd Qu.:0.0000   3rd Qu.:0.00000   3rd Qu.: 0.00000      
 Max.   :52.00000   Max.   :30.0000      Max.   :9.0000   Max.   :9.00000   Max.   :16.00000      
                                                                                                  
  afi.wounded       state.police.wounded ministerial.police.wounded municipal.police.wounded
 Min.   : 0.00000   Min.   :0.00000      Min.   : 0.00000           Min.   :0.0000          
 1st Qu.: 0.00000   1st Qu.:0.00000      1st Qu.: 0.00000           1st Qu.:0.0000          
 Median : 0.00000   Median :0.00000      Median : 0.00000           Median :0.0000          
 Mean   : 0.01019   Mean   :0.05893      Mean   : 0.05411           Mean   :0.1483          
 3rd Qu.: 0.00000   3rd Qu.:0.00000      3rd Qu.: 0.00000           3rd Qu.:0.0000          
 Max.   :15.00000   Max.   :8.00000      Max.   :17.00000           Max.   :9.0000          
                                                                                            
 public.prosecutor.wounded organized.crime.wounded civilian.wounded  long.guns.seized 
 Min.   :0.000000          Min.   : 0.000          Min.   : 0.0000   Min.   :  0.000  
 1st Qu.:0.000000          1st Qu.: 0.000          1st Qu.: 0.0000   1st Qu.:  0.000  
 Median :0.000000          Median : 0.000          Median : 0.0000   Median :  0.000  
 Mean   :0.001297          Mean   : 0.283          Mean   : 0.1614   Mean   :  1.669  
 3rd Qu.:0.000000          3rd Qu.: 0.000          3rd Qu.: 0.0000   3rd Qu.:  2.000  
 Max.   :2.000000          Max.   :30.000          Max.   :27.0000   Max.   :144.000  
                                                                                      
 small.arms.seized cartridge.sezied   clips.seized     vehicles.seized         afi          
 Min.   : 0.0000   Min.   :    0.0   Min.   :   0.00   Min.   :  0.0000   Min.   :0.000000  
 1st Qu.: 0.0000   1st Qu.:    0.0   1st Qu.:   0.00   1st Qu.:  0.0000   1st Qu.:0.000000  
 Median : 0.0000   Median :    0.0   Median :   0.00   Median :  0.0000   Median :0.000000  
 Mean   : 0.5019   Mean   :  273.8   Mean   :  11.67   Mean   :  0.9861   Mean   :0.003151  
 3rd Qu.: 0.0000   3rd Qu.:    0.0   3rd Qu.:   1.00   3rd Qu.:  1.0000   3rd Qu.:0.000000  
 Max.   :34.0000   Max.   :86365.0   Max.   :4000.00   Max.   :354.0000   Max.   :1.000000  
                                                                                            
      army        federal.police   ministerial.police municipal.police      navy        
 Min.   :0.0000   Min.   :0.0000   Min.   :0.00000    Min.   :0.0000   Min.   :0.00000  
 1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.00000    1st Qu.:0.0000   1st Qu.:0.00000  
 Median :0.0000   Median :0.0000   Median :0.00000    Median :0.0000   Median :0.00000  
 Mean   :0.3436   Mean   :0.1105   Mean   :0.07895    Mean   :0.2298   Mean   :0.03039  
 3rd Qu.:1.0000   3rd Qu.:0.0000   3rd Qu.:0.00000    3rd Qu.:0.0000   3rd Qu.:0.00000  
 Max.   :1.0000   Max.   :1.0000   Max.   :1.00000    Max.   :1.0000   Max.   :1.00000  
                                                                                        
     other         state.police        source          organized.crime.lethality army.lethality 
 Min.   :0.0000   Min.   :0.00000   Length:5396        Min.   :  0               Min.   :0.000  
 1st Qu.:0.0000   1st Qu.:0.00000   Class :character   1st Qu.:  1               1st Qu.:0.000  
 Median :0.0000   Median :0.00000   Mode  :character   Median :Inf               Median :0.000  
 Mean   :0.0341   Mean   :0.08432                      Mean   :Inf               Mean   :  Inf  
 3rd Qu.:0.0000   3rd Qu.:0.00000                      3rd Qu.:Inf               3rd Qu.:0.143  
 Max.   :1.0000   Max.   :1.00000                      Max.   :Inf               Max.   :  Inf  
                                                       NA's   :3090              NA's   :5011   
 navy.lethality federal.police.lethality organized.crime.lethality.diff army.lethality.diff
 Min.   :  0    Min.   :  0              Min.   :-18.0000               Min.   :-8.000     
 1st Qu.:  0    1st Qu.:  0              1st Qu.:  0.0000               1st Qu.: 0.000     
 Median :  0    Median :  0              Median :  0.0000               Median : 0.000     
 Mean   :Inf    Mean   :Inf              Mean   :  0.5693               Mean   :-0.104     
 3rd Qu.:Inf    3rd Qu.:  1              3rd Qu.:  1.0000               3rd Qu.: 0.000     
 Max.   :Inf    Max.   :Inf              Max.   : 28.0000               Max.   : 3.000     
 NA's   :5356   NA's   :5183                                                               
 navy.lethality.diff federal.police.lethality.diff organized.crime.NewIndex army.NewIndex   
 Min.   :-7.00000    Min.   :-14.00000             Min.   :-1.0000          Min.   :-1.000  
 1st Qu.: 0.00000    1st Qu.:  0.00000             1st Qu.: 0.0000          1st Qu.:-1.000  
 Median : 0.00000    Median :  0.00000             Median : 1.0000          Median :-1.000  
 Mean   :-0.00871    Mean   : -0.05671             Mean   : 0.4636          Mean   :-0.687  
 3rd Qu.: 0.00000    3rd Qu.:  0.00000             3rd Qu.: 1.0000          3rd Qu.:-0.750  
 Max.   : 3.00000    Max.   :  5.00000             Max.   : 1.0000          Max.   : 1.000  
                                                   NA's   :3090             NA's   :5011    
 navy.NewIndex    federal.police.NewIndex perfect.lethality   category           global.id   
 Min.   :-1.000   Min.   :-1.000          Min.   :0.0000    Length:5396        Min.   :   1  
 1st Qu.:-1.000   1st Qu.:-1.000          1st Qu.:0.0000    Class :character   1st Qu.:1350  
 Median :-1.000   Median :-1.000          Median :0.0000    Mode  :character   Median :2698  
 Mean   :-0.365   Mean   :-0.503          Mean   :0.2745                       Mean   :2698  
 3rd Qu.: 1.000   3rd Qu.: 0.000          3rd Qu.:1.0000                       3rd Qu.:4047  
 Max.   : 1.000   Max.   : 1.000          Max.   :1.0000                       Max.   :5396  
 NA's   :5356     NA's   :5183                                                               
```