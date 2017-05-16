###################################################
# Export the cleansed data source into csv
###################################################

setwd("E:/DAP/Assignment/Output")

write.csv(df, file = "df.csv")
write.csv(dfStateCode, file = "dfStateCode.csv")
write.csv(dfEthnicity, file = "dfEthnicity.csv")
write.csv(dfUnemployment, file = "dfUnemployment.csv")
write.csv(dfPoverty, file = "dfPoverty.csv")
write.csv(dfEconomy, file = "dfEconomy.csv")