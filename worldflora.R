#World Flora Installation/tests
#Bailie Wynbelt
#02/01/2023

#Install R Commander
#R Commander provides menu of analytic and graphical methods.
#Displays underlying R code that runs each analysis
install.packages("Rcmdr", dependencies=TRUE)

#Launch R commander - R Commander window pops-up
library(Rcmdr)

#Install and load WorldFlora package
install.packages("RcmdrPlugin.WorldFlora", dependencies=TRUE)
library(RcmdrPlugin.WorldFlora)

#Change working directory to WorldFlora folder
setwd("C:/Users/wynbe/Desktop/work_ellen/WorldFlora")

#Download data from website

#Read in the data, separate by tabs

library(readr)
WFO_data <- read_delim("WFO_Backbone/WFO.data.csv", 
                       delim = "\t", 
                       escape_double = FALSE, 
                       trim_ws = TRUE)
View(WFO_data)

#Remember the location of the WFO data
WFO.remember(file.choose("C:/Users/wynbe/Desktop/work_ellen/WorldFlora/WFO_Backbone/WFO.data.csv"))

#Read test data
test_plants <- readXL("C:/Users/wynbe/Desktop/work_ellen/WorldFlora/data/wf_plant_test.xlsx",
                      rownames = FALSE, header = TRUE, na = "", sheet = "wf_plant_test",
                      stringsAsFactors = FALSE)

#Prepare the data set - would use if dataset had Authorship, WorldFlora cannot distinguish

#Check for matching names
#Matches uploaded data frame with WFO.data to check species names
test_plants.match <- WFO.match(spec.data = test_plants, 
                               WFO.data = WFO.data,
                               spec.name = 'sci_name_profID', 
                               Authorship = '', 
                               First.dist = TRUE, 
                               Fuzzy.min = TRUE, 
                               Fuzzy = 0.1, 
                               Fuzzy.max = 250, 
                               Fuzzy.two = TRUE, 
                               Fuzzy.one = TRUE, 
                               squish = TRUE, 
                               spec.name.tolower = FALSE, 
                               spec.name.nonumber = TRUE, 
                               spec.name.nobrackets = TRUE, 
                               exclude.infraspecific = FALSE, 
                               verbose = TRUE, 
                               counter = 1000)

#Prepare data for WFO.one():
install.packages("writexl")
library(writexl)

write_xlsx(test_plants.match,
           "C:\\Users\\wynbe\\Desktop\\work_ellen\\WorldFlora\\data\\test_plants_match.xlsx")

test_plants_match <- 
  readXL("C:/Users/wynbe/Desktop/work_ellen/WorldFlora/data/test_plants_match.xlsx",
         rownames=FALSE, header=TRUE, na="", 
         sheet="Sheet1", stringsAsFactors=FALSE)

#Check for the best single match
#WFO.one reduces the number of matches to one for each submitted plant name
test_plants_match.one <- WFO.one(test_plants_match, 
                    priority='Accepted', 
                    spec.name='sci_name_profID', 
                    Auth.dist='', 
                    First.dist='First.dist', 
                    verbose=TRUE, 
                    counter=1000)

#Select plants that had fuzzy values
library(tidyverse)
fuzzy_plants <- test_plants_match.one %>% 
  filter(Fuzzy == 'TRUE')

#Select needed columns AND finalize
fuzzy_plants_updated <- fuzzy_plants %>% 
  select(sci_name_profID, 
         taxonID,
         Fuzzy, 
         scientificName, 
         family, 
         genus,
         specificEpithet,
         taxonomicStatus,
         New.accepted,
         Old.name)

#test test

