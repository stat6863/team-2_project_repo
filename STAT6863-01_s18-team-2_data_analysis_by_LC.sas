*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that will generate final analytic file;
%include '.\STAT6863-01_s18-team-2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Which day of the week has more crime?'
;

title2 justify=left
'Rationale: This would help identify which day of the week has higher crime rates and allows police departments to better allocate resources when targeting crime prevention.'
;

footnote1 justify=left
"Friday has the most amount of crimes happening. The crime count totals/weekday were statistically significant with Sunday being the day with the least amount of crimes."
;

footnote2 justify=left
"One reason why crime has the most frequency in Fridays is because Friday is the start of the weekend and is the peak day of the week for night life."
;

footnote2 justify=left
"Likewise, Sundays is the start of the weekend and thus has the least amount of crime."
;

*
Note: Using "WEEKDAYw" formating, this compares the column "TimeDispatch" 
from Calls_for_Service_2016 to the column of the same name from 
Calls_for_Service_2017 to combine the column and groups by day of the week to
"Weekday" from each year that has a unique NOPD Item Number. 

Limitations: The weekday format converts the datetime value into a weekday 
number making it difficult to read the data. Should use a format proc to 
convert the numbers into names

Methodology: Use proc sql to create a temporary file removing all null 
data then use proc data to convert from datetime to weekday name. Then 
use proc freq to aggregate counts by weekday name.

Followup Steps: Combine the first two steps into one procedure. Use 
regression to see if there is a relationship between the type of crime
and the weekday name.

;

proc sql;
    create table CallsForService1617Day as
        select 
            TimeDispatch 
        from 
            nopd_analytic_file
		where
			TimeDispatch is not null
    ;
quit;
proc data CallsForService1617Day;	
    set CallsForService1617Day;
    Weekday=datepart(TimeDispatch);
    format Weekday weekdate3.;
run;
proc freq  
    order=freq
    data = CallsForService1617Day;
    tables weekday / norow nocol chisq out=counts
	;
run;

* clear titles/footnotes;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=center
'What is the average offender age?'
;

title2 justify=center
'Rationale: This should help determine what age that most offenders are committing crime and whether there is a way to decrease crime at that age.'
;

footnote1 justify=center
"The mean age for offenders is 32.54."
;

footnote2 justify=center
"This is lower than the average NOLA age. The average age in NOLA is 35.7. Most offenders are probably more likely to be younger."
;

*
Note: This compares the column "Item_Number" from Electronic_Police_Report_2016
to the column of the same name from Electronic_Police_Report_2017 to combine 
the column "Offender_Age" from each year that has a unique Item Number.

Limitations: Values of Item_Number from the datasets 
Electronic_Police_Report_2016 and Electronic_Police_Report_2017 that are blank
should be excluded. 

Methodology: Create a table using proc sql which averages all of the ages
in the offender age column then use proc report to display the results.

Followup Steps: Use "by District" in the sql state to do an average age by 
district.

;

proc sql;
	create table age_mean as
	    select 
	        mean(Offender_Age) as MeanOffenderAge
			label "Mean Offender Age"
	    from 
	        nopd_analytic_file
	    ;
quit;
proc report data=age_mean;
	columns
        MeanOffenderAge
    ;
run;

* clear titles/footnotes;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'What is the top district where murders happen?'
;

title2 justify=left
'Rationale: This could help identify which districts are more prone to murders and could help community advocates target those for crime prevention.'
;

footnote1 justify=left
"District 7 has the most amount of crimes, closely followed by district 8."
;

footnote2 justify=left
"The 7th District is the area the covers the East New Orleans. It is the area that was heavily flooded in the aftermath of Hurrican Katrina."
;

footnote3 justify=left
"The 8th District covers the Downtown area of New Orleans."
;

footnote4 justify=left
"This area was not heavily damaged in the aftermath of Hurricance Katrina and was one of the few areas that didn't get any flooding."
;

footnote5 justify=center
"The Lower 9th Ward"
;

footnote6 justify=left
"The area that was most damaged and least recovered after Hurricane Katrina is the Lower 9th Ward."
;

footnote7 justify=left
"This area is is encompassed by the 5th Distrct. The 5th district also covers the Upper 9th ward, the ByWater area and is third for the most amount of crimes by district."
;

*
Note: This compares the column "District" from Electronic_Police_Report_2016 
where the column "Signal_Description" includes "Homicide" and that which has a 
unique Item_Number.

Limitations: Rows with missing District data should be excluded since they are
missing data. Rows with missing Signal Description values should be excluded 
because they are missing data.

Methodology: Use proc sql to aggregae the total number of instances by district
and create a table with it called DistrictCounts. Then use proc sgplot to 
visualize the results.

Followup Steps: Use a map to display the results so that each district is
visualize geographically with the results.

;

proc sql;
	create table DistrictCounts as
	    select 
	        District
	        ,count(NOPD_Item) as Total
			label "Total number of crimes"
	    from
			nopd_analytic_file
		where
			not(missing(District))
	    group by District
	    order by Total desc
    ;
quit;
proc sgplot data=DistrictCounts;
  vbar District / RESPONSE=Total;
run;
quit;

* clear titles/footnotes;
title;
footnote;
