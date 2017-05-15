proc sql;
	CREATE TABLE work.MasterByStateWithPopulation AS
		SELECT a.*, b.Total2015 AS Population2015
		FROM work.MasterByState a
		LEFT JOIN work.MasterByState b
			ON b.StateName = a.StateName
			AND b.CrimeType='Population';
run;

data work.MasterByStateWithPopulation;
	set work.MasterByStateWithPopulation;
	IF Total2014 ^= . and Total2015 ^= . then 
		ChangePerc = (Total2015 - Total2014) / Total2015 * 100;
	format ChangePerc 5.2;
run;

title1 'Crime Rate Change (2014/2015) vs Population (2015) By State';

proc gplot data=work.MasterByStateWithPopulation(WHERE=(CrimeType = "TotalCrime"));
   bubble ChangePerc*Population2015=Total2015 / 
   	haxis=axis1 
   	vaxis=axis2 
	bcolor=vibg;
run;