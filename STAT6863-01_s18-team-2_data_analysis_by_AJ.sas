*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that will generate final analytic file;
%include '.\STAT6863-01_s18-team-2_data_preparation.sas';


******************************************************************************;
* Research Question Analysis Starting Point;
******************************************************************************;

title1 justify=left
'Question: How does the frequency of crime change over the course of a year?'
;

title2 justify=left
'Rationale: This should help police officers prepare for times of the year which have more crime.'
;

footnote1 justify=left
"We observe that the frequency of police dispatches follows a slight parabolic shape, increasing as the year goes on before peaking and falling down again. This trend appears to hold for both 2016 and 2017 data."
;

footnote2 justify=left
"Further investigation is needed as far as the possible reasons for this trend, for such efforts will aid in the decision of when to hire more police officers and/or have them on duty."
;

*
Methodology: Use a data step to create a new variable "dmonth" which contains 
just the date of when the call of the dispatch came. Then use proc freq to 
create an output data set that contains the counts of the calls for dispatch 
per date. Finally, use proc sgplot to create a line chart with the date as the 
x-axis and the call counts on the y-axis.

Follow-up: The plot can be broken down even further when we consider the counts 
of the calls by type of crime.

Note: This compares the column "Time Dispatch" and "Initial Type Text" from 
2016 and 2017 Calls for Service data sets.

Limitations: Values of "Initial Type Text" and "Time Dispatch" that are blank 
should be excluded from this analysis, since they are potentially missing data 
values.
;

data adams_nopd_analytic_file;
	set nopd_analytic_file;
	dmonth=datepart(TimeDispatch);
	format dmonth mmddyy10.;
run;

proc freq data=adams_nopd_analytic_file noprint;
	tables dmonth / out=calls_perday;
run;

proc sgplot data=calls_perday;
	series x = dmonth y = count;
	xaxis label = "date";
	yaxis values=(600 to 1200);
run;	

******************************************************************************;
* Research Question Analysis Starting Point;
******************************************************************************;

title1 justify=left
'Question: Can we predict the outcome of a fatality in New Orleans?'
;

title2 justify=left
'Rationale: This would help the police to identify which factors are significant in predicting a crime that ends in a fatality for the victim in New Orleans.'
;

footnote1 justify=left
'Using logistic regression analysis, we find that the model is significant with p = 0.0006. Both predictors police district (p = .0328) and the gender of the offender (p = .0265) were significant at the .05 level for predicting victim fatality.'
;

footnote2 justify=left
'In particular, police district 3 (p=.0260) and police district 5 (p=.0013) were found as statistically significant.'
; 

footnote3 justify=left
'Further investigation is required as far as why police districts 3 and 5 are predictive in whether a crime ends in a fatality for the victim.'
;

*
Methodology: Our factors and response variable are set as macro variables for 
easy model substitution and to aid readability. We use proc logistic along with 
the format for the "signal description" variable to model "victim fatal status."

Follow-up: Double-check analysis to account for the case when a particular 
offender is committing multiple crimes (as we assume that each of these crimes 
are independent).

Note: This compares the column "Victim Fatal Status" with the columns 
"District" and "Offender Gender" from the 2016 and 2017 Electronic Police 
Reports data set.

Limitations: Values of "Victim Fatal Status," "District," and "Offender Gender" 
that are blank should be excluded from this analysis, since they are 
potentially missing data values.
;

%let y = victim_fatal_status;
%let pred1 = district;
%let ref1 = 8;
%let pred2 = offender_gender;
%let ref2 = FEMALE;

proc logistic data=nopd_analytic_file;
	class &y &pred1 (ref="&ref1") &pred2 (ref="&ref2");
	model &y = &pred1 &pred2;
run; 

******************************************************************************;
* Research Question Analysis Starting Point;
******************************************************************************;

title1 justify=left
'Research question: Are certain crimes more prevalent by race?'
;

title2 justify=left
'Rationale: This would help police know of any crimes that are committed more prevalently by race... OR it could indicate to the public that certain races are disproportionately charged more for certain crimes.'
;

footnote1 justify=left
"After a chi-square analysis, we obtain a strong association (p < .001) between an offender's race and the type of crime committed."
;

footnote2 justify=left
'Notable cell contributors: whites were charged significantly less for property and violent crimes than expected. However, they were charged significantly more for white-collar and victimless crimes than expected. Hispanics were charged significantly more for violent crimes than expected.'
;

footnote3 justify=left
"If an observation was marked 'unknown' or 'American Indian' for the 'offender race' variable, it was removed from this analysis. The latter ('American Indian') was removed due to low cell counts."
;

*
Methodology: We use proc report to check the counts of the categorical levels 
when grouped by the formatted variable "signal description" for the purpose of 
checking whether certain categorical levels should be excluded from the analysis. 
Then we use proc freq on the two variables "signal description" and "offender 
race" to conduct a chi-square analysis to test if they are associated.

Follow-up: Double-check analysis to account for the case when a particular 
offender is committing multiple crimes (as we assume that each of these crimes 
are independent).

Note: This compares the column "Signal Description" and "Offender Race" 
from 2016 and 2017 Electronic Police Reports data sets.

Limitations: Values of "Signal Description" and "Offender Race" that are blank 
should be excluded from this analysis, since they are potentially missing data 
values.
;

/*proc report data=nopd_analytic_file;
	column signal_description offender_race N;
	define signal_description / group format=$signal.;
	define offender_race / group;
	define N / "Number of Crimes Charged";
run;*/

proc freq data=nopd_analytic_file;
	where offender_race in ('ASIAN', 'BLACK', 'HISPANIC', 'WHITE');
	tables signal_description * offender_race / chisq expected cellchi2;
	format signal_description $signal.;
run;
