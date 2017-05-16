#############################################################################################
# This function is designed around the data set obtained from FBI UCR, particularly Table 4 
# Sample code to execute the function:
#      dfPopulation2014 <- fCreateDFPopulation("E:/DAP/Table_4.csv", 2014)
############################################################################################# 

fCreateDFPopulation <- function(FileName, Year){

  df <- read.csv(FileName, na.strings=c(""," ","NA"))

  #Reconstruct the dataframe
  df <- data.frame(
    State = as.character(df[,1]), #State
    City = as.character(df[,2]), #City
    Year = as.numeric(gsub(",", "", df[,3])), #Year - Replace "," with "" before converting to numeric
    Population = as.numeric(gsub(",", "", df[,4])) #Population - Replace "," with "" before converting to numeric
  ) 
  
  #Subset the dataframe 
  df <- df[df$Year==Year,]
  
  #Fill up empty State & City
  for (i in 1:nrow(df)) {
    
    #If State is "" then assign the State from previous row
    if (is.na(df[i,'State'])) {df[i,'State'] <- df[i-1,'State']}
    
    #If City is "" then assign the City from previous row
    if (is.na(df[i,'City'])) {df[i,'City'] <- df[i-1,'City']}
    
  }
  rm(i)
  
  #Remove the footnote number from State & City
  df$State <- gsub("[0-9]","",df$State)
  df$City <- gsub("[0-9]","",df$City)
  
  return(df)
}

#############################################################################################
# This function convert the column with the index supplied in the paramater into numeric
# Sample code to execute the function:
#      str(fConvertDFVariabletoNumeric(dfEthnicity, 2:18))
############################################################################################# 

fConvertDFVariabletoNumeric <- function(Data, Column){
  df <- Data
  for (i in Column) {
    df[,i] <- as.numeric(gsub(",", "", df[,i])) 
  }
  return(df)
}

#############################################################################################
# This functions calculate the valaue based on the input parameter 'Perc', which is use to
# calculate the variation between 2014 & 2015
# Sample code to execute the function:
#      fUpdate2014ValueByPerc(df, 6, 1.7)
############################################################################################# 

fUpdate2014ValueByPerc <- function(Data, Column, Perc){
  df <- Data
  df2 <- merge(df[is.na(df[,Column]) & df$Year == 2014,],
               df[df$Year == 2015,],
               by.x = c('State','City'),
               by.y = c('State','City'),
               all.x=TRUE,
               suffixes=c("14","15"))

  return(round(df2[,Column + 13] * 100 / (100 + Perc))  )
}

fUpdate2015ValueByPerc <- function(Data, Column, Perc){
  df <- Data
  df2 <- merge(df[is.na(df[,Column]) & df$Year == 2015,],
               df[df$Year == 2014,],
               by.x = c('State','City'),
               by.y = c('State','City'),
               all.x=TRUE,
               suffixes=c("15","14"))
  
  return(round(df2[,Column + 13] * (100 + (Perc))/100))
}
