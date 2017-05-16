*------------------------------------------------------------------------*
| This entire script is similar to Obj.4.2.CrimeRateRanking20142015.sas  |
| only changing from CrimeRate to CrimeRateChange (difference between    |
| 2014 & 2015)                                                           |
*------------------------------------------------------------------------;

proc sql;
	CREATE TABLE work.MasterByStateWithPopulation AS
		SELECT a.*, b.Total2015 AS Population2015
		FROM work.MasterByState a
		LEFT JOIN work.MasterByState b
			ON b.StateName = a.StateName
			AND b.CrimeType='Population';
run;

proc sort data=work.MasterByStateWithPopulation;
	by descending CrimeRateChange;
run;

proc rank data=work.MasterByStateWithPopulation OUT=work.MasterByStateCrimeRateRank ties=low 
		descending;
	where CrimeType = 'TotalCrime';
	var CrimeRateChange;
	ranks CrimeRateChangeRank;
run;

ODS html file='Obj.4.3.CrimeRateChangeRanking20142015.html' STYLE=sasweb;

title1 'Top 10 State with Highest Increase of Crime Rate 2014/2015';
axis1 label=none; *This is to overwrite the default axis so nothing is shown;
axis2 color=blue label=('Percentage of Change Between 2014 and 2015');

proc print data=work.MasterByStateCrimeRateRank noobs label;
	where CrimeType IN ('TotalCrime') 
		and CrimeRateChangeRank <=10;
	var StateName Population2015 CrimeRate2015 CrimeRate2014 CrimeRateChange CrimeRateChangeRank;	
	label StateName = 'State'
		Population2015 = 'Population (2015)'
		CrimeRateChange = 'Change (%)'
		CrimeRateChangeRank = 'Ranking';
run;

proc gchart data=work.MasterByStateCrimeRateRank;
	where CrimeType='TotalCrime' and CrimeRateChangeRank < 11;
	hbar StateName / discrete
		sumvar=CrimeRateChange
		maxis=axis1
		raxis=axis2
		sumlabel=none
		descending;
run;
