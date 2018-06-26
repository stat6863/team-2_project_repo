*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* set window width to banner width to calibrate line length to 80 characters  *;
*******************************************************************************;

*******************************************************************************;
* ddl-and-dml-sql-queries ;
*******************************************************************************;
/*
Scenario: We wish to perform a data-definition-language (DDL) task, such as
defining, obtaining, or modifying column information for a table; or we wish to
perform a data-manipulation-language (DML) task, such as obtaining, creating,
or modifying the rows of data in a table.

Approach: Use DDL and DML SQL queries.


DDL Recipes:

proc sql;
    * define column information for a table;
    create table <table name> as
    (
         <column1-name> <column1-type>
        ,<column2-name> <column2-type>
        ,...
    );

    * obtain column information for a table;
    describe table <table name>

    * add new column information for a table;
    alter table <table name>
        add
             <new-column1-name> <new-column1-type>
            ,<new-column2-name> <new-column2-type>
            ,...
    ;

    * modify column information for a table;
    alter table <table name>
        modify
             <existing-column1-name> <existing-column1-type>
            ,<existing-column2-name> <existing-column2-type>
            ,...
    ;

    * delete column information for a table;
    alter table <table name>
        drop
             <existing-column1-name>
            ,<existing-column2-name>
            ,...
    ;

    * delete entire table;
    drop table <table name>;
quit;


DML Recipes:

proc sql;
    * obtain rows of data from a table;
    select
        <comma-separated list of columns, of * for all columns>
    from
        <table name>
    <where clause: optional>
    <group-by clause: optional>
    <having clause: optional>
    <order-by clause: optional>
    ;

    * create rows of data in a table using a select query;
    insert into <table name>
        <select query>
    ;

    * create rows of data in a table using value statement, giving tuples of
    values for all columns without specifying column names;
    insert into <table name>
        values(<value-for-column1>, <value-for-column2>, ...)
        values(<value-for-column1>, <value-for-column2>, ...)
        ...
    ;

    * create rows of data in a table using value statement, giving tuples of
    values for specified columns, with values in all other columns set to
    missing for the new rows being created;
    insert into <table name>
        (<column1-name>, <column2-name>, ...)
        values(<value-for-column1>, <value-for-column2>, ...)
        values(<value-for-column1>, <value-for-column2>, ...)
        ...
    ;

    * create rows of data in a table using set statement, giving all columns
    names and their values explicitly;
    insert into <table name>
        set
             <column1-name> = <value1>
            ,<column1-name> = <value1>
            ,...
    ;

    * update rows of data in a table;
    update <table name>
        set
             <column1-name> = <value1>
            ,<column1-name> = <value1>
            ,...
        <where clause: optional>
    ;

    * delete rows of data in a table;
    delete from <table name>
        <where clause: optional>
    ;
quit;

*/


*Examples;

* DDL example: define column information;
proc sql;
    create table Work.tmp
    (
         column1 char(42)
        ,column2 num
    );
quit;

* DDL example: obtain column information;
proc sql;
    describe table Work.tmp;
quit;

* DDL example: add column;
proc sql;
    alter table Work.tmp
        add column3 char(42)
    ;
quit;

* DDL example: modify column;
proc sql;
    alter table Work.tmp
        modify column1 char(54)
    ;
quit;

* DDL example: delete column;
proc sql;
    alter table Work.tmp
        drop column2
    ;
quit;

* DDL example: delete table;
proc sql;
    drop table Work.tmp;
quit;

* DML example setup: define column information;
proc sql;
    create table Work.iris
        like sashelp.iris
    ;
quit;

* DML example: obtain rows of data;
proc sql;
    select * from Work.iris;
quit;

* DML example: create rows of data from select query;
proc sql;
    insert into Work.iris
        select * from sashelp.iris
    ;
quit;

* DML example: create row of data using values statement for all columns;
proc sql;
    insert into Work.iris
        values('Big Flower',75,80,85,90)
    ;
quit;

* DML example: create row of data using values statement for select columns;
proc sql;
    insert into Work.iris
        (Species,SepalLength)
        values('Big Flower',75)
    ;
quit;

* DML example: update rows of data;
proc sql;
    update Work.iris
        set Species='Big Flower'
        where SepalLength > 64
    ;
quit;

* DML example: delete rows of data;
proc sql;
    delete from Work.iris
        where Species='Big Flower'
    ;
quit;


/*
Notes:
(1) These examples illustrate the eight main queries available in proc sql,
along with their possible variations. These are also the 8 main queries defined
in most SQL-based relational database management systems (RDBMSes).
(2) The first four queries (create-table, describe-table, alter-table, and
drop-table) are used as so-called data-definition language (DDL), meaning they
define, obtain, or modify column information in a table, or delete a table
entirely.
(3) The output of a describe-table query is sometimes called the "DDL for the
table" since it's what would be put into a create-table query to create a new
table with the same column properties but no rows of data.
(4) However, note that when specifying the column type in a create-table query,
SAS only supports character columns and numeric columns, even through most
RDBMSes allow for many other possible column types in order to allow the size
of data on disk to be minimized as much as possible (e.g., a list for MySQL is
available at https://dev.mysql.com/doc/refman/8.0/en/data-types.html). This is
because Base SAS only supports character and numeric types; e.g., even date and
time values are really just numeric values with formatting applied to them.
(5) On the other hand, the last four queries (select, insert-into, update, and
delete-from) are used as so-called data-manipulation language (DML), meaning
they obtain, create, modify, or delete the rows of data in a table.
(6) Together, these eight queries are the basic toolkit for database
administration, and it's not uncommon for database-maintenance records to be
given as a sequence of queries since the code itself specifies exact steps with
more precision and fewer characters that a paragraph of text.
(7) In addition, it's also common for data to be distributed as text files with
the extension .sql and with file contents consisting of one or more create-table
queries followed by many insert-into queries with values statements used to
create tables row-by-row. Such files are typically larger in size than CSV
files, but they also remove any ambiguity about the data types for columns,
allowing a table of data from one RDBMS to be exactly moved or copied to
another RDBMS.
*/
