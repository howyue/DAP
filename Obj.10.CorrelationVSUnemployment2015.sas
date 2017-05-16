*----------------------------------------------------------------------*
| This entire script is similar to Obj.9.CorrelationVSEconomy2015.sas  |
| only changing the dap.Economy to dap.unemploymenr in PROC SQL        |
*----------------------------------------------------------------------;
proc sql;
	CREATE TABLE work.TotalCrimeByStateByUnemployment AS
		SELECT a.Total2015, b.*
		FROM work.masterbystate a
		LEFT JOIN dap.unemployment b
			ON a.StateName = b.StateName
		WHERE a.CrimeType='TotalCrime';
run;

proc template;
   edit base.corr.stackedmatrix;
      column (RowName RowLabel) (Matrix) * (Matrix2) * (Matrix3) * (Matrix4);
	edit matrix2;
		cellstyle _val_=._ as {backgroundcolor=cxeeeeee}, 
		_val_  <=.05 as {backgroundcolor=red};
	end;
    end;
run;

ODS html file='Obj 5 - 4. CorrelationVSUnemployment2015.1.html' style=sasweb;

title1 'Correlation Between Total Crime (2015) with Unemployment';
proc corr data=work.TotalCrimeByStateByUnemployment;
	var Total2015;
	with var3-var22;
run;

proc template;
   delete base.corr.stackedmatrix;
run;

title1 'Correlation Between Total Crime (2015) with Unemployment';
title2 'Unemployment rate; Estimate; RACE AND HISPANIC OR LATINO ORIGIN - White alone';
proc corr data=work.TotalCrimeByStateByUnemployment nosimple plots=scatter();
	var Total2015;
	with var13;
run;
