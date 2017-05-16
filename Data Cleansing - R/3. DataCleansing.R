
filepath <- "E:/DAP/Assignment/Table_4.csv"

###################################################
# Step 1: Import the data set "Table 4.csv"
###################################################

df <- read.csv(filepath, na.strings=c(""," ","NA"))

###################################################
# Step 2: Reconstruct the data frame with more
#         readable column name
###################################################

df <- data.frame(
  State = as.character(df[,1]),
  City = as.character(df[,2]),
  Year = df[,3],
  Population = df[,4],
  Violent.Crime = df[,5],
  Murder = df[,6],
  Rape.Revised = df[,7],
  Rape.Legacy = df[,8],
  Robbery = df[,9],
  Aggravated.Assault = df[,10],
  Property.Crime = df[,11],
  Burglary = df[,12],
  Larceny.Theft = df[,13],
  Motor.Vehicle.Theft = df[,14],
  Arson = df[,15]
)

####################################################
# Step 3: Fill up the missing value for State &
#         City with the immediate previous record's
#         value
####################################################

for (i in 1:nrow(df)) {
  
  #If State is "" then assign the State from previous row
  if (is.na(df[i,'State'])) {df[i,'State'] <- df[i-1,'State']}
  
  #If City is "" then assign the City from previous row
  if (is.na(df[i,'City'])) {df[i,'City'] <- df[i-1,'City']}
  
}

####################################################
# Step 4: Remove the footnote reference number that
#         remains in the variable of State & City
####################################################

df$State <- gsub("[0-9]","",df$State)
df$City <- gsub("[0-9]","",df$City)


####################################################
# Step 5: Loop through the column from index 3 to 15
#         (Year to Arson) and convert them into 
#         numeric data type
####################################################

df <- fConvertDFVariabletoNumeric(df, 3:15)

####################################################
# Step 6: Convert the column with indices 4,7,8 
#         (Population, Rape.Revised & Rape.Legacy) 
#         into 0
####################################################

#Convert all NA in Population, Rape.Revised & Rape.Legacy into 0

df[, c(4,7,8)][is.na(df[, c(4,7,8)])] <- 0


####################################################
# Step 7: Fill up the missing 2015 population by 
#         applying a mean growth value against the 
#         reported 2014 population.
####################################################

# Create a new data set from 'Table 4.csv' with only the population data for 2014
dfPopulation2014 <- fCreateDFPopulation(filepath, 2014)

# Merge the dfPopulation2015 and dfPopulatio2014 data frame to create a 

dfPopulation <- merge(dfPopulation2014[, c(1,2,4)], 
                      dfPopulation2015[, c(1,2,4)], 
                      by.x = c('State','City'), 
                      by.y = c('State','City'), 
                      all.x=TRUE)

#Update the missing population with the mean of the growth
dfPopulation[is.na(dfPopulation$Population.y),4] <- 
  round(dfPopulation[is.na(dfPopulation$Population.y),3] *
          mean(dfPopulation$Population.y / dfPopulation$Population.x, na.rm=TRUE), 0)

#Update the population for 2015 from dfPopulation
df[df$Year==2015,]$Population <- dfPopulation$Population.y

rm(dfPopulation2014)
rm(dfPopulation2015)
rm(dfPopulation)
rm(i)

####################################################
# Step 8: Replace the missing values for Violent
#         Crime with increasse of 1.7%
####################################################

df[df$Year==2014 & is.na(df$Murder), 6] <- fUpdate2014ValueByPerc(df, 6, 1.7)
df[df$Year==2014 & is.na(df$Robbery), 9] <- fUpdate2014ValueByPerc(df, 9, 1.7)
df[df$Year==2014 & is.na(df$Aggravated.Assault), 10] <- fUpdate2014ValueByPerc(df, 10, 1.7)

####################################################
# Step 9: Replace the missing values for property
#         Crime with decrease of 4.2%
####################################################

df[df$Year==2014 & is.na(df$Burglary), 12] <- fUpdate2014ValueByPerc(df, 12, -4.2)
df[df$Year==2015 & is.na(df$Burglary), 12] <- fUpdate2015ValueByPerc(df, 12, -4.2)
df[df$Year==2014 & is.na(df$Larceny.Theft), 13] <- fUpdate2014ValueByPerc(df, 13, -4.2)
df[df$Year==2014 & is.na(df$Motor.Vehicle.Theft), 14] <- fUpdate2014ValueByPerc(df, 14, -4.2)
df[df$Year==2015 & is.na(df$Motor.Vehicle.Theft), 14] <- fUpdate2015ValueByPerc(df, 14, -4.2)

####################################################
# Step 10: Replace the missing values for arson
#          with decrease of 5.4%
####################################################

df[df$Year==2014 & is.na(df$Arson), 15] <- fUpdate2014ValueByPerc(df, 15, -5.4)
df[df$Year==2015 & is.na(df$Arson), 15] <- fUpdate2015ValueByPerc(df, 15, -5.4)

# For the remaining NA arson, update with meaan from all states
df[, 15][is.na(df[, 15])] <- round(mean(df[,15], na.rm = TRUE))


####################################################
# Step 11: Recalculate the Violent Crime & Property
#          Crime for cities that has NA for the 
#          variables
####################################################

df[is.na(df$Violent.Crime), 5] <- rowSums(df[is.na(df$Violent.Crime), c(6,7,8,9,10)])
df[is.na(df$Property.Crime), 11] <- rowSums(df[is.na(df$Property.Crime), c(12,13,14)])

####################################################
# Step 12: Check if any of the variables still 
#          contains NA value
####################################################

fil <- is.na(df$State) | is.na(df$City) | is.na(df$Year) | is.na(df$Violent.Crime) | 
  is.na(df$Murder) |   is.na(df$Rape.Revised) | is.na(df$Rape.Legacy) | is.na(df$Robbery) | 
  is.na(df$Aggravated.Assault) | is.na(df$Property.Crime) | is.na(df$Burglary) | 
  is.na(df$Larceny.Theft) | is.na(df$Motor.Vehicle.Theft) | is.na(df$Arson)

df[fil,]

rm(fil)
rm(filepath)

