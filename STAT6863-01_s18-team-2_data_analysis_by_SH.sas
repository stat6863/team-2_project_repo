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
'Question: What are the top 5 types of service calls that are received by the New Orleans Police Department?'
;

title2 justify=left
'Rationale: This should help determine what types of crime are being called into the New Orleans Police Department, which should help the police department make informed decisions as to what preventative measures they should take.'
;

footnote1 justify=left
"The top five inital types of service calls that are receieved by the New Orleans Police Department are other complaints at 157,431 calls, traffic incidents at 84,946 calls, silent burglar alarms at 79,795 calls, other disturbances at 54,259 calls, and auto accidents at 39,837 calls."
;

footnote2 justify=left
"This shows that the top type of calls have to do with other complaints, further investigation into what these other complaints are would be helpful."
;

footnote3 justify=left
"It would also be helpful to further investigate into the difference between a traffic incident and an auto accident."
;

footnote4 justify=left
"Lastly, now that the common types of service calls are known, further investigation can be done and developments of preventative measures can be made to cut down on these call types, which would cut down on crimes."
;

*
Note: This compares the column "NOPD_Item" from Calls_for_Service_2016
to the column of the same name from Calls_for_Service_2017 to combine the 
column "InitialTypeText" from each year that has a unique NOPD Item Number.

Limitations: Values of InitialTypeText that are blank should be 
excluded from this analysis, since they are potentially missing data values.

Methodology: Use proc sql to create a sorted table in descending order by 
the count of each type of InitialTypeText. Then use proc report to print the 
first five rows of the sorted dataset.

Followup Steps: More carefully clean values in order to clear out any 
possible illegal values, and better handle missing data. As well as any 
further investigation stated above.
;

*create table with the different call types and the count of the call types
 sorted by descending frequency;
proc sql noprint;
    create table Call_Type as
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

*output of first five rows of resulting sorted table data, addressing research question;
proc report data = Call_Type (obs=5);
    columns
        InitialTypeText
        Call_Type_freq
    ;
run;

* clear titles/footnotes;
title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: What is the most common offender age?'
;

title2 justify=left
'Rationale: This should help determine at what age most offenders are committing crime and whether there is a way to decrease crime at that age.'
;

footnote1 justify=left
"The most common offeder age is 25 at 1,554 reports filed against people that age."
;

footnote2 justify=left
"It seems at thought most crimes are commited by offenders in their 20's."
;

footnote1 justify=left
"With this information and more research into the backgrounds of these offenders, there may be some commonality that can be prevented or helped."
;

*
Note: This compares the column "Item_Number" from Electronic_Police_Report_2016
to the column of the same name from Electronic_Police_Report_2017 to combine 
the column"Offender_Age" from each year that has a unique Item Number.

Limitations: Values of Offender_Age equal to zero or blank should be excluded
from this analysis, since they are potentially missing data values.

Methodology: Use proc sql to view the count of each offender age as well as 
the age of the defender in descending order according to count.

Followup Steps: More carefully clean values in order to filter out any 
possible illegal values, such as the negative ages, and better handle 
missing data. As well as any further investigation stated above.
;

*create a view of the data with the age of offenders and the count of the different 
offender ages sorted by descending frequency;
proc sql;
    select
        Offender_Age
	,count(*) as Offender_Age_freq
    from
        nopd_analytic_file
    where
        not(missing(Offender_Age))
    group by
        Offender_Age
    order by
        Offender_Age_freq desc;
quit;

* clear titles/footnotes;
title;
footnote;
   
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1 justify=left
'Question: What zip codes in New Orleans are more prone to crime and are these areas more frequently hit by crime by offenders of a certain age?'
;

title2 justify=left
'Rationale: This should help the police department determine if they need to increase patrol in certain zip codes.'
;

footnote1 justify=left
"The top zip codes more prone to crime are 70119 with 115,210 calls, 70130 with 82,545 calls, and 70126 with 68,450 calls."
;

footnote2 justify=left
"There is a statistically significant negative correlation with the p-value being less than 0.001, but the strength of the relationship is only about 16%."
;

footnote3 justify=left
"Due to the statistically significant correlation, further investigation into this relationship should be done, especially after some further cleaning of the data."
;

*
Note: This compares the column "NOPD_Item" from Calls_for_Service_2016
to the column of the same name from Calls_for_Service_2017 to combine the 
column "Zip" from each year that has a unique NOPD Item Number.

Limitations: Values of Zip that are blank should be excluded from this 
analysis, since they are potentially missing data values.

Methodology: Use proc corr to perform a correlation analysis, and use 
proc sql to find the top three zip codes that are more prone to crime.
Also, use proc sgplot to output a scatterplot to show the correlation
or lack thereof.

Followup Steps: More carefully clean values in order to filter out any 
possible illegal values and better handle missing data. As well as any 
further investigation stated above.
;

*creates a correlation table between Zip and Offender Age;
proc corr
        data = nopd_analytic_file
        nosimple
    ;
    var
        Zip
        Offender_Age
    ;
    where
        not(missing(Zip))
        and
        not(missing(Offender_Age))
    ;
run;

*create a view of the data with the top three crime inflicted zip codes and the 
count of the different offender ages sorted by descending frequency;
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

*clear titles/footnotes;
title;
footnote;

title1
'Plot illustrating the relationship between Zip Code and Offender Age'
;

footnote1
"In the above plot it can be seen that there is no corrleation; however, there are definitely some zip codes that see more crime as well as zip codes that have different offender ages."
;

*create scatter plot of Zip and Offender_Age;
proc sgplot data = nopd_analytic_file;
    scatter
        x = Zip
        y = Offender_Age
    ;
run;

* clear titles/footnotes;
title;
footnote;
