proc sort data=work.MasterByState;
	by CrimeType descending CrimeRate2015;
run;

proc rank data=work.MASTERBYSTATE out=work.CrimeRateRankingByCategory ties=low 
		descending;
	by CrimeType;
	var CrimeRate2014 CrimeRate2015;
	ranks CrimeRate2014Rank CrimeRate2015Rank;
run;

ODS html file='Obj.5.CrimeRateRankingByType2015.html' STYLE=sasweb;

title1 'Violent Crime Rate Ranking By Type 2015';

proc print data=work.CrimeRateRankingByCategory noobs label;
	by CrimeType;
	where CrimeType IN ('Aggravated_Assault', 'Murder', 'Rape', 'Robbery') 
		and CrimeRate2015Rank <=3 
		and CrimeRate2015Rank ^=.;
	var StateName CrimeRate2015Rank CrimeRate2014Rank CrimeRateChange CrimeRate2015;	
	label StateName = 'State'
		CrimeRate2015Rank = 'Ranking'
		CrimeRate2014Rank = 'Ranking (2014)'
		CrimeRateChange = 'Change (%)'
		CrimeRate2015 = 'Crime Rate';
run;

title1 'Property Crime Rate Ranking By Type 2015';

proc print data=work.CrimeRateRankingByCategory noobs label;
	by CrimeType;
	where CrimeType IN ('Arson', 'Burglary', 'Larceny_Theft', 'Motor_Vehicle_Theft') 
		and CrimeRate2015Rank <=3 
		and CrimeRate2015Rank ^=.;
	var StateName CrimeRate2015Rank CrimeRate2014Rank CrimeRateChange CrimeRate2015;	
	label StateName = 'State'
		CrimeRate2015Rank = 'Ranking'
		CrimeRate2014Rank = 'Ranking (2014)'
		CrimeRateChange = 'Change (%)'
		CrimeRate2015 = 'Crime Rate';
run;