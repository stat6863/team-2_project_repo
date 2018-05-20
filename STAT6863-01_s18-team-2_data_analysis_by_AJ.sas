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

Note: This compares the column "Time Dispatch" and "Initial Type Text" from 2016 and 2017 
Calls for Service data sets.

Limitations: Values of "Type Text" and "Time Create" that are blank should be 
excluded from this analysis, since they are potentially missing data values.
;

data adams_nopd_analytic_file;
	set nopd_analytic_file;
	dmonth=datepart(TimeDispatch);
	format dmonth mmddyy10.;
run;

proc freq data=adams_nopd_analytic_file noprint;
	tables dmonth / out=crime_perday;
run;

title "Frequency of Police Dispatches in New Orleans";
proc gplot data=crime_perday;
	plot count * dmonth / vaxis=500 to 1000 by 10;
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

proc logistic data=nopd_analytic_file;
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

proc freq data=nopd_analytic_file;
	tables charge_description * offender_race / chisq;
run;
