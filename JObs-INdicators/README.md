# JOIN - Global Jobs Indicators Database

JOIN is the World Bank's Jobs Group database on labor market outcomes from
countries across all income groups with a focus on low- and middle-income countries. The sources are in
most cases Labor Force Surveys (LFSs), but other types of household surveys that include labor market
information are also added. The information on the different labor market outcomes is disaggregated by
gender, urban or rural area, age group of worker, and education level. All indicators are derived from a
World Bank repository of harmonized household surveys. The indicators can be subsumed into four
topics: sociodemographics, labor force and employment status, employment by sector and occupation,
and labor market outcomes, including earnings. To ensure data reliability, a series of quality checks to
both the indicators and the micro-data at the cross-sectional survey level and at the survey time-series
level are conducted. Results are, among others, corroborated using statistics provided by the International
Labour Organization (ILO) or the World Bank’s World Development Indicators (WDI) as well as through
outlier detection and consistency checks. As a result, JOIN provides only indicators for surveys that
surpassed a quality check threshold. JOIN contains about 1,430 household surveys conducted in 160
countries. It is now available as part of the [World Bank’s DataBank](https://databank.worldbank.org/source/global-jobs-indicators-database-(join)).  Further information can be found in the Manual: 

Jörg Langbein and Michael Weber, 2021. Global Jobs Indicators Database (JOIN) Manual: Methodology and Quality Checks, online: https://elibrary.worldbank.org/doi/abs/10.1596/35971


# What is the JOIN GitHub project?
This GitHub provides users with the do files that are used to generate JOIN. Using I2D2 and GLD data, the user can retrace the creation from its first step, data preparation 
until the creation of the outputs. More particularly, the codes follows the following steps: 

1. Data preparation: The first file "Dataset_Preparation" users the surveys already aggregated to a regional level, e.g. MENA region, SSA region etc., cleans the data in case
needed and constructs the basic variables that are used in the next step. 

2. JOIN preparation: The second file "Join_Preparation" constructs all indicator variables that are used in step 3. 

3. JOIN Output: The third file "Join_Output" derives the JOIN indicators from the variables prepared in the two steps before. 

4. JOIN Missing: The fourth file "Join_Missing" creates the share of missing information for each of the main variables.

In case you have any questions on the code or suggestions, please feel free to get in touch. 



