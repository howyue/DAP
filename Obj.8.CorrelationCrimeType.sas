proc template;
	edit base.corr.stackedmatrix;
		column (rowname rowlabel) (matrix) * (matrix2) * (matrix3);
		edit matrix;
			cellstyle _val_=._ as {backgroundcolor=cxeeeeee}, 
			_val_  >=0.9 as {backgroundcolor=red};
		end;
	end;
run;

ods html file='Obj.8.CorrelationCrimeType.html' STYLE=sasweb;

title1 'The Correlationship Among Crime Category';

proc corr data=work.Table4;
	var Aggravated_Assault Larceny_Theft Arson Burglary 
		Motor_Vehicle_Theft Murder Robbery Rape;
run;

proc template;
   delete base.corr.stackedmatrix;
run;