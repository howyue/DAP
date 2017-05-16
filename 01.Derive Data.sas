/* Sort table4 by StateName City Year, this sorted data set will be used in deriving
   MasterByCity and MasterByState */
proc sort data=dap.table4 out=work.table4;
	by StateName City Year;
run;

*-------------------------------------------*
| Name:   MasterByCity                      |
|         tranbosed version of Table4       |
*-------------------------------------------;
proc transpose data=work.table4 
	out=work.tmpMasterByCity(RENAME=(_NAME_=CrimeType 
		'2014'n=Total2014 '2015'n=Total2015));
	id Year;
	var Aggravated_Assault Arson Burglary Larceny_Theft 
		Motor_Vehicle_Theft Murder Property_Crime Rape Robbery 
		Violent_Crime TotalCrime Population;
	by StateName City;
run;

data work.tmpMasterByCityPopulation;
	set work.tmpMasterByCity;
	Population2014=Total2014;
	Population2015=Total2015;
	/* Keep only population so when this join to tmpMasterByCity it is 1 to 1 relationship */
	if CrimeType ^="Population" then DELETE;
run;
 
proc sql;
	CREATE TABLE work.MasterByCity AS
		SELECT a.*, 
			b.Total2014 AS Population2014, 
			b.Total2015 AS Population2015
		FROM work.tmpMasterByCity a
		LEFT JOIN work.tmpMasterByCityPopulation b
			ON b.StateName = a.StateName
			AND b.City = a.City;
run;
 
data work.MasterByCity;
	set work.MasterByCity;
	CrimeRate2014=Total2014 / Population2014 * 100000;
	CrimeRate2015=Total2015 / Population2015 * 100000;
	CrimeRateChange=(CrimeRate2015-CrimeRate2014)/CrimeRate2014*100;
	format Total2014 comma10.
		Total2015 comma10.
		Population2014 comma10.
		Population2015 comma10.
		CrimeRate2015 comma6.2
		CrimeRate2014 comma6.2
		CrimeRateChange comma6.2;	
run;

/*Clean up the temporarily data set */
proc delete data=work.tmpmasterbycity;
proc delete data=work.tmpMasterByCityPopulation;

*-------------------------------------------*
| Name:   MasterByState                     |
| Remark: Tranbosed version of Table4 by    |
|         StateName                         |
*-------------------------------------------;
proc summary nway data=work.table4;
/* This is to SUM all cities' value group by StateName & Year and produce a 
temporary data set called tmpmasterbystate */
	var Aggravated_Assault Arson Burglary Larceny_Theft 
		Motor_Vehicle_Theft Murder Property_Crime Rape Robbery 
		Violent_Crime TotalCrime Population;
	class StateName Year;
	output out=work.tmpmasterbystate sum=;
run;

proc transpose data=work.tmpMasterByState 
		out=work.tmpmasterbystate(RENAME=(_NAME_=CrimeType '2014'n=Total2014 
		'2015'n=Total2015));
	id Year;
	var Aggravated_Assault Arson Burglary Larceny_Theft 
		Motor_Vehicle_Theft Murder Property_Crime Rape Robbery 
		Violent_Crime TotalCrime Population;
	by StateName;
run;

data work.tmpMasterByStatePopulation;
	set work.tmpMasterByState;
	Population2014=Total2014;
	Population2015=Total2015;
	/* Keep only population so when this join to tmpMasterByState it is 1 to 1 relationship */
	if CrimeType ^="Population" then DELETE;
run;

proc sql;
	CREATE TABLE work.MasterByState AS
		SELECT a.*, b.Total2014 AS Population2014, b.Total2015 AS Population2015
		FROM work.tmpMasterByState a
		LEFT JOIN work.tmpMasterByStatePopulation b
			ON b.StateName = a.StateName;
run;

data work.MasterByState;
	set work.MasterByState;
	CrimeRate2014=Total2014 / Population2014 * 100000;
	CrimeRate2015=Total2015 / Population2015 * 100000;
	CrimeRateChange=(CrimeRate2015-CrimeRate2014)/CrimeRate2014*100;
	format Total2014 comma10.
		Total2015 comma10.
		Population2014 comma10.
		Population2015 comma10.
		CrimeRate2015 comma6.2
		CrimeRate2014 comma6.2
		CrimeRateChange comma6.2;	
run;

/*Clean up the temporarily data set */
proc delete data=work.tmpmasterbystate;
proc delete data=work.tmpMasterByStatePopulation;
