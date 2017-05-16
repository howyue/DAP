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
	/* Calculate the percentage of change between 2015 & 2015 and assign it to a new variable ChangePerc */
	IF Total2014 ^= . and Total2015 ^= . then 
		ChangePerc = (Total2015 - Total2014) / Total2015 * 100;
	format ChangePerc 5.2;
run;

title1 'Crime Rate Change (2014/2015) vs Population (2015) By State';

*----------------------------------------------------*
| Create a bubble chart setting y-axis as ChangePerc |
| and x-axis as Population, size as the Total Crime  |
*----------------------------------------------------;
proc gplot data=work.MasterByStateWithPopulation(WHERE=(CrimeType = "TotalCrime"));
   bubble ChangePerc*Population2015=Total2015 / 
   	haxis=axis1 /* Using the default axis */
   	vaxis=axis2 /* Using the default axis */
	bcolor=vibg;
run;
