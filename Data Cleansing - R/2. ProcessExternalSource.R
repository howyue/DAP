# The folder path where all the source files are being kept
folderpath <- 'E:/DAP/Assignment/External Source/'

# Concatenate the folderpath with the source csv file
SourceFile <- paste(folderpath, c("1. StateCode.csv", 
                                  '2. Population2015.csv', 
                                  '3. Ethnicity.csv', 
                                  '4. Unemployment.csv', 
                                  '5. Poverty.csv', 
                                  '6. EconomyByNAIC.csv')
                    , sep = ""
)

##########################
##### Prepare State ######
##########################

dfStateCode <- read.csv(SourceFile[1], sep="|")
dfStateCode <- data.frame(
  Code = dfStateCode$STUSAB,
  StateName = dfStateCode$STATE_NAME
)

####################################
##### Prepare Population 2015 ######
####################################

# Create a data set with the population for 2015, to be used to calculate the mean growth
dfPopulation2015 <- fCreateDFPopulation(SourceFile[2], 2015)

###############################
##### Prepare Ethnicity ######
###############################

dfEthnicity <- read.csv(SourceFile[3])

#Rename the columnn with the value from the 1st row
colnames(dfEthnicity) <- unlist(dfEthnicity[1,])

#Remove the 1st row which is the column name, keep only the columns needed with c(3, seq(4,45,2))
dfEthnicity <- dfEthnicity[-1,c(3, seq(4,45,2))]

#Further reduce the columns which are not needed
dfEthnicity <- dfEthnicity[,-c(3,10,13,20)]

#Convert the columns into numeric
dfEthnicity <- fConvertDFVariabletoNumeric(dfEthnicity, 2:18)

#Convert the columns into percentage
dfEthnicity[,-c(1,2)] <- dfEthnicity[,-c(1,2)] / dfEthnicity[,2] * 100

names(dfEthnicity)[1] <- 'StateName'

###################################
##### Prepare Unepmployment  ######
###################################

#Identify the columns required
colist <- c(16,24,32,40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160)

dfUnemployment <- read.csv(SourceFile[4])

#Rename the columnn with the value from the 1st row
colnames(dfUnemployment) <- unlist(dfUnemployment[1,])

#Remove the 1st row which is the column name, keep only the columns needed with c(3,colist + 2)
dfUnemployment <- dfUnemployment[-1,c(3,colist + 2)]

dfUnemployment <- fConvertDFVariabletoNumeric(dfUnemployment, 2:20)

names(dfUnemployment)[1] <- 'StateName'

rm(colist)

#############################
##### Prepare Poverty  ######
#############################

dfPoverty <- read.csv(SourceFile[5])

#Rename the columnn with the value from the 1st row
colnames(dfPoverty) <- unlist(dfPoverty[1,])

#Remove the 1st row which is the column name, keep only the columns needed with c(3,4,6,28)
dfPoverty <- dfPoverty[-1,c(3,4,6,28)]

dfPoverty <- fConvertDFVariabletoNumeric(dfPoverty, 2:4)

#Convert the columns into percentage
dfPoverty[,-c(1,2)] <- dfPoverty[,-c(1,2)] / dfPoverty[,2] * 100

names(dfPoverty)[1] <- 'StateName'

#####################################
##### Prepare Economy by NAIC  ######
#####################################

dfEconomy <- read.csv(SourceFile[6])

#Identify all the NAIC needed
fil <- dfEconomy$Meaning.of.2012.NAICS.code %in%  c(
  'Mining, quarrying, and oil and gas extraction',
  'Utilities',
  'Construction',
  'Wholesale trade',
  'Wholesale trade',
  'Wholesale trade',
  'Retail trade',
  'Transportation and warehousing (104)',
  'Information',
  'Finance and insurance',
  'Real estate and rental and leasing',
  'Professional, scientific, and technical services',
  'Management of companies and enterprises',
  'Administrative and support and waste management and remediation services',
  'Educational services',
  'Health care and social assistance',
  'Arts, entertainment, and recreation',
  'Accommodation and food services',
  'Other services (except public administration)'
) & dfEconomy$Meaning.of.Type.of.operation.or.tax.status.code %in%
  c('All establishments',
    'Total',
    'Wholesale Trade',
    'Merchant wholesalers, except manufacturers\' sales branches and offices',
    'Manufacturers\' sales branches and offices'
  )

# Filter the data frame to pick up only the data required for analysis
dfEconomy <- dfEconomy[fil,c(1,5,8,12)]

#Rename the column
colnames(dfEconomy) <- c('StateName','NAIC','Type.of.Operation.Or.Status.Code','Value.1000')

# Convert the Value.1000 column into numeric, but this will introduce NA as there are states with missing value, 
# either not reported or do not conduct the economy activities
dfEconomy <- fConvertDFVariabletoNumeric(dfEconomy, 4)

rm(fil)

#######################################################
##### Remove the folderpath & Sourcefile vector  ######
#######################################################

rm(folderpath)
rm(SourceFile)
