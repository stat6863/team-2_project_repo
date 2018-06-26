*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* set window width to banner width to calibrate line length to 80 characters  *;
*******************************************************************************;

*******************************************************************************;
* print-to-log-with-macro-variables ;
*******************************************************************************;
/*
Scenario: We wish to print information to the log without using a null data step

Approach: Use the macro command %put

Recipe:
%put <text to print to log>;

*/

*Example;
%let recipeName = print-to-log-with-macro-variables;
%put This is an example of the recipe &recipeName.;
%put This is an example of &=recipeName.;
%put _user_;

/*
Notes:
(1) In this example, we have four lines of open code, meaning they're not
contained inside a macro definition, and each line is preceded by a percent
sign, which tells SAS a macro command is being given.
(2) The first line is the macro command %let, which creates a macro variable
named "recipeName", meaning a placeholder whose value is the string literal
"print-to-log-with-macro-variables". However, this string literal doesn't
need to be wrapped in quote marks since the values of macro variable are
always assumed to strings, and everything between the equal sign and the
semicolon will become the value of "recipeName".
(3) The next three lines are examples of the macro command %put, which print
everything through a closing semicolon to the SAS log window. Here, each %put
statement prints the value of "recipeName" in a different way, and note that
no quote marks are needed since the text following %put is assumed to be a
string literal.
(4) The first %put statement prints some text, followed by the value of the
macro variable "recipeName". To dereference "recipeName" and obtain it's value,
we delimit its name, meaning we precede it's name with an ampersand (&) and
then put a period (.) following it's name, where the ampersand tells SAS to
start reading a macro variable name and the period tells SAS to stop. Note,
however, that the period is optional in this case since a semicolon could also
be used to tell SAS implicitly were the macro variable name ends (as would any
character that's not a letter, number, or underscore). In general, though, it's
best practice to include the terminating period since it makes the code more
readable by a human being.  
(5) The second %put statement is essentially identical to the first, except
that the macro variable "recipeName" is dereferenced using an ampersand (&)
together with an equal sign (=), which causes the name of the macro variable
to also be printed to the log.
(6) Finally, the third %put statement prints the names of all user-defined
macro variables and their values, possibly along with some automatically
generated macro variables.
(7) When debugging, any of these three usage patterns can be helpful, depending
on the type of information you might find helpful to print to the log. It's
especially helpful to periodically use %put _user_ in long scripts involving
many macro variables.
*/
