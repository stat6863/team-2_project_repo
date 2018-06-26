*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* set window width to banner width to calibrate line length to 80 characters  *;
*******************************************************************************;

*******************************************************************************;
* obtain-column-information ;
*******************************************************************************;
/*
Scenario: We wish to obtain a full list of columns in a table.

Approachs:
(1) Point-and-click using SAS Explorer, with copy/paste into Excel for editing
(2) Use proc contents
(3) Use proc sql to access dictionary tables
*/

/*
Recipe for Approach 1:

- Open the SAS Explorer
- Click "Toggle Details" icon in menu bar
- Navigate to dataset
- Right-click on Dataset and Select "View Columns"
- Right-click in columns table, and Select "Copy"
- Paste into an empty Excel spreadsheet
- Use Excel's "Text to Columns" command with comma delimiter
*/

*Example For Approach 1;
proc sql;
    select
        <list of columns obtained by copying/pasting>
    from
        sashelp.iris
    ;
quit;


/*
Recipe for Approach 2:
- Use the following SAS code to output information to the Results Viewer:
proc contents order=varnum data=<dataset>;
run;
- Highlight and copy the table of column information
- Paste into an empty Excel spreadsheet
*/

*Example For Approach 2;
proc contents order=varnum data=sashelp.iris;
run;
proc sql;
    select
        <list of columns obtained by copying/pasting>
    from
        sashelp.iris
    ;
quit;


/*
Recipe for Approach 2:
- Use the following SAS code to output information to the Results Viewer:
proc sql;
    select
        name
    from
        dictionary.columns
    where
        lowcase(libname) = '<library>'
    and
        lowcase(memname) = '<dataset>'
    ;
quit;
*/

*Example For Approach 3;
proc sql;
    select
        name
    from
        dictionary.columns
    where
        lowcase(libname) = 'sashelp'
    and
        lowcase(memname) = 'iris'
    ;
quit;
proc sql;
    select
        <list of columns obtained by copying/pasting>
    from
        sashelp.iris
    ;
quit;

/*
Notes:
(1) In each of these example, it's possible to obtain the same full list of
column names in the sashelp.iris dataset. However, there's a "conservation of
difficulty" principle at work, with more code required in order to reduce the
number of manual steps needed. In practice, it doesn't matter which approach is
used since the goal is to get the same list of columns as quickly as possible,
and any code written will most likely be deleted as soon as it's been used.
(2) When writing SQL queries, it's considered best practice to explicitly list
all columns involved, rather than using select-* . However, typing out a list
of column names can be tedious and error prone, especially if there are
hundreds. This is why it's also considered best practice to copy/paste column
names from a list of columns, and also why many different approaches have been
developed. In addition, Approaches 1 and 2 already provide full information
about each column, and Approach 3 can be modified to provide full information
by changing "select name" to "select *".
(3) Depending on context, it's not uncommon to use one of these recipes multiple
times within a single project, in which case it might be worth creating a macro
for Approach 2 or Approach 3. While Approach 1 has the benefit of not requiring
us to remember any code, it would be tedious to perform many times.
(4) Finally, it's important to note that one of these recipes may also need to
be used multiple times when writing a single SQL query. For example, if we need
to join several datasets and include several columns from each in the resulting
output dataset, it's often helpful to obtain a list for columns for each dataset
and to prefix column names with corresponding table aliases. This is
particularly straightforward using formulas in Excel if Approach 1 or Approach 2
is used.
*/
