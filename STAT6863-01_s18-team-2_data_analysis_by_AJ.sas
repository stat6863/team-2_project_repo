*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that will generate final analytic file;
%include '.\STAT6863-01_s18-team-2_data_preparation';


******************************************************************************;
* Research Question Analysis Starting Point;
******************************************************************************;
*
Question: How does the frequency of crime change over the course of a year?

Rationale: This should help police officers prepare for times of the year which 
have more crime.

Note: This compares the column "Time Create" and "Type Text" from 2016 and 2017 
Calls for Service data sets.

Limitations: Values of "Type Text" and "Time Create" that are blank should be 
excluded from this analysis, since they are potentially missing data values.
;

data new_callsforservice_16;
	set calls_for_service_2016;
	dmonth=datepart(TimeCreate);
	format dmonth mmddyy10.;
run;

proc freq data=new_callsforservice_16 noprint;
	tables dmonth / out=crime_perday;
run;

goptions ftitle=swiss ftext=swiss;
symbol v=dot i=sm color=black width=1;
title height=2 "Frequency of Crime From";
title2 height=2 "January 1, 2016 and December 31, 2016";

proc gplot data=crime_perday;
	plot count * dmonth;
run;

******************************************************************************;
* Research Question Analysis Starting Point;
******************************************************************************;
*
Question: Can we predict the outcome of a fatality in New Orleans?

Rationale: This would help the police to identify which factors are significant 
in predicting a fatality in New Orleans.

Note: This compares the column "Victim Fatal Status" with the columns 
"Signal Description," "District," "Offender Race," and "Offender Gender" from 
the 2016 and 2017 Electronic Police Reports data set.

Limitations: Values of "Victim Fatal Status," "Signal Description," 
"District," "Offender Race," and "Offender Gender" that are blank should be 
excluded from this analysis, since they are potentially missing data values.
;

*Note that the below logistic regression model only includes class variables.;
%let y = victim_fatal_status;
%let pred1 = district;
%let pred2 = signal_description;
%let pred3 = offender_race;
%let pred4 = offender_gender;

proc logistic data=Police_reports_2016;
	class &y &pred1 &pred2 &pred3 &pred4;
	model &y = &pred1 &pred2 &pred3 &pred4;
run; 

******************************************************************************;
* Research Question Analysis Starting Point;
******************************************************************************;
*
Question: Are certain crimes more prevalent by race?

Rationale: This would help police know of any crimes that are committed more 
prevalently by race... OR it could indicate to the public that certain races 
are disproportionately charged more for certain crimes.

Note: This compares the column "Charge Description" and "Offender Race" 
from 2016 and 2017 Electronic Police Reports data sets.

Limitations: Values of "Charge Description" and "Offender Race" that are blank 
should be excluded from this analysis, since they are potentially missing data 
values.
;

proc freq data=Police_reports_2016;
	tables charge_description * offender_race;
run;
