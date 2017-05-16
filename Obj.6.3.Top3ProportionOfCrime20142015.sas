*--------------------------------------------------------------*
| Create a pie chart using the procgchart group by crime type  |
*--------------------------------------------------------------;

proc gchart data=work.masterbystate;
 where crimetype not in ('Population','TotalCrime','Property_Crime','Violent_Crime') /* Exclude the unwanted elements (CrimeType) */
  and StateName IN ('California','New York','Texas'); 
 pie crimetype / sumvar=total2015
  midpoints='Aggravated_Assault' 'Murder' 'Robbery' 'Rape'
            'Burglary' 'Larceny_Theft' 'Motor_Vehicle_Theft' 'Arson'
  value=none
  percent=arrow
  slice=arrow
  noheading
  other=0
  group=StateName; /* Create 3 charts one for each State */
run;

