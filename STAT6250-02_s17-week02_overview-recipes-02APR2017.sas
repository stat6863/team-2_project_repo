*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;


*******************************************************************************;
* basic_recipe_for_loading_data_from_remote_Excel_file ;
*******************************************************************************;
/*
Scenario: Data exists in an Excel file on a remote server and is accessible
through a web server (i.e., with a URL beginning with "http" or "https")

Approach: Create a temporary holding place to save a copy of the Excel file,
download the Excel file into the temporary holding place, transform a specific
worksheet in the Excel file into a SAS dataset (where the worksheet is assumed
to have a "rectangular shape" with column names in Row 1), and delete the
temporary holding place.

Recipe <with everything in square brackets to be filled in for actual use; the
only parts that can be left out, if not needed, are the replace option and the
sheet statement in proc import>:

filename <filename1: 8-character filename> TEMP;
proc http
    method="get" 
    url="<URL for Excel file on web server>" 
    out=<filename1: 8-character filename>
    ;
run;
proc import
        file=<filename1: 8-character filename>
        out=<output dataset name>
        dbms=<choose one: xls|xlsx>
        replace
    ;
    sheet="<Excel file worksheet name to load; can be excluded in most cases>";
run;
filename <filename1: 8-character filename> clear;
*/

*Example (which can be run as is to create Work.FRPM1516_raw);
filename tempfile TEMP;
proc http
    method="get"
    url="https://github.com/stat6250/team-0_project1/blob/master/frpm1516-edited.xls?raw=true"
    out=tempfile
    ;
run;
proc import
    file=tempfile
    out=frpm_raw
    dbms=xls;
run;
filename tempfile clear;
/*
Notes:
(1) In this example, a .xls file is loaded from GitHub and the first (i.e.,
left-most) worksheet is loaded (since the optional sheet statement is left out).
(2) In addition, the "replace" option has been excluded in order to prevent a
pre-existing dataset already named "FRPM1516_raw" in the Work library from
being overwritten.
(3) Data are frequently stored in Excel files, so proc import is one of the
most important procs to learn. In addition, it's common to load raw data (e.g.,
data obtained in comma-separated values format or tab-separated values format)
into Excel and saving it as an Excel file after performing light data-cleaning.
(4) Loading datasets from a web server like GitHub highly recommended when
preparing examples for a work-sample portfolio; in other words, by pulling data
"over the wire", rather than requiring the user to download and access a local
file, it becomes easier for the user to execute your code.
(5} Also, please note that the version of proc import included with SAS
University Edition only supports URLs beginning with "http", which means files
hosted on GitHub cannot be used; instead, a service like http://filebin.ca/ is
recommended when developing code in SAS University Edition. 
*/

*******************************************************************************;
* bonus_advanced_recipe_for_loading_data_from_remote_Excel_file ;
*******************************************************************************;

/*
Scenario: Data exists in an Excel file on a remote server and is accessible
through a web server (i.e., with a URL beginning with "http" or "https") and
will take time to download or process, so it's undesirable to reload the data
each time code is executed.

Approach: Repeat the basic recipe as a macro so that logic can be used to
determine whether the dataset already exists and to only invoke proc import if
it doesn't
*/

*Example (which can be run as is to create Work.FRPM1516_raw);
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile TEMP;
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
%loadDataIfNotAlreadyAvailable(
    frpm_raw,
    https://github.com/stat6250/team-0_project1/blob/master/frpm1516-edited.xls?raw=true,
    xls
)
/*
Notes:
(1) In this example, the same .xls file is loaded from GitHub as in the basic
version of the recipe; however, the code for invoking proc import is wrapped
inside a macro, which begins with the line "%macro ..." and ends with the line
"%mend;", and which is not executed until the macro is called with the line
beginning "%loadDataIfNotAlreadyAvailable("
(2) When the macro is called, three values are passed to it and are used in
place of the parameters dsn, url, and filetype in the firsr line of the macro
defintion; however, when these parameters are referenced inside the macro 
definiton, their names are delimited beginning with an ampersand (&} and ending
with a period (.)
(3) The two main benefits of using a macro are that the body of code inside it
can be reused multiple times by calling the macro mulitple times and that
so-called business logic can be used to conditionally execute code, here by
using a %if-%then-%else structure to only execute the block with proc http and
proc import if %sysfunc(exist(&dsn.)) = 0, meaning the dataset with name passed
to the macro doesn't yet exist.
*/