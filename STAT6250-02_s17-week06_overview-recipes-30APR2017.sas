*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* Setup for Example Code;
%let inputDataset1URL =
https://github.com/stat6250/team-0_project2/blob/master/data/gradaf15.xls?raw=true
;
%let inputDataset1Type = XLS;
%let inputDataset1DSN = gradaf15_raw;

%let inputDataset2URL =
https://github.com/stat6250/team-0_project2/blob/master/data/sat15-edited.xls?raw=true
;
%let inputDataset2Type = XLS;
%let inputDataset2DSN = sat15_raw;

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
    &inputDataset1DSN.,
    &inputDataset1URL.,
    &inputDataset1Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset2DSN.,
    &inputDataset2URL.,
    &inputDataset2Type.
)


*******************************************************************************;
* basic_recipe_for_combining_data_horizontally ;
*******************************************************************************;
/*
Scenario: Data exists in multiple datasets to be combined horizontally with
          respect to a unique id

Approach: Use a data step with a merge statement listing each dataset, along
          with a one or more columns comprising a unique id

Recipe <with everything in square brackets to be filled in for actual use; the
only parts that can be left out, if not needed, are the where and subsetting if
statements>:

data <output dataset name>;
    retain
        <names of columns to include in output in order>
    ;
    keep
        <names of columns to include in output in order>
    ;
    merge
        <input dataset name 1>
        ...
        <input dataset name n>
    ;
    by
        <unique id column(s) present in all input datasets>
    ;
    where
        <condition input rows must satisfy to be included in processing>
    ;
    if
        <condition created rows must satisfy to be included in output>
    ; 
run;
*/

*Example (which can be run as long as Work.gradaf15_raw and sat15_raw were 
 created above);
data cde_2014_analytic_file_v1;
    retain
        CDS_Code
        School
        UC_Coursework_Completers
        SAT_Takers
        Twelfth_Graders
        Excess_SAT_Takers
    ;
    keep
        CDS_Code
        School
        UC_Coursework_Completers
        SAT_Takers
        Twelfth_Graders
        Excess_SAT_Takers
    ;
    label
        CDS_Code=" "
        School=" "
        UC_Coursework_Completers=" "
        SAT_Takers=" "
        Twelfth_Graders=" "
        Excess_SAT_Takers=" "
    ;   
    merge
        gradaf15_raw(rename=(TOTAL=UC_Coursework_Completers))
        sat15_raw(
            rename=(
                cds=CDS_Code
                sname=School
                NumTstTakr=SAT_Takers
                enroll12=Twelfth_Graders
            )
        )
    ;
    by
        CDS_Code
    ;
    Excess_SAT_Takers =
        input(SAT_Takers,best12.)
        -
        input(UC_Coursework_Completers,best12.)
    ;
run;
/*
Notes:
(1) In this example, two datasets having few columns in common (but no columns
with the same names, even though columns like CDS_CODE in dataset gradaf15_raw
and cds in sat15_raw represent the same observable value of a so-called "CDS
Code", which is a unique id assigned to public K-12 schools in California by the
California Department of Education, aka the CDE) are combined horizontally (aka
"merging" or "joining", but usually called "match-merging" in SAS programming)
using a merge statement and a by statement. The merge statement is used to name
two input datasets (and here includes dataset options to rename columns in each
input dataset), and the by statement is used to name the unique id column(s),
which specify how rows are to be matched up when combining the datasets.
(2) Specifically, rows from the input datasets having matching unique id values
are combined to create a single, longer row with all variables/columns from
each input dataset, as well as any additional columns created within the data
step, where any columns having identical names are filled in based on dataset
order, so that the last value read is the one appearing in the output dataset.
Here, schools are experimental units (meaning the real-world entities whose
properties are described by rows in each dataset), and the unique id schema
consists of a single column having different names in each input dataset; the
unique id is called CDS_CODE in dataset gradaf15_raw, and it's called cds in
sat15_raw; e.g., both datasets contain an observation/row for a school called
"FAME Public Charter", which has CDS Code 01100170109835 and appears in row 1
in gradaf15_raw and row 4 in sat15_raw (as can be checked in "Explorer").
(3) In addition, since an analytic file is being built, a retain statement is
used to specify column order in the output dataset. In other words, the six
columns listed are the first six variables added to the Program Data Vector
(aka PDV) created when the data step is compiled, and any other columns in the
input datasets or created in the data step will be added to the PDV as they're
encountered, as usual when compiling a data step. In other words, the data step
is compiled and exected the same way, whether a set statement is used to
specify a single input dataset or a merge statement is used to specify multiple
input datasets; the only difference is that there are multiple origin points for
values used to fill in the PDV for each row to be included in output.
(4) Additionally, a keep statement is used to explicitly list the columns to be
kept in the output dataset, specifying the same columns as in the retain
statement.
(5) Also, a label statement is used to delete the label for each column listed,
overriding SAS' default behavior of using the original name for each column as
its label. Here, only the labels for the columns UC_Coursework_Completers,
SAT_Takers, and Twelfth_Graders actually need to be overridden, but the other
columns are included for uniformity.
(6) Finally, a column named Excess_SAT_Takers (corresponding to the difference
between the number of SAT takers at a school and the number of students
completing UC-preparatory coursework) is created by combining column
SAT_Takers from sat15_raw with UC_Coursework_Completers from gradaf15_raw, where
both columns are first converted to numeric values using the input function
relative to the format best12. (SAS' default numeric format for integer values)
since they're stored as text values in the input datasets.
*/


*******************************************************************************;
* adv_recipe_for_combining_data_horizontally ;
*******************************************************************************;
/*
Scenario: Data exists in multiple datasets to be combined horizontally with
          respect to a condition for matching up rows

Approach: Use proc sql with a from clause combining the datasteps with a join
          operation specifying the condition for matching up rows

Recipe <with everything in square brackets to be filled in for actual use; the
only parts that can be left out, if not needed, are the where and having
clauses>:

proc sql;
    create table <output dataset name> as
        select
            <names of columns, and/or expressions involving columns, to include
             in output in order, preceded each column name with the alias of
             its corresponding dataset using dot notation>
        from
            <input dataset name 1> AS <input dataset name 1 alias>
            <join operator; e.g., full join, left join, or inner join>
            <input dataset name 2> AS <input dataset name 2 alias>
            <join condition>
            <join operator; e.g., full join, left join, or inner join>
            <input dataset name 3> AS <input dataset name 3 alias>
            <join condition>
            ...
        where
            <condition input rows must satisfy to be included in processing>
        having
            <condition created rows must satisfy to be included in output>
    ;
quit;
*/

*Example (which can be run as long as Work.gradaf15_raw and sat15_raw were 
 created above);
proc sql;
    create table cde_2014_analytic_file_v2 as
        select
             coalesce(B.CDS, A.CDS_Code) AS CDS_Code label " "
            ,coalesce(B.sname,A.School) AS School label " "
            ,A.TOTAL AS UC_Coursework_Completers label " "
            ,B.NUMTSTTAKR AS SAT_Takers label " "
            ,B.enroll12 AS Twelfth_Graders label " "
            ,input(B.NUMTSTTAKR,best12.)
             -
             input(A.TOTAL,best12.)
             AS
             Excess_SAT_Takers label " "
        from
            gradaf15_raw as A
            full join
            sat15_raw as B
            on A.CDS_Code = B.CDS
    ;
quit;
/*
Notes:
(1) In this example, the same six columns are created in the same order as in
the basic example, but significantly less code is required since all datasets
options and data step operations have been combined into a select clause for
the single query given in this proc sql step.
(2) In addition, each column selected for inclusion in the output dataset is
either calculated from columns in the input datasets or is a modified version
of a column from an input dataset. For example, the output column CDS_Code is
created by coalescing values of CDS from dataset B (the alias for sat15_raw) and
values of CDS_Code from dataset A (the alias for gradaf15_raw), meaning that the
value of B.CDS is used if it's not missing, and the value of A.CDS_Code is used
otherwise. Similarly, UC_Coursework_Completers is created by renaming A.TOTAL,
and Excess_SAT_Takers is created from a calculation involving the columns
B.NUMTSTTAKR and A.TOTAL.
(3) Additionally, the label for each column included in output is separately
set to the empty string " ".
(4) Also, a from clause is used to specify the two input datasets, to give them
aliases (meaning short names for more conveniently referencing them throughout
the query), to specify a join operator (here, a full join, meaning that all
possible combinations of rows from the two datasets are included, which matches
the default behavior for a data-step match-merge), and to specify a join
condition (here, that columns from the two input datasets must be equal in order
to match up rows).
(5) As with most uses of proc sql, combining datasets has trade offs. For
example, less code is required, and we're given greater flexibility since
columns names doesn't need to be renamed using dataset options, and since
arbitrary join conditions can be used (e.g., we could use a condition like
"on A.CDS_Code < B.CDS", if desired). However, since proc sql loads all data
into memory before joining, proc sql is limied by available RAM and can take
significantly longer to create join datasets than an equivalent data step.
(6) Despite this limitation, many SAS programmers rely on proc sql for the bulk
of their data manipulation tasks, especially since it's a more flexible tool for
combining datasets while requiring significantly less code. In addition, as
mentioned before, proc sql is something like a Swiss army knife; as long as data
are small enough to fit in memory, it can be used as a substitute for proc
means, proc freq, and proc sort just as easily as it can be used to combine
datasets.
(7) Proc sql is not covered in the course textbook and is considered an advanced
topic because it requires learning to use SQL (structured query language), which
is one of the main standards for defining and manipulating data. Consequently,
we'll only see basic examples in order to give you a sense of the syntax and how
it can be used, as a basis for self-study either during or after the course.
*/
