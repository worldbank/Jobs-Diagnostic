

program Diagnostic
version 14

dis "", _newline(10)


dis "Jobs Diagnostic - Labor Tool"
dis "Creator: World Bank Jobs Group" 
dis "Authors: Langbein, Jörg; and Weber, Michael" 
dis "Contributors: "Fernandez Santos, Angelo Gabrielle; Gronert Alvarez, Mario Andres; and Honorati, Maddalena"
dis ""
dis "The tool creates Jobs Indicators, Tabulations, Graphs and Regression Output for Jobs Diagnostics Supply Side using I2D2 (Standardized Data)."
dis "Please register for updates by sending an e-mail to ‘jobsdiagnostics@worldbank.org’." 
dis "In case you are running the Jobs Diagnostic Supply Side Analysis in a One-Drive folder, please pause the synchronization during runtime."
dis ""


display `""'

dis "", _newline(10)



dis "This package is not an official Stata package. It is a free contribution from the Jobs Group at the World Bank. Please cite it as such:   Langbein, J. and Weber, M. (2021): Stata module for labor supply side analysis"


dis "", _newline(15)


display `"Before getting started, you need to specify three components: The folder where you would like the results to appear, the country, and your current ado folder"'

display `"1. Please store all data in one folder. Specify the folder in which the data is stored by typing global user "Folder structure" (e.g. global user "C:\wb0101\Analysis\Results\""'

display `"2. Set country by typing global y "country" (e.g. global y "Vietnam") "'

display `"You can now start with the data preparation by typing: Prepare"'


end
