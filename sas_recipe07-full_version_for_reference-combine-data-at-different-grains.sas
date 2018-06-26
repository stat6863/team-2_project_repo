*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* set window width to banner width to calibrate line length to 80 characters  *;
*******************************************************************************;

*******************************************************************************;
* combine-data-at-different-grains ;
*******************************************************************************;
/*
Scenario: We wish to join data from multiple tables, each at a different grain
(aka level of aggregation).

Approach: Aggregate the data with a finer grain within an in-line view before
joining to the data with a coarser grain.

Recipe:

proc sql <any desired proc-sql options>;
    select
        <columns from result of join to include>
    from
        <courser-grained table>
        <join operation>
        <in-line view aggregating finer-grained table>
    <additional query clauses, as needed>
    ;
quit;

*/

*Example;

proc sql number;
    select
         coalesce(A.statename, B.statename) as statename
        ,A.region
        ,A.division
        ,B.number_of_zipcodes
    from
        sashelp.us_data as A
        full join
        (
            select
                 statename
                ,count(*) as number_of_zipcodes format comma12.
            from
                sashelp.zipcode
            group by
                statename
        ) as B
        on
            A.statename = B.statename
    order by
        number_of_zipcodes desc
    ;
quit;


/*
Notes:
(1) In this example, we join two datasets: (i) sashelp.us_data, whose grain is
at the US state level, meaning the experimental units described by each row
are US states and that the column "statename" is a primary key for the table;
and (ii) sashelp.zipcode, whose grain is at the US ZIP Code level, meaning the
experimental units described by each row are US ZIP Codes and that the column
"ZIP" is a primary key. In particular, note that even though sashelp.zipcode
also contains the column "statename", the dataset has multiple rows for each US
state (since US states are composed of many ZIP Codes), which is why
sashelp.zipcode has a finer grain than sashelp.us_data.
(2) Since sashelp.zipcode has a finer grain, the query is written so that the
grain of the result will be at the US state level. Specifically, an in-line
view is used within the from-clause to aggregate by and count the number of
rows corresponding to each value of "statename". The results of this embedded
select-query is then given the table alias B, allowing its columns to be
referenced within the main query.
(3) In addition, the table sashelp.us_data is also given a table alias, A, so
that its columns are also easy to reference within the main query.
(4) Also, a full (outer) join is used to combine sashelp.us_data and the in-line
view resulting from aggregating sashelp.zipcode, because there could be ZIP
Codes that do no correspond to US states. In other words, rows of the tables
with aliases A and B might not be able to be matched up exactly by the join
condition A.statename = B.statename, and we want to capture both matched and
unmatched rows in the output table.
(5) Finally, in case there are ZIP Codes that don't belong to US states or US
states missing from sashelp.zipcode, the coalesce function is used to ensure a
value of "statename" will be present for row in the output table. Specifically,
we are coalescing the values of "statename" from sashelp.us_data with the values
of "statename" from sashelp.zipcode. This means the value from sashelp.us_data
will be used, but if it's missing, the value from sashelp.zipcode will be used
instead.
*/
