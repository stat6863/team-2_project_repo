*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* set window width to banner width to calibrate line length to 80 characters  *;
*******************************************************************************;

*******************************************************************************;
* summarize-data-using-proc-report ;
*******************************************************************************;
/*
Scenario: We wish to summarize properties of columns in a table.

Approach: Use appropriate options in a proc report step.

Recipe:
proc report data=<dataset name> <additional options>;
    columns
        <column1-name or special value>
        <column2-name or special value>
        ...
    ;
    define <column1-name or special value> / <column type>;
    define <column2-name or special value> / <column type>;
    ...

    compute <name-of-computed-variable>;
        <dataset-style code>
    endcomp;

    <additional compute blocks, as needed>

    <additional stylistic statements, like report break summaries>

quit;

*/

*Examples;

* print the first 3 rows from sashelp.iris;
proc report data=sashelp.iris(obs=3);
run;

* sort sashelp.iris by SepalLength, suppressing output with an "ODS Sandwich";
ods exclude all;
proc report data=sashelp.iris out=Work.iris(drop=_BREAK_);
    define
        SepalLength / order;
run;
ods exclude none;

* summarize values for a single qualitative variable;
proc report data=sashelp.iris;
    columns
        Species
        N
    ;
    define Species / group;
    define N / "Number of Irises";
run;

* summarize values for a single quantitative variable;
proc report data=sashelp.iris;
    columns
        Species
        SepalLength = SepalLength_Min
        SepalLength = SepalLength_Median
        SepalLength = SepalLength_Max
    ;
    define Species / group;
    define SepalLength_Min / min "Minimum Sepal Length";
    define SepalLength_Median / median "Median Sepal Length";
    define SepalLength_Max / max "Maximum Sepal Length";
run;

* summarize values for two qualitative variables using a two-way table;
proc report data=sashelp.iris;
    columns
        SepalLength
        Species
        Total
    ;
    define SepalLength  / group;
    define Species/ across;
    define Total / computed;

    compute Total;
        Total = sum(_c2_, _c3_, _c4_);
    endcomp;
        
    rbreak after / summarize;
run;

/*
Notes:
(1) These examples illustrate the common statement that "there are many ways to
accomplish a single tasks in SAS." Here, we have used proc report to imitate the
behavior of procs print, sort, freq, and means, including building a two-way
table (aka a contingency table or cross-tabulation).
(2) In particular, while proc sql is often seen as the main Swiss-army-knife
proc, useful for both data-definition language (DDL) and data-manipulation
language (DML) operations, proc report can be used to recreate many of the same
types of output as the select query in proc sql. In addition, depending on
dataset size and available computing resources, proc report will often be
faster, use less memory, and be applicable to arbitrarily large datasets since
it operates row-by-row, meaning that unlike proc sql, it doesn't need to load
an entire dataset into memory. As a byproduct of proc report operating
row-by-row, proc report implicitly loops over a dataset, in effect implementing
a stripped down version of data-step programming. This is what allows us to use
row-level computations within a compute block to sum column values (denoted by
c<n>, where <n> is the literal column number is the output table) in the example
that builds a two-way table, and it's what also allows proc report to add a
summary line after it finishes looping, using the "rbreak" (aka "report break")
statement. We also used the "across" column type, instructing proc report to
implicitly loop over all possible values of "Species". To get the same type of
output in proc sql, we'd need to know all possible values of "Species" ahead of
time and manually create in-line views or subqueries for each value since SQL
queries don't support looping.
(3) On the other hand, proc sql is often the best option for adding/updating/
removing data within a dataset, or for combining data from multiple datasets.
Proc report can only work with a single dataset, and proc report also lacks a
noprint option for suppressing output since it's intended to create report
tables. This is why the proc-sort-like example uses a so-called "ODS sandwich"
to turn off all output to the Results Viewer, where "ODS" stands for "Output
Delivery System". Sandwiching proc calls with ODS instructions is a common SAS
trick for overcoming output limitations.
(4) In summary, a common workflow for data projects is to use proc sql
(supplemented by data steps, if by-group processing or do-loops are needed) to
prepare a single dataset from various data sources, and then to use a series of
proc steps for reporting (e.g., procs freq, means, report, or tabulate) and/or
statistical inference (e.g., proc corr, glm, or logistic) to create output
directed to a particular designation (e.g., the Results Viewer, an Excel file,
or a PDF file) using "ODS sandwiches." In particular, by first cleaning and
combining multiple datasets at the finest grain possible (aka the least level
of aggregation), reporting and statistical procs can be used to aggregate and
summarize. For example, given tables at both the student grain (meaning each
row describes a single student) and school grain (meaning each row describes a
single school), proc sql could be used to aggregate the student-level data into
school-level data, and to combine the result with other school-level datasets.
The final resulting table will be at the school grain, which is the finest
grain possible, and can then be summarized at coarser grains like the district
or county level using summary procedures like proc report.
*/


