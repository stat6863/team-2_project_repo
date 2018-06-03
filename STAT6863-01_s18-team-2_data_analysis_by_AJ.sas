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

'Note: This compares the column "Time Dispatch" and "Initial Type Text" from 
2016 and 2017 Calls for Service data sets.

Limitations: Values of "Type Text" and "Time Dispatch" that are blank should be 
excluded from this analysis, since they are potentially missing data values.
;

data adams_nopd_analytic_file;
	set nopd_analytic_file;
	dmonth=datepart(TimeDispatch);
	format dmonth mmddyy10.;
run;

proc freq data=adams_nopd_analytic_file;
	tables dmonth / out=calls_perday;
run;

title "Daily Frequency of Police Dispatches in New Orleans";
proc sgplot data=calls_perday;
	series x = dmonth y = count;
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
'Using logistic regression analysis, we find that predictors "signal description" (p = .0008) and "offender gender" (p = .0167) are significant predictions of a victim fatality. Variable "district" was signicant at the alpha = .1 level (p = .0716).'
;

footnote2 justify=left
'The variable "signal description" was collapsed from over 100 factor levels to 5 levels based off of type of crime (violent, property, white-collar, victimless, and miscellaneous). The researcher correctly categorized these crimes to the best of his abilities.'
;

footnote3 justify=left
'Categorical levels "District 3" (p=.0131) and "District 5" (p=.0130) were found as statistically significant.'
; 

footnote4 justify=left
'Odds ratio estimates show that males have 3.5 times higher odds than females of being associated with a fatal victim. Both districts 3 and 5 have about roughly the same higher odds (OR = 10) of being associated with a fatal victim compared to district 8.'
;

footnote5 justify=left
'Further investigation is required as far as why districts 3 and 5 are predictive in whether a crime ends in a fatality for the victim.'
;

*
Note: This compares the column "Victim Fatal Status" with the columns 
"Signal Description," "District," "Offender Race," and "Offender Gender" from 
the 2016 and 2017 Electronic Police Reports data set. Diagnostic tests were 
not run on the logistic regression model.

Limitations: Values of "Victim Fatal Status," "Signal Description," 
"District," "Offender Race," and "Offender Gender" that are blank should be 
excluded from this analysis, since they are potentially missing data values.
;

*Note that the below logistic regression model only includes class variables.;
%let y = victim_fatal_status;
%let pred1 = district;
%let ref1 = 8;
%let pred2 = signal_description;
%let ref2 = Miscellaneous;
%let pred3 = offender_race;
%let ref3 = UNKNOWN;
%let pred4 = offender_gender;
%let ref4 = FEMALE;

*group factor levels together for variable "signal description";
proc format;
	value $signal 'AGGRAVATED ASSAULT', 'AGGRAVATED ASSAULT (DOMESTIC)', 
				'BOMB THREAT', 'AGGRAVATED BATTERY', 
				'AGGRAVATED BATTERY (CUTTING)', 'AGGRAVATED KIDNAPPING', 
				'ATTEMPTED SIMPLE KIDNAPPING', 'ATTEMPTED MURDER', 
				'ATTEMPTED MURDER (CUTTING)', 'ATTEMPTED MURDER (DOMESTIC)', 
				'ATTEMPTED MURDER (SHOOTING)', 'AUTO ACCIDENT (FATALITY)', 
				'DEATH', 'AGGRAVATED BATTERY (DOMESTIC)',
				'AGGRAVATED BATTERY (SHOOTING)', 'AUTO ACCIDENT (INJURY)', 
				'CRUELTY TO A JUVENILE', 'ATTEMPTED AGGRAVATED RAPE',
				'CRUELTY TO ANIMALS', 'AGGRAVATED RAPE', 
				'AGGRAVATED RAPE (MALE VICTIM)', 'AGGRAVATED RAPE UNFOUNDED', 
				'ATTEMPTED SEXUAL BATTERY', 'ATTEMPTED SIMPLE RAPE',
				'DISTURBANCE', 'DISTURBANCE (DOMESTIC)', 'DISTURBANCE (FIGHT)', 
				'DISTURBANCE (MENTAL)', 'DISTURBANCE (RIOT)', 'HOMICIDE', 
				'HOMICIDE (CUTTING)', 'HOMICIDE (DOMESTIC)', 
				'HOMICIDE (SHOOTING)', 'MISDEMEANOR SEXUAL BATTERY', 
				'SIMPLE ASSAULT', 'NEGLIGENT INJURING',	'SEXUAL BATTERY', 
				'SIMPLE ASSAULT	(DOMESTIC)', 'SIMPLE BATTERY', 
				'SIMPLE BATTERY (DOMESTIC)', 'SIMPLE KIDNAPPING', 'SIMPLE RAPE', 
				'SIMPLE RAPE (MALE VICTIM)', 'SIMPLE RAPE UNFOUNDED', 
				'THREATS', 'THREATS (DOMESTIC)', 'RESISTING ARREST',
				'ARMED ROBBERY', 'ARMED ROBBERY (GUN)', 'ARMED ROBBERY (KNIFE)',
				'ATTEMPTED ARMED CARJACKING', 'ATTEMPTED ARMED ROBBERY', 
				'ATTEMPTED ARMED ROBBERY (KNIFE)', 'ATTEMPTED SIMPLE ROBBERY', 
				'ATTEMPTED SIMPLE ROBBERY (PURSESNATCHING)', 
				'ATTEMPTED ARMED ROBBERY (GUN)'
				= 'Violent'
				'AGGRAVATED ARSON', 'SIMPLE ARSON', 'SIMPLE ARSON (DOMESTIC)', 
				'ATTEMPTED AGGRAVATED ARSON', 'ATTEMPTED SIMPLE ARSON',
				'ASSET SEIZURE', 'ATTEMPTED AUTO THEFT', 
				'ATTEMPTED BICYCLE THEFT', 'ATTEMPTED PICKPOCKET',
				'ATTEMPTED SHOPLIFITING', 'ATTEMPTED THEFT', 
				'ATTEMPTED THEFT FROM EXTERIOR OF VEHICLE', 
				'ATTEMPTED UNARMED CARJACKING', 'AUTO THEFT', 
				'AUTO THEFT & RECOVERY', 'BICYCLE THEFT', 
				'AGGRAVATED CRIMINAL DAMAGE', 'ARMED CARJACKING', 
				'AGGRAVATED BURGLARY', 'ATTEMPTED AGGRAVATED BURGLARY', 
				'ATTEMPTED SIMPLE BURGLARY', 
				'ATTEMPTED SIMPLE BURGLARY (RESIDENCE)',
				'ATTEMPTED SIMPLE BURGLARY (BUSINESS)', 
				'ATTEMPTED SIMPLE BURGLARY (VEHICLE)', 
				'DESECRATION OF GRAVES and sites', 'HIT AND RUN', 'PICKPOCKET', 
				'POSSESSION OF STOLEN PROPERTY', 'PROPERTY SNATCHING', 
				'SHOPLIFTING', 'SIMPLE BURGLARY', 'SIMPLE BURGLARY (BUSINESS)', 
				'SIMPLE BURGLARY (DOMESTIC)', 'SIMPLE BURGLARY (RESIDENCE)', 
				'SIMPLE BURGLARY (VEHICLE)', 'SIMPLE CRIMINAL DAMAGE', 
				'SIMPLE CRIMINAL DAMAGE (DOMESTIC)', 'SIMPLE ROBBERY', 'THEFT', 
				'THEFT FROM EXTERIOR OF VEHICLE', 'UNARMED CARJACKING', 
				'BLIGHTED PROPERTY', 'LOST PROPERTY'
				= 'Property'
				'ATTEMPTED EMBEZZLEMENT', 'EMBEZZLEMENT', 'FORGERY',
				'ATTEMPTED FORGERY', 'ATTEMPTED FRAUD', 
				'ISSUING WORTHESS CHECKS', 'THEFT BY FRAUD'
				= 'White-collar'
				'ATTEMPTED SIMPLE ESCAPE', 'CARNAL KNOWLEDGE OF A JUVENILE', 
				'CONTRIBUTING TO THE DELINQUENCY OF A MINOR', 
				'CRIMINAL MISCHIEF', 'CRIMINAL MISCHIEF (DOMESTIC)', 
				'CURFEW VIOLATION', 'DIRECTED TRAFFIC ENFORCEMENT', 
				'DRIVING WHILE INTOXICATED', 'DRUG LAW VIOLATION', 
				'ELECTRONIC MONITORING', 'FIRE', 'FUGITIVE ATTACHMENT',
				'GAMBLING', 'HOMELESS', 'ILLEGAL CARRYING OF A GUN', 
				'ILLEGAL CARRYING OF A KNIFE', 'ILLEGAL CARRYING OF A WEAPON', 
				'IMPERSONATING A POLICE OFFICER', 'ILLEGAL USE OF WEAPONS',
				'INDECENT BEHAVIOR WITH A JUVENILE', 
				'INDECENT BEHAVIOR WITH A JUVENILE UNFOUNDED', 
				'JUVENILE ATTACHMENT', 'MISSING ADULT', 
				'MISSING/RUNAWAY JUVENILE',	'MUNICIPAL COURT ATTACHEMENT', 
				'OBSCENITY', 'OUT OF PARISH VEHICLE RECOVERY', 'PANDERING', 
				'PEEPING TOM', 'PROSTITUTION', 'PROTEST', 'PUBLIC DRUNK', 
				'QUALITY OF LIFE', 'RECKLESS DRIVING', 
				'SEX OFFENDER COMPLIANCE CHECK', 'SEXTING', 'SIMPLE ESCAPE', 
				'SOLICITING FOR PROSTITUTION', 'SUICIDE', 'TRAFFIC ATTACHMENT', 
				'TRAFFIC INCIDENT', 'TRESPASSING', 'TRUANT VIOLATION', 
				'UNAUTHORIZED USE OF MOVABLES',	'UNDERAGE DRINKING', 
				'VIDEO VOYEURISM', 'VIOLATION OF PROTECTIVE ORDERS', 
				'WARRANT STOP AND RELEASE', 'ATTEMPTED SUICIDE'
				= 'Victimless'
				'ABANDONED VEHICLE', 'MISCELLANEOUS INCIDENT', 'EXPLOSION', 
				'MEDICAL', 'AIRPLANE CRASH', 
				'ATTEMPTED AGGRAVATED RAPE (MALE VICTIM)', 
				'MEDICAL SEXUAL ASSAULT KIT PROCESSING', 
				'UNATTENDED PACKAGE', 'UNCLASSIFIED DEATH',
				'SUSPICIOUS PACKAGE', 'SUSPICIOUS PERSON'
				= 'Miscellaneous';
run;

proc logistic data=nopd_analytic_file;
	format &pred2 $signal.;
	class &y &pred1 (ref="&ref1") &pred2 (ref="&ref2") &pred3 (ref="&ref3")
		  &pred4 (ref="&ref4");
	model &y = &pred1 &pred2 &pred3 &pred4;
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
'After a chi-square analysis, we obtain a strong association (p < .001) between the two variables "signal description" and "offender race."'
;

footnote2 justify=left
'Notable cell contributors: whites were charged significantly less for property and violent crimes than expected. However, they were charged significantly more for white-collar and victimless crimes than expected. Hispanics were charged significantly more for violent crimes than expected.'
;

footnote3 justify=left
'The factor levels used for the variable "signal description" was the same as for the logistic regression analysis above.'
;

footnote4 justify=left
'If an observation was marked "unknown" or "American Indian" for the "offender race" variable, it was removed from this analysis. The latter ("American Indian") was removed due to low cell counts.'
;

*
Note: This compares the column "Charge Description" and "Offender Race" 
from 2016 and 2017 Electronic Police Reports data sets.

Limitations: Values of "Charge Description" and "Offender Race" that are blank 
should be excluded from this analysis, since they are potentially missing data 
values.
;

proc freq data=nopd_analytic_file;
	where offender_race in ('ASIAN', 'BLACK', 'HISPANIC', 'WHITE');
	tables signal_description * offender_race / chisq expected cellchi2;
	format signal_description $signal.;
run;
