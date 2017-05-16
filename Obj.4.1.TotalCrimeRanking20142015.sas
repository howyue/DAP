proc sql;
	CREATE TABLE work.MasterByStateWithPopulation AS
		SELECT a.*, b.Total2015 AS Population2015
		FROM work.MasterByState a
		LEFT JOIN work.MasterByState b
			ON b.StateName = a.StateName
			AND b.CrimeType='Population';
run;

proc rank data=work.MasterByStateWithPopulation out=work.MasterByStateTotalCrimeRank ties=low 
		descending;
	where CrimeType = 'TotalCrime';
	var Total2014 Total2015;
	ranks TotalCrime2014Rank TotalCrime2015Rank;
run;

*------------------------------------------------------*
| After PROC RANK the data set need to be sorted       |
| otherwise PROC PRINT & PROC GCHART below will not    |
| display according in the order of TotalCrime2015Rank |
*------------------------------------------------------;
proc sort data=work.MasterByStateTotalCrimeRank;
	by TotalCrime2015Rank;
run;

ODS html file='Obj.4.1.Top10TotalCrime20142015.html' style=sasweb;

title1 'Top 10 State by Total Crime 2014/2015';
axis1 label=none; *This is to overwrite the default axis not to show m-axis label;
axis2 color=blue label=('Total Crime Reported');

proc print data=work.MasterByStateTotalCrimeRank noobs label;
	where TotalCrime2015Rank < 11;
	var StateName Total2015 Total2014 CrimeRate2014 CrimeRate2015 TotalCrime2015Rank TotalCrime2014Rank ;	
	label StateName = 'State'
		Total2015 = 'Total Crime'
		Total2014 = 'Total Crime (2014)'
		TotalCrime2015Rank = 'Ranking'
		TotalCrime2014Rank = 'Ranking (2014)';
run;

/* Plot the horizontal bar chart by the TotalCrime reported*/
proc gchart data=work.MasterByStateTotalCrimeRank;
	where CrimeType='TotalCrime' and TotalCrime2015Rank < 11;
	hbar StateName / discrete
		sumvar=Total2015
		maxis=axis1
		raxis=axis2
		sumlabel=none
		descending;
run;
