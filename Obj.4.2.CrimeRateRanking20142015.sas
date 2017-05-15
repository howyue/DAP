proc sort data=work.MasterByState;
	by CrimeType descending CrimeRate2015;
run;

proc rank data=work.MASTERBYSTATE out=work.CrimeRateRankingByCategory ties=low 
		descending;
	by CrimeType;
	var CrimeRate2014 CrimeRate2015;
	ranks CrimeRate2014Rank CrimeRate2015Rank;
run;

ODS html file='Obj.4.2.Top10CrimeRate20142015.html' STYLE=sasweb;

title1 'Top 10 State by Crime Rate 2014/2015';
axis1 label=none; *This is to overwrite the default axis so nothing is shown;
axis2 color=blue label=('Crime Rate');

proc print data=work.CrimeRateRankingByCategory noobs label;
	by CrimeType;
	where CrimeType IN ('TotalCrime') 
		and CrimeRate2015Rank <=10 
		and CrimeRate2015Rank ^=.;
	var StateName CrimeRate2015Rank CrimeRate2014Rank CrimeRateChange CrimeRate2015;	
	label StateName = 'State'
		CrimeRate2015Rank = 'Ranking'
		CrimeRate2014Rank = 'Ranking (2014)'
		CrimeRateChange = 'Change (%)'
		CrimeRate2015 = 'Crime Rate';
run;

proc gchart data=work.CrimeRateRankingByCategory;
	where CrimeType='TotalCrime' and CrimeRate2015Rank < 11;
	hbar StateName / discrete
		sumvar=CrimeRate2015
		maxis=axis1
		raxis=axis2
		sumlabel=none
		descending;
run;