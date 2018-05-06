*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that will generate final analytic file;
%include '.\STAT6863-01_s18-team-2_data_preparation';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: How does the frequency of crime change over the course of a year?

Rationale: This should help police officers prepare for times of the year which have 
more crime.

Note: This compares the column "Charge_Description" and 
"Occured_Date Time" from 2016 and 2017 Calls for Service data sets.

Limitations: Values of "Charge Description" and "Occurred Date Time" that are 
blank should be excluded from this analysis, since they are potentially 
missing data values.
;

data datemonth;
	set calls_for_service_2016;
	dmonth=datepart(Occurred_Date_Time);
	format dmonth mmddyy10.;
run;

proc freq data=datemonth noprint;
   tables dmonth / out=crime_perday;
run;

goptions ftitle=swiss ftext=swiss;
symbol v=dot i=sm color=black width=2;
title height=2 "Frequency of Crime From";
title2 height=2 "January 1, 2016 and December 31, 2016";

proc gplot data=crime_perday;
   plot Count * dmonth;
run;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Can we predict the outcome of a fatality in New Orleans?

Rationale: This would help the police to identify which factors are significant in predicting 
a fatality in New Orleans.

Note: This compares the column "Victim Fatal Status" with the columns 
"signal description," "offender race," and "offender gender" from the 
2016 and 2017 Electronic Police Reports data set.

Limitations: Values of Time Dispatch and Time Arrive, along with any other 
appropriate column, that are blank should be excluded from this analysis, 
since they are potentially missing data values.
;

proc logistic data=Police_reports_2016;
	class district signal_description offender_race offender_gender;
	model victim_fatal_status = district signal_description offender_race offender_gender;
run; 

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Are certain crimes more prevalent than others?

Rationale: This would help police know of any crimes they should most be on the lookout for.

Note: This compares the column "Charge Description" from 2016 and 2017 Electronic Police Reports data sets.

Limitations: Values of Charge Description that are blank should be excluded from this analysis, 
since they are potentially missing data values.
;

proc freq data=Police_reports_2016;
	tables charge_description;
run;
