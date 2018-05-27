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
'Question: What are the top 5 initial type of service calls that are received by the New Orleans Police Department?'
;

title2 justify=left
'Rationale: This should help determine what type of crimes are most common in New Orleans, which should help inform the police department as to what preventative measures they should take to prevent these crimes.'
;

footnote1 justifty=left
"The top five inital types of service calls that are receieved by the New Orleans Police Deapartment are other complaints at 157,499 calls, traffic incidents at  84,952 calls, slient burglar alarms at 79,795 calls, other disturbances at 54,264 calls, and auto accidents at 39,838 calls."
;

*
Note: This compares the column "NOPD_Item" from Calls_for_Service_2016
to the column of the same name from Calls_for_Service_2017 to combine the 
column "InitialTypeText" from each year that has a unique NOPD Item Number.

Limitations: Values of InitialTypeText that are blank should be 
excluded from this analysis, since they are potentially missing data values.
;

proc sql outobs=5;
    select 
        InitialTypeText
        ,count(*) as Call_Type_freq
    from
        nopd_analytic_file
    group by
        InitialTypeText
    order by
        Call_Type_freq desc;
quit;

title1
'Bar graph illustrating the frequency of the different call types'
;

proc sgplot data = nopd_analytic_file;
    hbar InitialTypeText;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: What is the most common offender age?'
;

title2 justify=left
'Rationale: This should help determine what age that most offenders are committing crime and whether there is a way to decrease crime at that age.'
;

Note: This compares the column "Item_Number" from Electronic_Police_Report_2016
to the column of the same name from Electronic_Police_Report_2017 to combine the column
"Offender_Age" from each year that has a unique Item Number.

Limitations: Values of Offender_Age equal to zero or blank should be excluded
from this analysis, since they are potentially missing data values.
;

footnote1 justifty=left
"The most common offeder age is 25 at 1,554 reports filed against people that age."
;

proc sql;
    select
        Offender_Age
	,count(*) as Offender_Age_freq
    from
        nopd_analytic_file
    where
        not(missing(Offender_Age)
    group by
        Offender_Age
    order by
        Offender_Age_freq desc;
quit;
   
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: Are there certain zip codes in New Orleans that are more prone to crime than others?'
;

title2 justify=left
'Rationale: This should help the police department determine if they need to increase patrol in certain zip codes or increase their police force in these zip codes.'
;

footnote1 justifty=left
"The top zip codes more prone to crime are 70119 with 115,247 calls, 70130 with 82,581 calls, and 70126 with 68,473 calls "
;

Note: This compares the column "NOPD_Item" from Calls_for_Service_2016
to the column of the same name from Calls_for_Service_2017 to combine the 
column "Zip" from each year that has a unique NOPD Item Number.

Limitations: Values of Zip that are blank should be excluded
from this analysis, since they are potentially missing data values.
;

proc sql outobs=3;
    select 
        Zip
        ,count(*) as Zip_freq
    from
        nopd_analytic_file
    group by
        Zip
    order by
        Zip_freq desc;
quit;
