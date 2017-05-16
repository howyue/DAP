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
		out=work.tmpmasterbystate(RENAME=(_NAME_=CrimeType));
	var Aggravated_Assault Arson Burglary Larceny_Theft 
		Motor_Vehicle_Theft Murder Property_Crime Rape Robbery 
		Violent_Crime TotalCrime Population;
	by StateName Year;
run;

title1 'Total Crime Comparison 2014 & 2015';
title2 'Top 3 State - California, New York, Texas';

proc gchart data=work.tmpmasterbystate;  
	where StateName in ('California','New York','Texas') 
		and CrimeType = 'TotalCrime';                
	vbar Year / subgroup=Year 
		group=StateNAme 
		sumvar=COL1 
		discrete;  
	label COL1 = 'Total Crime'; /* We did not rename COL1 in PROC TRANSPOSE hence overwrite the default COL1 name with Total Crime */
	format COL1 comma10.;
run;                                                                                                                                    
