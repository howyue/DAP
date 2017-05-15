%let path=/home/howyue0/DAP;
LIBNAME DAP "/home/howyue0/DAP";

*-------------------------------------------*
| Name:   Table4                            |
| Remark: To import the assignment s master |
|         data set - Table4                 |
*-------------------------------------------;
proc import datafile="&PATH/df.csv"
/* For df.csv, first PROC IMPORT follow by DATA, this way changing the data type is easier */
     out=DAP.Table4
     dbms=CSV
     replace;
     getnames=YES;
     guessingrows=32767; 
run;

data dap.table4;
/* Changing the imported variable from CHAR to NUMERIC, replaces NA to . */
	set dap.table4;
	Aggravated_Assault_2=input('Aggravated.Assault'N, 12.);
	Arson_2=input(Arson, 12.);
	Burglary_2=input(Burglary, 12.);
	Larceny_Theft_2=input('Larceny.Theft'N, 12.);
	Motor_Vehicle_Theft_2=input('Motor.Vehicle.Theft'N, 12.);
	Murder_2=input(Murder, 12.);
	Population_2=input(Population, 12.);
	Property_Crime_2=input('Property.Crime'N, 12.);
	Rape_Legacy_2=input('Rape.Legacy'N, 12.);
	Rape_Revised_2=input('Rape.Revised'N, 12.);
	Robbery_2=input(Robbery, 12.);
	Violent_Crime_2=input('Violent.Crime'N, 12.);
	Year_2=input(Year, 12.);
	
	rename Aggravated_Assault_2=Aggravated_Assault Arson_2=Arson 
		Burglary_2=Burglary Larceny_Theft_2=Larceny_Theft 
		Motor_Vehicle_Theft_2=Motor_Vehicle_Theft Murder_2=Murder 
		Population_2=Population Property_Crime_2=Property_Crime 
		Rape_Legacy_2=Rape_Legacy Rape_Revised_2=Rape_Revised Robbery_2=Robbery 
		Violent_Crime_2=Violent_Crime Year_2=Year;
		
	StateName=propcase(State);
	TotalCrime=Property_Crime_2+Violent_Crime_2;
	Rape=Rape_Legacy_2+Rape_Revised_2;
	
	drop Var1 State Year Population 'Violent.Crime'N Murder 'Rape.Revised'N 'Rape.Legacy'N
		Robbery 'Aggravated.Assault'N 'Property.Crime'N Burglary 'Larceny.Theft'N 
		'Motor.Vehicle.Theft'N Arson;
	
run;

*-------------------------------------------*
| Name:   State Code                        |
| Remark: State code is used to establish a |
|         foreign key with SAS built-in     |
|         library MAPS.US                   |
*-------------------------------------------;
data dap.State;
	infile "&PATH/dfStateCode.csv" dsd dlm="," firstobs=2;
	input var1 Code :$2. StateName :$50.;
	drop var1 var5;
run;

*-------------------------------------------*
| Name:   Economy                           |
| Remark: Supplementary used to identify    |
|         correlation with crime            |
*-------------------------------------------;
data dap.Economy;
	infile "&PATH/dfEconomy.csv" dsd dlm="," firstobs=2;
	input var1 StateName :$50. var3 :$50. var4 :$50. Value_1000;

	label var3='NAIC' var4='Type.of.Operation.Or.Status.Code' var5='Value.1000';

	*Combine var3 & var4;
	if var3='Wholesale trade' then
		NAIC=cat(strip(var3), ' - ', var4);
	else
		NAIC=strip(var3);
		
	drop var1 var3 var4;
run;

*-------------------------------------------*
| Name:   Ethnicity                         |
| Remark: Supplementary used to identify    |
|         correlation with crime            |
*-------------------------------------------;
data dap.Ethnicity;
	infile "&PATH/dfEthnicity.csv" dsd dlm="," firstobs=2;
	input var1 StateName :$50. var3 var4 var5 var6 var7 var8 var9 var10 var11 
		var12 var13 var14 var15 var16 var17 var18 var19;
	drop var1;
	label var3='Estimate; Total:' 
		var4='Estimate; Not Hispanic or Latino: - White alone' 
		var5='Estimate; Not Hispanic or Latino: - Black or African American alone' var6='Estimate; Not Hispanic or Latino: - American Indian and Alaska Native alone' 
		var7='Estimate; Not Hispanic or Latino: - Asian alone' var8='Estimate; Not Hispanic or Latino: - Native Hawaiian and Other Pacific Islander alone' 
		var9='Estimate; Not Hispanic or Latino: - Some other race alone' var10='Estimate; Not Hispanic or Latino: - Two or more races: - Two races including Some other race' var11='Estimate; Not Hispanic or Latino: - Two or more races: - Two races excluding Some other race, and three or more races' 
		var12='Estimate; Hispanic or Latino: - White alone' 
		var13='Estimate; Hispanic or Latino: - Black or African American alone' 
		var14='Estimate; Hispanic or Latino: - American Indian and Alaska Native alone' 
		var15='Estimate; Hispanic or Latino: - Asian alone' var16='Estimate; Hispanic or Latino: - Native Hawaiian and Other Pacific Islander alone' 
		var17='Estimate; Hispanic or Latino: - Some other race alone' var18='Estimate; Hispanic or Latino: - Two or more races: - Two races including Some other race' var19='Estimate; Hispanic or Latino: - Two or more races: - Two races excluding Some other race, and three or more races';
run;

*-------------------------------------------*
| Name:   Poverty                           |
| Remark: Supplementary used to identify    |
|         correlation with crime            |
*-------------------------------------------;
data dap.Poverty;
	infile "&PATH/dfPoverty.csv" dsd dlm="," firstobs=2;
	input var1 StateName :$50. var3 var4 var5;
	drop var1;
	label var2='StateName' 
		var3='Estimate; Total:' 
		var4='Estimate; Income in the past 12 months below poverty level:' 
		var5='Estimate; Income in the past 12 months at or above poverty level:';
run;

*-------------------------------------------*
| Name:   Unemployment                      |
| Remark: Supplementary used to identify    |
|         correlation with crime            |
*-------------------------------------------;
data dap.Unemployment;
	infile "&PATH/dfUnemployment.csv" dsd dlm="," firstobs=2;
	input var1 StateName :$50. var3 var4 var5 var6 var7 var8 var9 var10 var11 
		var12 var13 var14 var15 var16 var17 var18 var19 var20 var21 var22;
	drop var1;
	label var3='Unemployment rate; Estimate; Population 16 years and over' 
		var4='Unemployment rate; Estimate; AGE - 16 to 19 years' 
		var5='Unemployment rate; Estimate; AGE - 20 to 24 years' 
		var6='Unemployment rate; Estimate; AGE - 25 to 29 years' 
		var7='Unemployment rate; Estimate; AGE - 30 to 34 years' 
		var8='Unemployment rate; Estimate; AGE - 35 to 44 years' 
		var9='Unemployment rate; Estimate; AGE - 45 to 54 years' 
		var10='Unemployment rate; Estimate; AGE - 55 to 59 years' 
		var11='Unemployment rate; Estimate; AGE - 60 to 64 years' 
		var12='Unemployment rate; Estimate; AGE - 65 to 74 years' 
		var13='Unemployment rate; Estimate; AGE - 75 years and over' var13='Unemployment rate; Estimate; RACE AND HISPANIC OR LATINO ORIGIN - White alone' var14='Unemployment rate; Estimate; RACE AND HISPANIC OR LATINO ORIGIN - Black or African American alone' var15='Unemployment rate; Estimate; RACE AND HISPANIC OR LATINO ORIGIN - American Indian and Alaska Native alone' var16='Unemployment rate; Estimate; RACE AND HISPANIC OR LATINO ORIGIN - Asian alone' var17='Unemployment rate; Estimate; RACE AND HISPANIC OR LATINO ORIGIN - Native Hawaiian and Other Pacific Islander alone' var18='Unemployment rate; Estimate; RACE AND HISPANIC OR LATINO ORIGIN - Some other race alone' var19='Unemployment rate; Estimate; RACE AND HISPANIC OR LATINO ORIGIN - Two or more races' 
		var21='Unemployment rate; Estimate; Hispanic or Latino origin (of any race)' 
		var22='Unemployment rate; Estimate; White alone, not Hispanic or Latino';
run;
