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


* set global system options;
options fullstimer;


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
    /*remove rows with missing unique id components; after executing this
      query, the new dataset Calls_for_Service_2017 will have no duplicate/
      repeated unique id values, and all unique id values will correspond to
      our experimental units of interest, which are calls made to the New 
      Orleans Police Department*/
    create table Calls_for_Service_2017 as
	select
            *
	from
	    Calls_for_Service_2017_raw
	where
	    /* remove rows with missing unique id value components */
	    not(missing(NOPD_Item))
    ;
quit;


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
* removes duplicate unique id values from Calls_for_Service_2016_raw;
proc sort
    nodupkey
    data = Calls_for_Service_2016_raw 
    dupout = Calls_for_Service_2016_raw_dups
    out = Calls_for_Service_2016_raw_sort
    ;
    by 
        NOPD_Item
    ;
run;
proc sql;
    /*remove rows with missing unique id components; after executing this
    query, the new dataset Calls_for_Service_2016 will have no duplicate/
    repeated unique id values, and all unique id values will correspond to
    our experimental units of interest, which are calls made to the New 
    Orleans Police Department*/
    create table Calls_for_Service_2016 as
		select
		    *
		from
		    Calls_for_Service_2016_raw_sort
		where
		    /* remove rows with missing unique id value components */
		    not(missing(NOPD_Item))
	;
quit;


*check Police_Reports_2017_raw for bad unique id values, where the column
Item_Number is the primary key;
proc sql;
    /* check for duplicate unique id values; after executing this query, we 
       see that Police_Reports_2017 contains rows which are duplicates,
       which we can mitigate as part of eliminating rows having duplicate 
		unique id component*/
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
* removes duplicate unique id values from Police_Reports_2017;
proc sort
    nodupkey
    data = Police_Reports_2017_raw 
    dupout = Police_Reports_2017_raw_dups
    out = Police_Reports_2017_raw_sort
    ;
    by 
        Item_Number
    ;
run;
proc sql;
    /*remove rows with missing unique id components; after executing this
      query, the new dataset Police_Reports_2017 will have no duplicate/
      repeated unique id values, and all unique id values will correspond to
      our experimental units of interest, which are reports filed to the New 
      Orleans Police Department*/
    create table Police_Reports_2017 as
    	select
	    	*
		from
	    	Police_Reports_2017_raw_sort
		where
	    /* remove rows with missing unique id value components */
	    	not(missing(Item_Number))
	;
quit;


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
* removes duplicate unique id values from Police_Reports_2016;
proc sort
    nodupkey
    data = Police_Reports_2016_raw 
    dupout = Police_Reports_2016_raw_dups
    out = Police_Reports_2016_raw_sort
    ;
    by 
        Item_Number
    ;
run;
proc sql;
    /*remove rows with missing unique id components; after executing this
      query, the new dataset Police_Reports_2016 will have no duplicate/
      repeated unique id values, and all unique id values will correspond to
      our experimental units of interest, which are reports filed to the New 
      Orleans Police Department*/
    create table Police_Reports_2016 as
        select
	    *
	from
	    Police_Reports_2016_raw_sort
	where
	    /* remove rows with missing unique id value components */
            not(missing(Item_Number))
	;
quit;

*inspect columns of interest in cleaned version of datasets;
/*
title "Zip in Calls_for_Service_2017";
proc sql;
    select
	min(Zip) as min
        ,max(Zip) as max
        ,mean(Zip) as max
        ,median(Zip) as max
        ,nmiss(Zip)as missing
    from
		Calls_for_Service_2017
	;
quit;
title;

title "Zip in Calls_for_Service_2016";
proc sql;
    select
		min(Zip) as min
        ,max(Zip) as max
        ,mean(Zip) as max
        ,median(Zip) as max
        ,nmiss(Zip)as missing
    from
		Calls_for_Service_2016
	;
quit;
title;

title "InitialTypeText in Calls_for_Service_2017";
proc sql;
    select
        nmiss(InitialTypeText)as missing
    from
		Calls_for_Service_2017
	;
quit;
title;

title "InitialTypeText in Calls_for_Service_2016";
proc sql;
    select
        nmiss(InitialTypeText)as missing
    from
		Calls_for_Service_2016
	;
quit;
title;

title "Time Dispatch in Calls_for_Service_2017";
proc sql;
    select
        nmiss(TimeDispatch)as missing
    from
		Calls_for_Service_2017
	;
quit;
title;

title "Time Dispatch in Calls_for_Service_2016";
proc sql;
    select
        nmiss(TimeDispatch)as missing
    from
		Calls_for_Service_2016
	;
quit;
title;

title "Time Arrive in Calls_for_Service_2017";
proc sql;
    select
        nmiss(TimeArrive)as missing
    from
		Calls_for_Service_2017
	;
quit;
title;

title "Time Arrive in Calls_for_Service_2016";
proc sql;
    select
        nmiss(TimeArrive)as missing
    from
		Calls_for_Service_2016
	;
quit;
title;

title "Priority Arrive in Calls_for_Service_2017";
proc sql;
    select
        nmiss(Priority)as missing
    from
		Calls_for_Service_2017
	;
quit;
title;

title "Priority Arrive in Calls_for_Service_2016";
proc sql;
    select
        nmiss(Priority)as missing
    from
		Calls_for_Service_2016
	;
quit;
title;

title "Offender Age in Police_Reports_2017";
proc sql;
    select
	min(Offender_Age) as min
        ,max(Offender_Age) as max
        ,mean(Offender_Age) as max
        ,median(Offender_Age) as max
        ,nmiss(Offender_Age)as missing
    from
		Police_Reports_2017
	;
quit;
title;

title "Offender Age in Police_Reports_2016";
proc sql;
    select
	min(Offender_Age) as min
        ,max(Offender_Age) as max
        ,mean(Offender_Age) as max
        ,median(Offender_Age) as max
        ,nmiss(Offender_Age)as missing
    from
		Police_Reports_2016
	;
quit;
title;

title "District in Police_Reports_2017";
proc sql;
    select
	min(District) as min
        ,max(District) as max
        ,mean(District) as max
        ,median(District) as max
        ,nmiss(District)as missing
    from
		Police_Reports_2017
	;
quit;
title;

title "District in Police_Reports_2016";
proc sql;
    select
	min(District) as min
        ,max(District) as max
        ,mean(District) as max
        ,median(District) as max
        ,nmiss(District)as missing
    from
		Police_Reports_2016
	;
quit;
title;
/*
title "Charge Description in Police_Reports_2017";
proc sql;
    select
        nmiss(Charge_Description)as missing
    from
		Police_Reports_2017
	;
quit;
title;

title "Charge Description in Police_Reports_2016";
proc sql;
    select
        nmiss(Charge_Description)as missing
    from
		Police_Reports_2016
	;
quit;
title;

title "Occured Date Time Description in Police_Reports_2017";
proc sql;
    select
        nmiss(Occurred_Date_Time)as missing
    from
		Police_Reports_2017
	;
quit;
title;

title "Occured Date Time Description in Police_Reports_2016";
proc sql;
    select
        nmiss(Occurred_Date_Time)as missing
    from
		Police_Reports_2016
	;
quit;
title;

title "Offender Race Description in Police_Reports_2017";
proc sql;
    select
        nmiss(Offender_Race)as missing
    from
		Police_Reports_2017
	;
quit;
title;

title "Offender Race Description in Police_Reports_2016";
proc sql;
    select
        nmiss(Offender_Race)as missing
    from
		Police_Reports_2016
	;
quit;
title;

title "Offender Gender Description in Police_Reports_2017";
proc sql;
    select
        nmiss(Offender_Gender)as missing
    from
		Police_Reports_2017
	;
quit;
title;

title "Offender Gender Description in Police_Reports_2016";
proc sql;
    select
        nmiss(Offender_Gender)as missing
    from
		Police_Reports_2016
	;
quit;
title;

title "Victim Gender Description in Police_Reports_2017";
proc sql;
    select
        nmiss(Victim_Gender)as missing
    from
		Police_Reports_2017
	;
quit;
title;

title "Victim Gender Description in Police_Reports_2016";
proc sql;
    select
        nmiss(Victim_Gender)as missing
    from
	Police_Reports_2016
	;
quit;
title;
/*
title "Victim Race Description in Police_Reports_2017";
proc sql;
    select
        nmiss(Victim_Race)as missing
    from
		Police_Reports_2017
	;
quit;
title;
/*
title "Victim Race Description in Police_Reports_2016";
proc sql;
    select
        nmiss(Victim_Race)as missing
    from
		Police_Reports_2016
	;
quit;
title;
*/

*combine Calls_for_Service_2017 and Calls_for_Service_2016 
horizontally usinga data-step match-merge. The data step took 2.21
real time seconds and  1005.15k memory to complete. The proc sort
step took 0.87 real time seconds and 164189.46k memory to complete

;

proc sort data = CALLS_FOR_SERVICE_2017;
    by NOPD_Item;
run;
data Calls_for_Service_1617_v1;
    retain
        NOPD_Item
		InitialTypeText
		Zip
		TimeDispatch
		TimeArrive
		;
    keep
		NOPD_Item
		InitialTypeText
		Zip
		TimeDispatch
		TimeArrive
		;
    merge
        Calls_for_Service_2016
		Calls_for_Service_2017
	;
    	by NOPD_Item;
run;
proc sort data = Calls_for_Service_1617_v1;
    by NOPD_Item;
run;

*combine Calls_for_Service_2017 and Calls_for_Service_2016 horizontally using 
proc sql. With a real time of 1.37 seconds and a memory of 103826.43k, the
proc sql took significantly more memory resources than the data step and proc sort
steps above combined. The real time use was less than the data step and proc sort
steps above. If the if memory performance isn't critical, proc sql should be
used.
;
proc sql;
    create table Calls_for_Service_1617_v2 as
	select
	    coalesce(A.NOPD_Item, B.NOPD_Item) as NOPD_Item
	    ,coalesce(A.InitialTypeText, B.InitialTypeText) as InitialTypeText
	    ,coalesce(A.Zip, B.Zip) as Zip
	    ,coalesce(A.TimeDispatch, B.TimeDispatch) as TimeDispatch
	    ,coalesce(A.TimeArrive, B.TimeArrive) as TimeArrive
	from
	    Calls_for_Service_2017 as A
	    full join
	    Calls_for_Service_2016 as B
	    on A.NOPD_Item = B.NOPD_Item
	order by
            NOPD_Item
	;
quit;
*verify that Calls_for_Service_1617_v1 and Calls_for_Service_1617_v2 are identical;
proc compare
    base = Calls_for_Service_1617_v1
	compare = Calls_for_Service_1617_v2
	novalues
	;
run;





*combine Calls_for_Service_2017 and Calls_for_Service_2016 
horizontally usinga data-step match-merge. The data step took 2.21
real time seconds and  1005.15k memory to complete. The proc sort
step took 0.87 real time seconds and 164189.46k memory to complete

;

proc sort data = CALLS_FOR_SERVICE_2017;
    by NOPD_Item;
run;
data Calls_for_Service_1617_v1;
    retain
        NOPD_Item
		InitialTypeText
		Zip
		TimeDispatch
		TimeArrive
		;
    keep
		NOPD_Item
		InitialTypeText
		Zip
		TimeDispatch
		TimeArrive
		;
    merge
        Calls_for_Service_2016
		Calls_for_Service_2017
	;
    	by NOPD_Item;
run;
proc sort data = Calls_for_Service_1617_v1;
    by NOPD_Item;
run;

*combine Calls_for_Service_2017 and Calls_for_Service_2016 horizontally using 
proc sql. With a real time of 1.37 seconds and a memory of 103826.43k, the
proc sql took significantly more memory resources than the data step and proc sort
steps above combined. The real time use was less than the data step and proc sort
steps above. If the if memory performance isn't critical, proc sql should be
used.
;
proc sql;
    create table Calls_for_Service_1617_v2 as
	select
	    coalesce(A.NOPD_Item, B.NOPD_Item) as NOPD_Item
	    ,coalesce(A.InitialTypeText, B.InitialTypeText) as InitialTypeText
	    ,coalesce(A.Zip, B.Zip) as Zip
	    ,coalesce(A.TimeDispatch, B.TimeDispatch) as TimeDispatch
	    ,coalesce(A.TimeArrive, B.TimeArrive) as TimeArrive
	from
	    Calls_for_Service_2017 as A
	    full join
	    Calls_for_Service_2016 as B
	    on A.NOPD_Item = B.NOPD_Item
	order by
            NOPD_Item
	;
quit;
*verify that Calls_for_Service_1617_v1 and Calls_for_Service_1617_v2 are identical;
proc compare
    base = Calls_for_Service_1617_v1
	compare = Calls_for_Service_1617_v2
	novalues
	;
run;
