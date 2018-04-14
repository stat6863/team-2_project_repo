*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that will generate final analytic file;
%include '.\STAT6863-01_s18-team-2_data_preparation';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Which day of the week has more crime?

Rationale: This would help identify which day of the week has higher crime 
rates and allows police departments to better allocate resources when
targeting crime prevention.

Note: Using "WEEKDAYw" formating, this compares the column "TimeDispatch" 
from Calls_for_Service_2016 to the column of the same name from 
Calls_for_Service_2017 to combine the column and groups by day of the week to
"Weekday" from each year that has a unique NOPD Item Number. 

;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What is the most common offender age? 

Rationale: This should help determine what age that most offenders are 
committing crime and whether there is a way to decrease crime at that age.

Note: This compares the column "Item_Number" from Electronic_Police_Report_2016
to the column of the same name from Electronic_Police_Report_2017 to combine the column
"Offender_Age" from each year that has a unique Item Number.
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Which zip code has the most discharge of guns? 

Rationale: This could help identify which zip codes may be the most prone to
gun violence and help community leaders target them for crime control.

Note: This compares the column "TypeText" from Calls_for_Service_2016
to the column of the same name from Calls_for_Service_2017 where the column is 
equal to "DISCHARGING FIREARM" to combine to the column "Zip" from each year 
that which has a unique NOPD Item Number.
;

