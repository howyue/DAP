*-----------------------------------------------*
| Sorting the work.MasterByState by StateName   |
| to ensure all the States are grouped together |
| prior to the PROC TRANSPOSE                   |
*-----------------------------------------------;
proc sort data=work.MasterByState;
	by StateName;
run;

proc transpose data=work.MasterByState(keep=StateName CrimeType Total2015
		WHERE=(CrimeType IN ('Aggravated_Assault', 'Arson', 'Burglary', 
			'Larceny_Theft', 'Motor_Vehicle_Theft', 'Murder', 'Rape', 'Robbery', ))) 
		out=work.masterbystatetranbose2015(DROP=_NAME_ 
			RENAME=(COL1=Aggravated_Assault COL2=Arson COL3=Burglary COL4=Larceny_Theft 
		COL5=Motor_Vehicle_Theft COL6=Murder COL7=Rape COL8=Robbery));
	by StateName;
run;

*-----------------------------------------------*
| Sorting the work.Economy by StateName         |
| to ensure all the States are grouped together |
| prior to the PROC TRANSPOSE                   |
*-----------------------------------------------;
proc sort data=dap.Economy;
	by StateName NAIC;
run;

proc transpose data=dap.Economy out=work.StateEconomyValue(DROP=_NAME_ _LABEL_);
	by StateName;
	/* Label the new dataste work.StateEconomyValue */
	label COL1='Accommodation and food services' 
		COL2='Administrative and support and waste management an' 
		COL3='Arts, entertainment, and recreation' COL4='Construction' 
		COL5='Educational services' COL6='Finance and insurance' 
		COL7='Health care and social assistance' COL8='Information' 
		COL9='Management of companies and enterprises' 
		COL10='Mining, quarrying, and oil and gas extraction' 
		COL11='Other services (except public administration)' 
		COL12='Professional, scientific, and technical services' 
		COL13='Real estate and rental and leasing' COL14='Retail trade' 
		COL15='Transportation and warehousing (104)' COL16='Utilities' 
		COL17='Wholesale trade - Manufacturers'' sales branches and offices' 
		COL18='Wholesale trade - Merchant wholesalers, except manufacturers'' sales' 
		COL19='Wholesale trade - Wholesale Trade';
run;

proc sql;
	CREATE TABLE work.TotalCrimeByStateByEconomy AS 
		SELECT a.StateName, 
			Aggravated_Assault, Arson, Burglary, Larceny_Theft, Motor_Vehicle_Theft, 
			Murder, Rape, Robbery, b.COL1, b.COL2, b.COL3, b.COL4, b.COL5, b.COL6, 
			b.COL7, b.COL8, b.COL9, b.COL10, b.COL11, b.COL12, b.COL13, b.COL14, b.COL15, 
			b.COL16, b.COL17, b.COL18, b.COL19 
		FROM work.masterbystatetranbose2015 a 
		LEFT JOIN work.StateEconomyValue b 
			ON a.StateName=b.StateName;
run;

*-------------------------------------------------------*
| Similar to Obj.8.CorrelationCrimeType.sas overwriting |
| the cell style to highlight correlation when it is    |
| greater equal to 0.8                                  |
*-------------------------------------------------------;
proc template;
	edit base.corr.stackedmatrix;
		column (rowname rowlabel) (matrix) * (matrix2) * (matrix3);
		edit matrix;
			cellstyle _val_=._ as {backgroundcolor=cxeeeeee}, 
			_val_  >=0.8 as {backgroundcolor=red};
		end;
	end;
run;

ODS html file='Obj.9.CorrelationVSEconomy2015-results.html' style=sasweb;

title1 'Correlation Between Crime Category (2015) and States'' Economy Value By NAIC';
title2 'Value of sales, shipments, receipts, revenue, or business done ($1,000)';

proc corr data=work.TotalCrimeByStateByEconomy out=work.TotalCrimeByStateByEconomyCorr;
	/* Finding the correlation of one group variables against another group of variables */
	var Aggravated_Assault Arson Burglary Larceny_Theft Motor_Vehicle_Theft Murder 
		Rape Robbery;
	with COL1 COL2 COL3 COL4 COL5 COL6 COL7 COL8 COL9 COL10 COL11 COL12 COL13 
		COL14 COL15 COL16 COL17 COL18 COL19;
run;

proc template;
   delete base.corr.stackedmatrix;
run;

*-------------------------------------------------------*
| After identifying the significant correlation run the |
| PROC CORR individually and produce a scatter plot     |
*-------------------------------------------------------;
title1 'Correlation Between Motor Vehicle Theft and Mining, quarrying, and oil and gas extraction Industry';

proc corr data=work.TotalCrimeByStateByEconomy plot=scatter();
	var Motor_Vehicle_Theft;
	with COL10;
run;

title1 'Correlation Between Murder and Construction, Retail Trade & Transportation and warehousing Industry';
proc corr data=work.TotalCrimeByStateByEconomy plot=scatter();
	var Murder;
	with COL4;
run;

title1 'Correlation Between Rape and Arts, entertainment, and recreation Industry';
proc corr data=work.TotalCrimeByStateByEconomy plot=scatter();
	var Rape;
	with COL3;
run;
