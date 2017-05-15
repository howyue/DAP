proc sql;
	CREATE TABLE work.PopulationByState AS 
		SELECT monotonic() AS Row, b.StateName, 
			CASE WHEN c.Total2014 IS NOT NULL THEN c.Total2014 ELSE 0 END AS Population2014, 
			CASE WHEN c.Total2015 IS NOT NULL THEN c.Total2015 ELSE 0 END AS Population2015, 
			c.CrimeType, a.State, b.Code 
		FROM maps.us a 
		LEFT JOIN dap.state b 
			ON b.Code=a.StateCode 
		LEFT JOIN work.MasterByState c 
			ON c.StateName=b.StateName 
			AND c.CrimeType IN ('Population');
run;

proc template;
	define style styles.colorramp;
	pattern1 c=white;
	pattern2 c=pagy;
	pattern3 c=ligy;
	pattern4 c=moy;
	pattern5 c=dey; 
	pattern6 c=deyg;
	legend1 across=1 position=(right middle);
	end;
run;

proc format;
	value fPopulation 
		low-500000='< 500,000'
		500000-1000000='500,000 - 1,000,000'
		1000000-2000000='1,000,000 - 2,000,000'
		2000000-4000000='2,000,000 - 4,000,000'
		4000000-8000000='4,000,000 - 8,000,000'
		8000000-high='> 8,000,000';
run;

ODS listing style=styles.colorramp;
ODS html style=styles.colorramp;

title1 'U.S Population By State 2015';
footnote color=red 'Summary of population of city with 100,000 and over in population';
proc gmap map=maps.us data=work.PopulationByState;
	format Population2015 fPopulation. ;
	id State;
	label Population2015 = 'Population';
	choro Population2015 / legend=LEGEND1 
		coutline=green 
		discrete 
		annotate=maplabel;
run;
