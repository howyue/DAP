proc sql;
	CREATE TABLE work.TotalCrimeByStateByEthnicity AS
		SELECT a.Total2015, b.*
		FROM work.masterbystate a
		LEFT JOIN dap.ethnicity b
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

ODS html file='Obj 5 - 2. CorrelationVSEthnicty2015.html' STYLE=sasweb;

title1 'Correlation Between Total Crime (2015) with Ethnicity';
proc corr data=work.TotalCrimeByStateByEthnicity; 
	var Total2015;
	with var4-var19;*Exclude the Estimate; Total:;
run;

proc template;
   delete base.corr.stackedmatrix;
run;

title1 'Correlation Between Total Crime (2015) with Ethnicity';
proc corr data=work.TotalCrimeByStateByEthnicity plots=scatter();
	var Total2015;
	with var12;
run;

title1 'Correlation Between Total Crime (2015) with Ethnicity';
proc corr data=work.TotalCrimeByStateByEthnicity plots=scatter();
	var Total2015;
	with var4;
run;