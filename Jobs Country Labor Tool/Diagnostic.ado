

program Diagnostic
version 14

dis "", _newline(10)


dis "Jobs Country Labor Tool"
dis "Creator: World Bank Jobs Group"
dis "Authors: Langbein, Jörg; and Weber, Michael"
dis "Contributors: Fernandez Santos, Angelo Gabrielle; Gronert Alvarez, Mario Andres; and Honorati, Maddalena"
dis ""
dis "The tool creates Jobs Indicators, Tabulations, Graphs and Regression Output for country specific Jobs Diagnostics using GLD, GMD, or I2D2 (Standardized Data)."
dis "Please register for updates by sending an e-mail to ‘jobsccsa@worldbankgroup.org’."
dis "In case you are running the Jobs Country Labor Tool in a folder on a One-Drive folder, please pause the synchronization during runtime."
dis ""


display `""'

dis "", _newline(10)



dis "This package is not an official Stata package. It is a free contribution from the Jobs Group at the World Bank. Please cite it as such: World Bank Jobs Group (2023): Stata module for Jobs Country Labor Analysis"


dis "", _newline(15)


display `"Before getting started, you need to specify three components: The folder where you would like the results to appear, the country, and your current ado folder"'

display `"1. Please store all data in one folder. Specify the folder in which the data is stored by typing global user "Folder structure" (e.g. global user "C:\wb0101\Analysis\Results\""'

display `"2. Set country by typing global y "country" (e.g. global y "Vietnam") "'

display `"You can now start with the data preparation by typing: Prepare"'


end
