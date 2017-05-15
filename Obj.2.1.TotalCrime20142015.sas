proc sql;
	CREATE TABLE work.TotalCrimeByState AS 
		SELECT monotonic() AS Row, b.StateName, 
			CASE WHEN c.Total2014 IS NOT NULL THEN c.Total2014 ELSE 0 END AS TotalCrime2014, 
			CASE WHEN c.Total2015 IS NOT NULL THEN c.Total2015 ELSE 0 END AS TotalCrime2015, 
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
	pattern1 c=white;
	pattern2 c=papk;
	pattern3 c=lipk;
	pattern4 c=stpk;
	pattern5 c=vipk;
	pattern6 c=depk;
	legend1 across=1 position=(right middle);
	end;
run;

proc format;
	value fTotalCrime 
		low-5000='< 5,000'
		5000-10000='5,000-10,000'
		10000-50000='10,000-50,000'
		50000-100000='50,000-100,000'
		100000-200000='100,000-200,000'
		200000-high='> 200,000';
run;

ODS listing style=styles.colorramp;
ODS html style=styles.colorramp;

title1 'U.S Total Crime By State 2014';
proc gmap map=maps.us data=work.TotalCrimeByState;
	format TotalCrime2014 fTotalCrime. ;
	id State;
	label TotalCrime2014 = 'Total Crime';
	choro TotalCrime2014 / 
		coutline=red 
		discrete 
		annotate=maplabel;
run;

proc template;
	define style styles.colorramp;
	pattern1 c=white;
	pattern2 c=papk;
	pattern3 c=lipk;
	pattern4 c=stpk;
	pattern5 c=depk;
	legend1 across=1 position=(right middle);
	end;
run;

title1 'U.S Total Crime By State 2015';
proc gmap map=maps.us data=work.TotalCrimeByState;
	format TotalCrime2015 fTotalCrime. ;
	id State;
	label TotalCrime2015 = 'Total Crime';
	choro TotalCrime2015 / coutline=red 
		discrete 
		annotate=maplabel;
run;