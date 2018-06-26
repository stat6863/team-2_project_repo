*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* set window width to banner width to calibrate line length to 80 characters  *;
*******************************************************************************;

*******************************************************************************;
* advanced-dry-programming-pattern ;
*******************************************************************************;
/*
Scenario: We wish to repeat a set of steps, each time changing the value of a
single variable whose values are determined in a data-driven manner.

Approach: Inside a macro shell, use an implicitly defined macro array and the
macro-version of a do-loop.

Recipe:
%macro <macro-name>(<parameter list needed for macro>);
    <steps to determine the list of values to loop over>

    %do i = 1 %to <number of elements in the list to loop over>;
        <steps to repeat for each element in the list to loop over>
    %end;
%mend;
%<macro-name>(<values for parameters>)

*/

*Example;

options
    mcompilenote=all
    mprint
    symbolgen
;
%macro splitDatasetAndPrintMeans(
    inputLibrary,
    dsn,
    column,
    outputLibrary=Work
);

    %let callDate = %sysfunc(today(),weekdate.);

    proc sql noprint;
        select
            distinct &column. into :iterationList separated by "|"
            from &inputLibrary..&dsn.
        ;
    quit;

    %let numberOfIterations = %sysfunc(countw(&iterationList.,|));

    %do i = 1 %to %eval(&numberOfIterations.);
        %let currentIteration = %scan(&iterationList.,&i.,|);
        data &outputLibrary..&dsn._&currentIteration.;
            set &inputLibrary..&dsn.;
            if &column. = "&currentIteration.";
        run;
        footnote "Created on &callDate. using dataset &syslast.";
        proc means n nmiss min q1 median q3 max maxdec=1;
        run;
    %end;
%mend;
%splitDatasetAndPrintMeans(sashelp, iris, species)


/*
Notes:
(1) In this example, we begin by setting three global system options,
mcompilenote=all, mprint, and symbolgen. Together, these print messages to the
SAS log describing the results of compiling macros, generating normal SAS code,
and the values of macro variables (aka "symbol generation").
(2) We then define a macro with three positional parameters (inputLibrary, dsn,
and column) and one keyword parameter (outputLibrary, with default value
"Work"). In general, a helpful mental model is to think of a SAS macro as being
similar to functions in languages like R and Python, but with two main notable
differences: (i) The arguments/parameters passed to a SAS macro become macro
variables, meaning they need to be manipulated with macro commands and
macro-versions of operations, and (ii) SAS macros have no return value, since
the result of executing a macro is to generate a text-string that SAS will then
attempt to execute as if it were the normal SAS code printed to the log by the
mprint global system option. This creates a trade-off with macros being
incredibly useful for automating repetitive tasks, but with scripts using
macros more difficult to understand and reason about. The reader has to
mentally execute the macro in their head to fully understand the generated code.
(3) In the body of the macro, we first create a macro variable named "callDate"
by using the %sysfunc macro command to execute the data-step function today and
apply the format "weekdate." to the result, which stores the date the script
is executed in the "weekdate" format.
(4) We then use a proc sql step to create a macro variable called
"iterationList", whose value will be a list of distinct values from the column
from the dataset in the library specified in the parameter list. In addition,
this list of values will be separated/delimited by a vertical pipe (|), which is
a common trick for defining an implicit macro array within a single macro
variable. In this proc sql step, note that double-dot in "&inputLibrary..&dsn."
is not a typo. When the macro is called with "&inputLibrary."="sashelp" and
"&dsn."="iris", "&inputLibrary..&dsn." resolves to "sashelp.iris" since the
first dot is used to dereference the macro variable "inputLibrary" and the
second dot is used to separate a SAS library name from a dataset name using
standard dot notation (library-name.dataset-name).
(5) Next, we define a new macro variable "numberOfIterations" using the
%sysfunc macro command, which executes the data-step function countw (aka
"count words") on the value of the macro variable "iterationList", counting
the number of items in the implicit array w.r.t. the specified delimiter (a
vertical pipe). This is the step that allows us to control iteration over the
items in "iterationList" in a data-driven manner.
(6) Next, we use the macro version of a do-loop to iterate, and we select the
ith element of "iterationList" in each iteration by using the %scan macro
command. The %scan macro command is just like the scan data-step function,
returning the ith element of a string w.r.t. a specific delimiter (here, a
vertical pipe), except that it operates on macro variables instead of normal
string literals. Furthermore, inside this do-loop, we perform the following
operations:
(6a) A data step creates a new dataset for each item in "iterationList".
(6b) A proc means step prints a numerical summary for each new dataset created,
followed by a footnote containing the current date (as created above) and the
dataset used. In particular, since the proc means step doesn't specify a input
dataset, the automatically created macro variable "syslast" is used, where
"syslast" keeps track of the last dataset created.
(7) Finally, with invocation of the macro in the last line of the example,
three new datasets are automatically generated, and a proc is applied to each.
And because iteration was controlled based upon values in an input dataset, it
would have been the same amount of effort to create 100 or 1,000 datasets.
Consequently, this is an incredibly powerful, but advanced, expression of the
computer science acronym "DRY", which is short for "don't repeat yourself".
*/
