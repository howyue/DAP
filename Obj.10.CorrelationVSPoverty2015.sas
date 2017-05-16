*----------------------------------------------------------------------*
| This entire script is similar to Obj.9.CorrelationVSEconomy2015.sas  |
| only changing the dap.Economy to dap.poverty in PROC SQL             |
*----------------------------------------------------------------------;

proc sql;
	CREATE TABLE work.TotalCrimeByStateByPoverty AS
		SELECT a.Total2015, b.*
		FROM work.masterbystate a
		LEFT JOIN dap.poverty b
			ON a.StateName = b.StateName
		WHERE a.CrimeType='TotalCrime';
run;

proc template;
   edit base.corr.stackedmatrix;
      column (RowName RowLabel) (Matrix) * (Matrix2) * (Matrix3) * (Matrix4);
	edit matrix;
		cellstyle _val_=._ as {backgroundcolor=cxeeeeee}, 
		_val_  >=.8 as {backgroundcolor=red};
	end;
    end;
run;

ODS html file='Obj 5 - 3. CorrelationVSPoverty2015.html' style=sasweb;

title1 'Correlation Between Total Crime (2015) with Poverty';
proc corr data=work.TotalCrimeByStateByPoverty;
	var Total2015;
	with var3 var4 var5;
run;

title1 'Correlation Between Total Crime (2015) with Poverty';
title2 'Estimate; Total:';
proc corr data=work.TotalCrimeByStateByPoverty plots=scatter();
	var Total2015;
	with var3;
run;

proc template;
   delete base.corr.stackedmatrix;
run;
