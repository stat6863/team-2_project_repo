*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
[Dataset 1 Name] Calls for Service 2017

[Dataset Description] Incidents that have been reported to the New Orleans 
Police Department in 2017 

[Experimental Unit Description] Calls made to the New Orleans Police Department 
in 2017

[Number of Observations] 444,111

[Number of Features] 21

[Data Source] The file was downloaded from https://data.nola.gov/api/views/bqmt-f3jk/rows.csv?accessType=DOWNLOAD
and saved in an xlsx format to produce file Calls_for_Serivce_2017.xlsx

[Data Dictionary] https://data.nola.gov/api/views/bqmt-f3jk/files/1db89864-2d0f-4734-8417-ce3b3ec0ecb8?download=true&filename=NOPD%20-%20Data%20dictionary%20for%20Calls%20For%20Service%20Open%20Data.xlsx

[Unique ID Schema] The column NOPD_Item is the primary key
;
%let inputDataset1DSN = Calls_for_Service_2017_raw;
%let inputDataset1URL =
https://github.com/stat6863/team-2_project_repo/blob/master/data/Calls_for_Service_2017.xlsx?raw=true
;
%let inputDataset1Type = XLSX;


*
[Dataset 2 Name] Calls for Service 2016

[Dataset Description] Incidents that have been reported to the New Orleans 
Police Department in 2016

[Experimental Unit Description] Calls made to the New Orleans Police Department 
in 2016

[Number of Observations] 404,065

[Number of Features] 21

[Data Source] The file was downloaded from https://data.nola.gov/api/views/wgrp-d3ma/rows.csv?accessType=DOWNLOAD
and saved in an xlsx format to produce file Calls_for_Serivce_2016.xlsx

[Data Dictionary] https://data.nola.gov/api/views/bqmt-f3jk/files/1db89864-2d0f-4734-8417-ce3b3ec0ecb8?download=true&filename=NOPD%20-%20Data%20dictionary%20for%20Calls%20For%20Service%20Open%20Data.xlsx

[Unique ID Schema] The column NOPD_Item is the primary key
;
%let inputDataset2DSN = Calls_for_Service_2016_raw;
%let inputDataset2URL = https://github.com/stat6863/team-2_project_repo/blob/master/data/Calls_for_Service_2016.xlsx?raw=true
;
%let inputDataset2Type = XLSX;


*
[Dataset 3 Name] Electronic Police Report 2017

[Dataset Description] Police reports that have been filed by New Orleans police 
officers in 2017

[Experimental Unit Description] Reports filed by the New Orleans Police 
Department in 2017

[Number of Observations] 128,243

[Number of Features] 19

[Data Source] The file was downloaded from https://data.nola.gov/api/views/qtcu-97s9/rows.csv?accessType=DOWNLOAD
and saved in an xlsx format to produce file Electronic_Police_Report_2017.xlsx
 
[Data Dictionary] https://data.nola.gov/Public-Safety-and-Preparedness/Electronic-Police-Report-2017/qtcu-97s9

[Unique ID Schema] The column Item_Number is the primary key, it is the same as 
the NOPD_Item column in Dataset 1 and Dataset 2. 
;
%let inputDataset3DSN = Police_Reports_2017_raw;
%let inputDataset3URL = https://github.com/stat6863/team-2_project_repo/blob/master/data/Electronic_Police_Report_2017.xlsx?raw=true
;
%let inputDataset3Type = XLSX;


*
[Dataset 4 Name] Electronic Police Report 2016

[Dataset Description] Police reports that have been filed by New Orleans police 
officers in 2016

[Experimental Unit Description] Reports filed by the New Orleans Police 
Department in 2016

[Number of Observations] 115,595

[Number of Features] 19

[Data Source] The file was downloaded from https://data.nola.gov/api/views/4gc2-25he/rows.csv?accessType=DOWNLOAD
and saved in an xlsx format to produce file Electronic_Police_Report_2016.xlsx
 
[Data Dictionary] https://data.nola.gov/Public-Safety-and-Preparedness/Electronic-Police-Report-2016/4gc2-25he

[Unique ID Schema] The column Item_Number is the primary key, it is the same as 
the NOPD_Item column in Dataset 1 and Dataset 2. 
;
%let inputDataset4DSN = Police_Reports_2016_raw;
%let inputDataset4URL = https://github.com/stat6863/team-2_project_repo/blob/master/data/Electronic_Police_Report_2016.xlsx?raw=true
;
%let inputDataset4Type = XLSX;


*set global system options;
options fullstimer;

*group factor levels together for variable "signal description";
proc format;
	value $signal 
		'AGGRAVATED ASSAULT', 
		'AGGRAVATED ASSAULT (DOMESTIC)', 
		'BOMB THREAT', 
		'AGGRAVATED BATTERY', 
		'AGGRAVATED BATTERY (CUTTING)', 
		'AGGRAVATED KIDNAPPING', 
		'ATTEMPTED SIMPLE KIDNAPPING', 
		'ATTEMPTED MURDER', 
		'ATTEMPTED MURDER (CUTTING)', 
		'ATTEMPTED MURDER (DOMESTIC)', 
		'ATTEMPTED MURDER (SHOOTING)', 
		'AUTO ACCIDENT (FATALITY)', 
		'DEATH', 
		'AGGRAVATED BATTERY (DOMESTIC)',
		'AGGRAVATED BATTERY (SHOOTING)', 
		'AUTO ACCIDENT (INJURY)', 
		'CRUELTY TO A JUVENILE', 
		'ATTEMPTED AGGRAVATED RAPE',
		'CRUELTY TO ANIMALS', 
		'AGGRAVATED RAPE', 
		'AGGRAVATED RAPE (MALE VICTIM)', 
		'AGGRAVATED RAPE UNFOUNDED', 
		'ATTEMPTED SEXUAL BATTERY', 
		'ATTEMPTED SIMPLE RAPE',
		'DISTURBANCE', 
		'DISTURBANCE (DOMESTIC)', 
		'DISTURBANCE (FIGHT)', 
		'DISTURBANCE (MENTAL)', 
		'DISTURBANCE (RIOT)', 
		'HOMICIDE', 
		'HOMICIDE (CUTTING)', 
		'HOMICIDE (DOMESTIC)', 
		'HOMICIDE (SHOOTING)', 
		'MISDEMEANOR SEXUAL BATTERY', 
		'SIMPLE ASSAULT', 
		'NEGLIGENT INJURING',	
		'SEXUAL BATTERY', 
		'SIMPLE ASSAULT (DOMESTIC)', 
		'SIMPLE BATTERY', 
		'SIMPLE BATTERY (DOMESTIC)', 
		'SIMPLE KIDNAPPING', 
		'SIMPLE RAPE', 
		'SIMPLE RAPE (MALE VICTIM)', 
		'SIMPLE RAPE UNFOUNDED', 
		'THREATS', 
		'THREATS (DOMESTIC)', 
		'RESISTING ARREST',
		'ARMED ROBBERY', 
		'ARMED ROBBERY (GUN)', 
		'ARMED ROBBERY (KNIFE)',
		'ATTEMPTED ARMED CARJACKING', 
		'ATTEMPTED ARMED ROBBERY', 
		'ATTEMPTED ARMED ROBBERY (KNIFE)', 
		'ATTEMPTED SIMPLE ROBBERY', 
		'ATTEMPTED SIMPLE ROBBERY (PURSESNATCHING)', 
		'ATTEMPTED ARMED ROBBERY (GUN)', 
		'ATTEMPTED AGGRAVATED RAPE (MALE VICTIM)'
		= 'Violent'
		'AGGRAVATED ARSON', 
		'SIMPLE ARSON', 
		'SIMPLE ARSON (DOMESTIC)', 
		'ATTEMPTED AGGRAVATED ARSON', 
		'ATTEMPTED SIMPLE ARSON',
		'ASSET SEIZURE', 
		'ATTEMPTED AUTO THEFT', 
		'ATTEMPTED BICYCLE THEFT', 
		'ATTEMPTED PICKPOCKET',
		'ATTEMPTED SHOPLIFITING', 
		'ATTEMPTED THEFT', 
		'ATTEMPTED THEFT FROM EXTERIOR OF VEHICLE', 
		'ATTEMPTED UNARMED CARJACKING', 
		'AUTO THEFT', 
		'AUTO THEFT & RECOVERY', 
		'BICYCLE THEFT', 
		'AGGRAVATED CRIMINAL DAMAGE', 
		'ARMED CARJACKING', 
		'AGGRAVATED BURGLARY', 
		'ATTEMPTED AGGRAVATED BURGLARY', 
		'ATTEMPTED SIMPLE BURGLARY', 
		'ATTEMPTED SIMPLE BURGLARY (RESIDENCE)',
		'ATTEMPTED SIMPLE BURGLARY (BUSINESS)', 
		'ATTEMPTED SIMPLE BURGLARY (VEHICLE)', 
		'DESECRATION OF GRAVES and sites', 
		'HIT AND RUN', 
		'PICKPOCKET', 
		'POSSESSION OF STOLEN PROPERTY', 
		'PROPERTY SNATCHING', 
		'SHOPLIFTING', 
		'SIMPLE BURGLARY', 
		'SIMPLE BURGLARY (BUSINESS)', 
		'SIMPLE BURGLARY (DOMESTIC)', 
		'SIMPLE BURGLARY (RESIDENCE)', 
		'SIMPLE BURGLARY (VEHICLE)', 
		'SIMPLE CRIMINAL DAMAGE', 
		'SIMPLE CRIMINAL DAMAGE (DOMESTIC)', 
		'SIMPLE ROBBERY', 
		'THEFT', 
		'THEFT FROM EXTERIOR OF VEHICLE', 
		'UNARMED CARJACKING', 
		'BLIGHTED PROPERTY', 
		'LOST PROPERTY'
		= 'Property'
		'ATTEMPTED EMBEZZLEMENT', 
		'EMBEZZLEMENT', 
		'FORGERY',
		'ATTEMPTED FORGERY', 
		'ATTEMPTED FRAUD', 
		'ISSUING WORTHESS CHECKS', 
		'THEFT BY FRAUD'
		= 'White-collar'
		'ATTEMPTED SIMPLE ESCAPE', 
		'CARNAL KNOWLEDGE OF A JUVENILE', 
		'CONTRIBUTING TO THE DELINQUENCY OF A MINOR', 
		'CRIMINAL MISCHIEF', 
		'CRIMINAL MISCHIEF (DOMESTIC)', 
		'CURFEW VIOLATION', 
		'DIRECTED TRAFFIC ENFORCEMENT', 
		'DRIVING WHILE INTOXICATED', 
		'DRUG LAW VIOLATION', 
		'ELECTRONIC MONITORING', 
		'FIRE', 
		'FUGITIVE ATTACHMENT',
		'GAMBLING', 
		'HOMELESS', 
		'ILLEGAL CARRYING OF A GUN', 
		'ILLEGAL CARRYING OF A KNIFE', 
		'ILLEGAL CARRYING OF A WEAPON', 
		'IMPERSONATING A POLICE OFFICER', 
		'ILLEGAL USE OF WEAPONS',
		'INDECENT BEHAVIOR WITH A JUVENILE', 
		'INDECENT BEHAVIOR WITH A JUVENILE UNFOUNDED', 
		'JUVENILE ATTACHMENT', 
		'MISSING ADULT', 
		'MISSING/RUNAWAY JUVENILE',	
		'MUNICIPAL COURT ATTACHEMENT', 
		'OBSCENITY', 
		'OUT OF PARISH VEHICLE RECOVERY', 
		'PANDERING', 
		'PEEPING TOM', 
		'PROSTITUTION', 
		'PROTEST', 
		'PUBLIC DRUNK', 
		'QUALITY OF LIFE', 
		'RECKLESS DRIVING', 
		'SEX OFFENDER COMPLIANCE CHECK', 
		'SEXTING', 
		'SIMPLE ESCAPE', 
		'SOLICITING FOR PROSTITUTION', 
		'SUICIDE', 
		'TRAFFIC ATTACHMENT', 
		'TRAFFIC INCIDENT', 
		'TRESPASSING', 
		'TRUANT VIOLATION', 
		'UNAUTHORIZED USE OF MOVABLES',	
		'UNDERAGE DRINKING', 
		'VIDEO VOYEURISM', 
		'VIOLATION OF PROTECTIVE ORDERS', 
		'WARRANT STOP AND RELEASE', 
		'ATTEMPTED SUICIDE', 
		'SUSPICIOUS PERSON'
		= 'Victimless'
		'ABANDONED VEHICLE', 
		'MISCELLANEOUS INCIDENT', 
		'EXPLOSION', 
		'MEDICAL', 
		'AIRPLANE CRASH', 
		'MEDICAL SEXUAL ASSAULT KIT PROCESSING', 
		'UNATTENDED PACKAGE', 
		'UNCLASSIFIED DEATH',
		'SUSPICIOUS PACKAGE'
		= 'Miscellaneous';
run;

*load raw datasets over the wire, if they doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename
                tempfile
                "%sysfunc(getoption(work))/tempfile.xlsx."
            ;
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%macro loadDatasets;
    %do i = 1 %to 4;
        %loadDataIfNotAlreadyAvailable(
            &&inputDataset&i.DSN.,
            &&inputDataset&i.URL.,
            &&inputDataset&i.Type.
        )
    %end;
%mend;
%loadDatasets


*check Calls_for_Service_2017_raw for bad unique id values, where the column
 NOPD_Item is the primary key;
proc sql;
    /* check for duplicate unique id values; after executing this query, we 
       see that Calls_for_Service_2017 contains no rows, so no mitigation is
       needed to ensure uniqueness */
    create table Calls_for_Service_2017_dups as
        select
            NOPD_Item
            ,count(*) as row_count_for_unique_id_values
        from 
            Calls_for_Service_2017_raw
        group by
            NOPD_Item
        having
            row_count_for_unique_id_values > 1
    ;
quit;

*removes rows with missing and duplicate unique id components, after 
 executing this query, the new dataset Calls_for_Service_2017 will have no 
 duplicate/repeated unique id values, and all unique id values will correspond
 to our experimental units of interest, which are calls made to the New 
 Orleans Police Department;
proc sort
    nodupkey
    data = Calls_for_Service_2017_raw(where=(not(missing(NOPD_Item))))
    dupout = Calls_for_Service_2017_raw_dups
    out = Calls_for_Service_2017
    ;
    by 
        NOPD_Item
    ;
run;



*check Calls_for_Service_2016_raw for bad unique id values, where the column
 NOPD_Item is the primary key;
proc sql;
    /* check for duplicate unique id values; after executing this query, we 
       see that Calls_for_Service_2016 contains rows which are duplicates,
       which we can mitigate as part of eliminating rows having duplicate unique 
       id component*/
    create table Calls_for_Service_2016_dups as
        select
            NOPD_Item
            ,count(*) as row_count_for_unique_id_values
        from 
            Calls_for_Service_2016_raw
        group by
            NOPD_Item
        having
            row_count_for_unique_id_values > 1
    ;
quit;

*removes rows with missing and duplicate unique id components, after 
 executing this query, the new dataset Calls_for_Service_2016 will have no 
 duplicate/repeated unique id values, and all unique id values will correspond
 to our experimental units of interest, which are calls made to the New 
 Orleans Police Department;
proc sort
    nodupkey
    data = Calls_for_Service_2016_raw(where=(not(missing(NOPD_Item))))
    dupout = Calls_for_Service_2016_raw_dups
    out = Calls_for_Service_2016
    ;
    by 
        NOPD_Item
    ;
run;

*check Police_Reports_2017_raw for bad unique id values, where the column
 Item_Number is the primary key;
proc sql;
    /* check for duplicate unique id values; after executing this query, we 
       see that Police_Reports_2017 contains rows which are duplicates,
       which we can mitigate as part of eliminating rows having duplicate unique 
       id component*/
    create table Police_Reports_2017_dups as
        select
            Item_Number
            ,count(*) as row_count_for_unique_id_values
        from 
            Police_Reports_2017_raw
        group by
            Item_Number
        having
            row_count_for_unique_id_values > 1
    ;
quit;

*removes rows with missing and duplicate unique id components, after 
 executing this query, the new dataset Police_Reports_2017 will have no 
 duplicate/repeated unique id values, and all unique id values will correspond
 to our experimental units of interest, which are reports filed by the New 
 Orleans Police Department;
proc sort
    nodupkey
    data = Police_Reports_2017_raw(where=(not(missing(Item_Number))))
    dupout = Police_Reports_2017_raw_dups
    out = Police_Reports_2017
    ;
    by 
        Item_Number
    ;
run;


*check Police_Reports_2016_raw for bad unique id values, where the column
 Item_Number is the primary key;
proc sql;
    /* check for duplicate unique id values; after executing this query, we 
       see that Police_Reports_2016 contains rows which are duplicates,
       which we can mitigate as part of eliminating rows having duplicate unique 
       id component*/
    create table Police_Reports_2016_dups as
        select
            Item_Number
            ,count(*) as row_count_for_unique_id_values
        from 
            Police_Reports_2016_raw
        group by
            Item_Number
        having
            row_count_for_unique_id_values > 1
    ;
quit;

*removes rows with missing and duplicate unique id components, after 
 executing this query, the new dataset Police_Reports_2016 will have no 
 duplicate/repeated unique id values, and all unique id values will correspond
 to our experimental units of interest, which are reports filed by the New 
 Orleans Police Department;
proc sort
    nodupkey
    data = Police_Reports_2016_raw(where=(not(missing(Item_Number))))
    dupout = Police_Reports_2016_raw_dups
    out = Police_Reports_2016
    ;
    by 
        Item_Number
    ;
run;

* build analytic dataset from raw datasets imported above, including only the
  columns and minimal data-cleaning/transformation needed to address each
  research questions/objectives in data-analysis files;
proc sql;
    create table nopd_analytic_file_raw as
        select
            coalesce(A.NOPD_Item,B.NOPD_Item,C.NOPD_Item,D.NOPD_Item)
            AS NOPD_Item format $10.
	    label "NOPD Item"
            ,coalesce(A.InitialTypeText,B.InitialTypeText) 
	    AS InitialTypeText format $20.
            ,coalesce(A.TimeDispatch,B.TimeDispatch) 
	    AS TimeDispatch format datetime18.
	    label "Time of dispatch"
            ,coalesce(A.Zip,B.Zip) 
	    AS Zip
            ,coalesce(C.Offender_Age,D.Offender_Age) 
	    AS Offender_Age
	    label "Age of offender"
            ,coalesce(C.District,D.District) 
	    AS District
            ,coalesce(C.Victim_Fatal_Status,D.Victim_Fatal_Status) 
            AS Victim_Fatal_Status
            ,coalesce(C.Signal_Description,D.Signal_Description) 
            AS Signal_Description
            ,coalesce(C.Offender_Race,D.Offender_Race) 
	    AS Offender_Race
            ,coalesce(C.Offender_Gender,D.Offender_Gender) 
	    AS Offender_Gender
        from
            (
                select
                    NOPD_Item
                    ,InitialTypeText
                    ,TimeDispatch
                    ,Zip
                from
                    Calls_for_service_2016
            ) as A
            full join
            (
                select
                    NOPD_Item
                    ,InitialTypeText
                    ,TimeDispatch
                    ,Zip
                from
                    Calls_for_service_2017
            ) as B
            on A.NOPD_Item = B.NOPD_Item
            full join
            (
                select
                    compress(Item_Number,"-")
                    AS NOPD_Item
                    ,District
                    ,Offender_Age
                    ,Victim_Fatal_Status
                    ,Signal_Description
                    ,Offender_Race
                    ,Offender_Gender
                from
                    Police_reports_2016
            ) as C
            on A.NOPD_Item = C.NOPD_Item
            full join
            (
                select
                    compress(Item_Number,"-")
                    AS NOPD_Item
                    ,District
                    ,Offender_Age
                    ,Victim_Fatal_Status
                    ,Signal_Description
                    ,Offender_Race
                    ,Offender_Gender
                from
                    Police_reports_2017
            ) as D
            on B.NOPD_Item = D.NOPD_Item
    order by
        NOPD_Item
    ;
quit;

* check nopd_analytic_file_raw for rows whose unique id values are repeated,
  missing, or correspond to non-crimes, where the column NOPD_Item is intended
  to be a primary key;
data nopd_analytic_file_raw_bad_ids;
    set nopd_analytic_file_raw;
    by NOPD_Item;

    if
        first.NOPD_Item*last.NOPD_Item = 0
        or
        missing(NOPD_Item)
    then
        do;
            output;
        end;
run;

* remove duplicates from nopd_analytic_file_raw with respect to NOPD_Item;
proc sort
        nodupkey
        data=nopd_analytic_file_raw
        out=nopd_analytic_file
    ;
    by
        NOPD_Item
    ;
run;
