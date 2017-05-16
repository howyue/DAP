*---------------------------------------------------*
| This is to create the annotate table which will   |
| be used by PROC GMAP                              |
*---------------------------------------------------;
data maplabel;
   length function $ 8;
   retain flag 0 xsys ysys '2' hsys '3' when 'a' style "'Albany AMT'";
   set maps.uscenter(drop=long lat);

   where fipstate(state) ne 'DC' and  fipstate(state) ne 'PR'; 

   function='label'; text=fipstate(state); size=2.5; position='5';
   
     /* The FIPSTATE function creates the label   */
     /* text by converting the FIPS codes from    */
     /* MAPS.USCENTER to two-letter postal codes. */

   if ocean='Y' then               
      do;                          
         position='6'; output;    
         function='move';                                                      
         flag=1;
      end;
      
  /* If the labeling coordinates are outside the state (OCEAN='Y'), Annotate    */
  /* adds the label and prepares to draw the leader line. Note: OCEAN is a      */
  /* character variable and is therefore case sensitive. OCEAN='Y' must specify */
  /* an uppercase Y.                                                            */
      
  /* When external labeling is in effect, Annotate */
  /* draws the leader line and resets the flag.    */                                            
   else if flag=1 then            
      do;                                                                   
         function='draw'; size=.5;
         flag=0;
      end;
   output;
run;
