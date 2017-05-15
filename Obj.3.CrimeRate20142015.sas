proc sql;
	CREATE TABLE work.CrimeRateByState AS 
		SELECT monotonic() AS Row, b.StateName, 
			CASE WHEN c.CrimeRate2014 IS NOT NULL THEN c.CrimeRate2014 ELSE 0 END AS CrimeRate2014, 
			CASE WHEN c.CrimeRate2015 IS NOT NULL THEN c.CrimeRate2015 ELSE 0 END AS CrimeRate2015, 
			c.CrimeType, a.State, b.Code 
		FROM maps.us a 
		LEFT JOIN dap.state b 
			ON b.Code=a.StateCode 
		LEFT JOIN work.MasterByState c 
			ON c.StateName=b.StateName 
			AND c.CrimeType IN ('TotalCrime');
run;

proc template;
	define style styles.colorramp;
	pattern1 v=ms c=white;
	pattern2 v=ms c=papk;
	pattern3 v=ms c=lipk;
	pattern4 v=ms c=stpk;
	pattern5 v=ms c=vipk;
	legend1 across=1 position=(right middle);
	end;
run;

proc format;
	VALUE fCrimeRate 
		low-0='Not Available'
		1-1000='< 1000 (Low)'
		1000-2000='1001 - 2000 (Medium)'
		2000-3000='2001 - 3000 (High)'
		3000-high='>3000 (Very High)';
run;

ODS listing style=styles.colorramp;
ODS html style=styles.colorramp;

title1 'U.S Crime Rate (per 100,000 population) By State 2014';
proc gmap map=maps.us data=work.CrimeRateByState;
	format CrimeRate2014 fCrimeRate. ;
	id State;
	label CrimeRate2014='Crime Rate';
	choro CrimeRate2014 / coutline=red 
		discrete 
		annotate=maplabel;
run;

title1 'U.S Crime Rate (per 100,000 population) By State 2015';
proc gmap map=maps.us data=work.CrimeRateByState;
	format CrimeRate2015 fCrimeRate. ;
	id State;
	label CrimeRate2015='Crime Rate';
	choro CrimeRate2015 / coutline=red 
		discrete 
		annotate=maplabel;
run;