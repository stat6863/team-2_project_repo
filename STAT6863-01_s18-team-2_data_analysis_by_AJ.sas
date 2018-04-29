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

Rationale: This should help police officers and the public to prepare for 
certain crimes being committed because of possible weather influences (i.e., 
the season).

Note: This compares the column "Charge_Description" and 
"Occured_Date Time" from 2016 and 2017 data sets of Electronic Police Report.

Limitations: Values of Charge Description and Occurred Date Time that are 
blank should be excluded from this analysis, since they are potentially 
missing data values.
;

PROC SQL;
	create table ElectronicPoliceReport1617season as
	SELECT Occurred_Date_Time FROM Police_reports_1617_v2
	;
quit;

DATA datemonth;
	set Police_reports_1617_v2;
	dmonth=datepart(Occurred_Date_Time);
	format dmonth mmddyy10.;
run;



*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Can we predict how quickly an officer arrives to a scene after he has 
been dispatched?

Rationale: This would help the public become better educated on how long they can 
expect to wait for an officer to arrive to a current/potential crime scene.

Note: This compares the columns "TimeDispatch" and "TimeArrive" from 
Calls_for_Service_2016 and Calls_for_Service_2017 with any other column that is 
an explanatory variable from all datasets. They can be combined since the variable 
"NOPD Item" from Calls_for_Service2016/7 matches with the "Item Number" 
from Electronic_Police_Report_2016/7.

Limitations: Values of Time Dispatch and Time Arrive, along with any other 
appropriate column, that are blank should be excluded from this analysis, 
since they are potentially missing data values.
;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Is there a correlation between a victim's/offender's race/gender with 
the type of priority for the call?

Rationale: This would help the police to become better aware of who they are 
dealing with when they get a priority call based on a certain level

Note: This compares the column "Priority" from Calls_for_Service with the 
columns "Offender Race," "Offender Gender," "Victim Race," and "Victim Gender" 
from Electronic_Police_Report.

Limitations: Values of Priority and Offender Race, Offender Gender, Victim Race, 
and Victim Gender that are blank should be excluded from this analysis, 
since they are potentially missing data values.
;

PROC reg data=police
