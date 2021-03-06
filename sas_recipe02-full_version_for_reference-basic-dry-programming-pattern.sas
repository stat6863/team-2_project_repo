*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* set window width to banner width to calibrate line length to 80 characters  *;
*******************************************************************************;

*******************************************************************************;
* basic-dry-programming-pattern ;
*******************************************************************************;
/*
Scenario: We wish to repeat a set of steps, each time changing the value of a
single parameter.

Approach: Inside a macro shell, use an implicitly defined macro array and the
macro-version of a do-loop.

Recipe:
%macro <macro-name>;
    %let <macro-variable-name>1 = <value-1>;
    %let <macro-variable-name>2 = <value-2>;
    ...
    %let <macro-variable-name>n = <value-n>;

    %do i = 1 %to n;
        <code referencing &&<macro-variable-name>&i.>
    %end;
%mend;
%<macro-name>

*/

*Example;
options mprint;
%macro splitDatasetAndPrintMeans;
    %let species1 = Setosa;
    %let species2 = Versicolor;
    %let species3 = Virginica;
    %put _user_;
    %put;

    %do i = 1 %to 3;
        %let currentSpecies = &&species&i.;
        %put &=currentSpecies.;
        data iris_&currentSpecies.;
            set sashelp.iris;
            if species = "&currentSpecies.";
        run;
        proc means n nmiss min q1 median q3 max maxdec=1;
        run;
    %end;
%mend;
%splitDatasetAndPrintMeans

/*
Notes:
(1) In this example, we begin by setting the global system option mprint,
which prints the SAS code generated by processing the macro to the log window.
In general, a helpful mental model when reading macros is to assume that all
statements involving percent signs (%) and ampersands (&) are being turned into
normal SAS code, with special "macro versions" of  SAS operations needed to
facilitate this code-generation process.
(2) The next line creates an argument-less macro, which is the macro
equivalent of a null data step, meaning it's a "shell" that can be used to wrap
both macro commands and non-macro commands. When the macro is executed in the
very last line, where just its name is dereferenced using a percent sign,
all macro commands in the body of the macro are resolved, and then all normal
SAS commands that result are executed.
(3) At the start of the body of the macro, three macro variables are created,
each subscripted with an integer. Because macro variable values can only ever
be strings, this is a common trick for creating implicit arrays, meaning a
collection of related values indexed by an integer.
(4) Next, we print all user-defined macro variables to the log, followed by a
blank line, which helps us monitor the macro's execution.
(5) Then, we use the macro-version of a do-loop to execute code three times,
once for each value in our implicit array defined by the three macro variables
"species1", "species2", and "species3". Note that, because this is the macro-
version of a do-loop, we have %do and %to at the start of the do-loop and %end
at the end of the do-loop. In addition, the index variable "i" that's created
within the scope of the do-loop will be a macro variable.
(6) Finally, within the body of the do-loop, we do the following:
(6a) We use the Forward Rescan Rule to obtain the ith value of the implicit
array defined by the three macro variables "species1", "species2", and
"species3", and store it in a new macro variable called "currentSpecies",
whose value will be updated for each iteration of the do-loop. (E.g., if "i"
has value 2, then &&species&i. -> &species2 -> Versicolor by the Forward Rescan
Rule; in the first iteration, && -> & and &i. -> 2; then &species2 just
dereferences the macro variable "species2" created earlier.)
(6b) Then, we print each value of "currentSpecies" to the log, to help monitor
macro execution.
(6c) Then, for each value of "currentSpecies", use a data step to create a new
dataset by subsetting the famous iris dataset used in many machine learning
examples. In addition, we use proc means to  print the number of observations,
the number of missing values, and a five-number summary, with only one digit
after the decimal displayed. In particular, note that, since no dataset
is specified in the proc means step, the last dataset created will be used.
(7) The end result is that we've automated the creation of three datasets,
along with a proc applied to each.  In this example, we're only iterating three 
times, but it would just as easily have been more, and the effort required to 
manually create the macro variables and set the number of iterations for the 
do-loop is much less than what would be required to copy/paste/update three 
separate copies of data step and proc means step. And it's also much less 
error-prone, hence the computer science acronym "DRY", which is short for
"don't repeat yourself".
*/
