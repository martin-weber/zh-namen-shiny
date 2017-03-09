#############################################################
# Data here in global.R is visible in both ui.R and server.R
#############################################################

library(dplyr)
library(stringr)

#############################################################
# Human names
#############################################################
humanNames <- read.csv("daten/bevbestvornamengjg.csv")

# change column names to uppercase
names(humanNames) <- Hmisc::capitalize(names(humanNames))

humanNames$Vorname = as.character(humanNames$Vorname)

# create an empty dataframe
emptyNames <- humanNames[humanNames$jahrgang < 0,]

minJahrgang <- min(humanNames$Jahrgang)
maxJahrgang <- max(humanNames$Jahrgang)

initialName <- humanNames[sample(nrow(humanNames), size = 1),"Vorname"]
print(initialName)
initialNameFragment <- substr(initialName, 1, max(3, nchar(initialName)/2))
print(initialNameFragment)

currentNames <- humanNames

#############################################################
# Dog names
#############################################################
dogNamesRaw <- read.csv("daten/20151001hundenamen.csv")

# aggregate
dogNames <- dogNamesRaw %>%
  rename(Vorname = HUNDENAME, 
         Jahrgang = GEBURTSJAHR_HUND,
         Geschlecht = GESCHLECHT_HUND) %>%
  group_by(Vorname, Jahrgang, Geschlecht) %>%
  summarise(Anzahl = n()) %>%
  as.data.frame()
  
levels(dogNames$Geschlecht) <- list("männlich" = "m", "weiblich" = "w")
