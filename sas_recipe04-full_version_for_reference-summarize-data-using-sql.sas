*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* set window width to banner width to calibrate line length to 80 characters  *;
*******************************************************************************;

*******************************************************************************;
* summarize-data-using-sql ;
*******************************************************************************;
/*
Scenario: We wish to summarize properties of columns in a table.

Approach: Use appropriate optional clauses in a SQL select query.

Recipe:
proc sql <options: optional>;
    <select clause: mandatory>
    <from clause: mandatory>
    <where clause: optional>
    <group-by clause: optional>
    <having clause: optional>
    <order-by clause: optional>
    ;
quit;

*/

*Example;

* print the first 3 rows from sashelp.iris;
proc sql outobs=3;
    select
        *
    from
        sashelp.iris
    ;
quit;

* print the first 5 rows of sashelp.iris after sorting by SepalLength;
proc sql outobs=5 number;
    select
        *
    from
        sashelp.iris
    order by
        SepalLength
    ;
quit;

* summarize values for qualitative and quantitative variables;
proc sql;
    * print frequency of each Species in sashelp.iris;
    select
         Species
        ,count(*) as Number_of_Irises
    from
        sashelp.iris
    group by
        Species
    ;
    * print median of SepalLength by Species in sashelp.iris;
    select
         Species
        ,min(SepalLength) as Minimum_Sepal_Length
        ,median(SepalLength) as Median_Sepal_Length
        ,max(SepalLength) as Maximum_Sepal_Length
    from
        sashelp.iris
    group by
        Species
    ;
quit;


/*
Notes:
(1) These examples demonstrate the utility of proc sql, which can be thought
of as a swiss-army knife, capable of replicating much of the functionality of
SAS procs for summarizing data. Four fundamental examples are as follows:
(1a) A select query comprising a select and from clause emulates proc print.
(1b) A select query comprising a select, from, and order-by clause emulates
proc sort.
(1c) A select query comprising a select clause with count functions, from
clause, and group-by clause can be used to emulate proc freq.
(1d) A select query comprising a select clause with summary functions,
from clause, and group-by clause can be used to emulate proc means.
Note that a single proc sql step can have multiple queries, with each query
executed as soon as its terminating semicolon is encountered. Also, note that
proc sql always ends with a quit statement, since it's an interactive procedure.
(2) In addition, by including additional clauses, or options within each
clause, even more flexibility in summarizing data becomes possible. A helpful
mental model is to think of a SQL select query as a process for transforming
an input dataset (or multiple input datasets) into an output dataset. A SQL
select query is composed of 2-6 clauses, with each clause playing a different
role in creating output. These clauses must be used in the following order:
(2a) The (mandatory) "select" subsets the columns from the input dataset, and
can also include calculations creating new columns.
(2b) The (mandatory) "from" clause determines the input dataset.
(2c) The (optional) "where" clause subsets the rows from the input dataset.
Without a "where clause", all rows from the input dataset will be used.
(2d) The (optional) "group-by" clause combines (aka aggregates) rows from the
input dataset, producing new rows to include in the output dataset. Without a
"group-by" clause, the rows from the input dataset (possibly subsetted by a
"where" clause) will be used as-is when creating an output dataset.
(2e) The (optional) "having" clause subsets the rows available for inclusion
in the output dataset, resulting in a final set of rows for the output
datasets. Without a "having" clause, all rows available for inclusion in the
output dataset will be used.
(2f) The (optional) "order-by" clause sorts the final set of rows for the
output datasets. Without an "order-by" clause, the order of the rows in the
output dataset will be unpredictable.
A helpful mnemonic for remembering this required order is "so few workers go
home on-time" (suggestive of "select from with group-by having order-by").
(3) In summary, proc sql provides great flexibility, because it implements a
variant of the ANSI SQL (Structured Query Language) standard, which includes
both data-definition-language queries (e.g., create-table, describe-table,
drop-table, and alter-table) and data-manipulation-language queries (e.g.,
the select-query describe above, as well as insert-into, update, delete-from).
In addition, the from clause in applicable queries can be used to combine
datasets both vertically (with set-theoretic operations like union and
intersection) and horizontally (aka "joins") with greater flexibility than
data-step programming.   
(4) However, there's an important trade-off: Data-step programming and many
other SAS procs operate on datasets row-by-row, meaning they load rows from
disk as needed, allowing them to operate on arbitrarily large datasets. Proc
sql, on the other hand, loads all rows from a dataset into memory at once,
meaning it can only operate on datasets that can fit into memory. As a result,
proc sql is often faster than data-step programming and specialized procs for
small-ish datasets, but it tends to be slower (or impossible to use) for
large-ish datasets. In addition, data-step programming has features that
proc sql does not have, like by-group progressing and the do-loop. Similarly,
specialized procs like proc freq have features, like generating two-way
tables, that would be difficult to recreate in proc sql. Consequently, proc
sql is powerful and useful, especially for combining datasets vertically and
horizontally, but it is not a complete replacement for other SAS features.
*/
