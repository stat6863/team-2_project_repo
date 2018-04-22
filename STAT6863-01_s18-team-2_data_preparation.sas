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
%let inputDataset1DSN = Calls_for_Serivce_2017_raw;
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
%let inputDataset2DSN = Calls_for_Serivce_2016_raw;
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

[Unique ID Schema] The column Item_Number is the primary key, it’s the same as 
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

[Unique ID Schema] The column Item_Number is the primary key, it’s the same as 
the NOPD_Item column in Dataset 1 and Dataset 2. 
;
%let inputDataset4DSN = Police_Reports_2016_raw;
%let inputDataset4URL = https://github.com/stat6863/team-2_project_repo/blob/master/data/Electronic_Police_Report_2016.xlsx?raw=true
;
%let inputDataset4Type = XLSX;


* load raw datasets over the wire, if they doesn't already exist;

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

/* combines Calls_for_Serivce_2016_raw with 
	Calls_for_Serivce_2017_raw
	into one table CallsForService1617
*/

proc sql;
	create table CallsForService1617 as
	SELECT 
		Calls_for_Serivce_2016_raw.NOPD_Item,
		Calls_for_Serivce_2016_raw.TimeCreate,
		Calls_for_Serivce_2016_raw.TimeDispatch,
		Calls_for_Serivce_2016_raw.InitialTypeText,
		Calls_for_Serivce_2016_raw.Zip,
		Calls_for_Serivce_2016_raw.Type_
	FROM Calls_for_Serivce_2016_raw
	UNION
	SELECT
		Calls_for_Serivce_2017_raw.NOPD_Item,
		Calls_for_Serivce_2017_raw.TimeCreate,
		Calls_for_Serivce_2017_raw.TimeDispatch,
		Calls_for_Serivce_2017_raw.InitialTypeText,
		Calls_for_Serivce_2017_raw.Zip,
		Calls_for_Serivce_2017_raw.Type_
	FROM Calls_for_Serivce_2017_raw
	;
quit;
/* combines Police_reports_2016_raw with 
	Police_Reports_2017_raw
	into one table Police_Reports1617
*/

proc sql;
	create table Police_Reports1617 as
	SELECT 
		Police_reports_2016_raw.Item_Number,
		Police_reports_2016_raw.District,
		Police_reports_2016_raw.Offender_Age
	FROM Police_reports_2016_raw
	UNION
	SELECT
		Police_reports_2017_raw.Item_Number,
		Police_reports_2017_raw.District,
		Police_reports_2017_raw.Offender_Age
	FROM Police_reports_2017_raw
	;
quit;

/* Removes and sorts duplicates by primary ID 
	and type*/

proc sort
        nodupkey
        data=CallsForService1617
        dupout=CallsForService1617_raw_dups
        out=CallsForService1617_raw_sorted
    ;
    by
        NOPD_Item
        Type_
    ;
run;

/* Removes and sorts duplicates by primary ID*/

proc sort
        nodupkey
        data=Police_Reports1617
        dupout=Police_Reports1617_raw_dups
        out=Police_Reports1617_raw_sorted
    ;
    by
	Item_Number
    ;
run;



/* Removes rows with missing primary
ID: NOPD_Item for table CallsForService1617 */

proc sql;
	create table CallsForService1617 as
	SELECT * FROM CallsForService1617_raw_sorted
	WHERE
	not(missing(NOPD_Item))
	;
quit;
/* Removes rows with missing primary
ID: Item_Number for table Police_Reports1617*/
proc sql;
	create table Police_Reports1617 as
	SELECT * FROM Police_Reports1617_raw_sorted
	WHERE
	not(missing(Item_Number))
	;
quit;

/* Dataset weekday to be used for Q1 by LC. 
Changes datetime value to weekday name.
*/
proc sql;
	create table CallsForService1617Day as
	SELECT TimeCreate FROM CallsForService1617
	;
quit;
DATA weekday;
  SET CallsForService1617Day;
  Weekday=datepart(TimeCreate);
  format Weekday weekdate3.;
RUN;

