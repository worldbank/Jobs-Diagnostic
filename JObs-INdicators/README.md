# JOIN - Global Jobs Indicators Database

JOIN is the World Bank's Jobs Group database on labor market outcomes from
countries across all income groups with a focus on low- and middle-income countries. It provides easily accessible and standardized labor market indicators to support better labor policy with high-quality  data. The current version of JOIN is built using 2,150 surveys totaling about 228 million observations. These surveys come from 164 countries of which 74 percent are low-and middle-income countries. The sources are in most cases Labor Force Surveys (LFSs), but other types of household surveys that include labor market
information are also added. The information on the different labor market outcomes is disaggregated by gender, urban or rural area, age group of worker, and education level. All indicators are derived from a World Bank repository of harmonized household surveys and weighted  to  be nationally representative. The indicators can be subsumed into four topics: sociodemographics, labor force and employment status, employment by sector and occupation, and labor market outcomes, including earnings. To ensure data reliability, a series of quality checks to
both the indicators and the micro-data at the cross-sectional survey level and at the survey time-series level are conducted. Results are, among others, corroborated using statistics provided by the International Labour Organization (ILO) or the World Bank’s World Development Indicators (WDI) as well as through
outlier detection and consistency checks. As a result, JOIN provides only indicators for surveys that surpassed a quality check threshold. JOIN contains about 1,430 household surveys conducted in 160 countries. It is now available as part of the [World Bank’s DataBank](https://databank.worldbank.org/source/global-jobs-indicators-database-(join)).  Further information can be found in the Manual: 

Jörg Langbein and Michael Weber, 2021. Global Jobs Indicators Database (JOIN) Manual: Methodology and Quality Checks, online: https://elibrary.worldbank.org/doi/abs/10.1596/35971


# How is the database constructed?
First, a repository of harmonized household and labor force surveys is collected for the construction of the database. Although the surveys cover different household survey types, all contain a range of variables that can be harmonized for each individual. Examples are labor force status, age, and employment status. In a second step, the indicators are constructed for each survey. There are 105 indicators constructed within the following sections:
- Data description, for example, country, survey type, and year of survey
- Sociodemographic, for example, share of urban population or workers in population
- Labor  force and  employment,  for  example, labor  force  participation rate, share of  wage workers, or share of informal workers
- Sectors and occupations, for example,share of workers in agricultural sector, share of craft workers
- Wages and working  hours, for  example, average working hours, share of underemployed workers, and median earnings
- Education, for example, share of employees with primary education.

# Data quality checks and filtering
Different tests are performed on each survey to detect differences with other data sources, internal coherence of the indicators, realistic values of the data, and missing values in the micro-data. Across years of the survey, different  types of  outliers are inspected. To  raise a flag, a comparison of the  result of  the  test to the distribution of results in the database is made, and the results are grouped into five categories, depending on the gravity of the quality issue. In total, 115 quality checks are conducted, each flagging data quality from no or few problems to potentially significant issues in the data. The results from the data quality checks are then used to filter the data. From the 2,185 surveys included at the beginning, 1,430 are eventually included in JOIN. 


# What is the JOIN GitHub project?
This GitHub  provides users with the do files that are used to generate JOIN. Using I2D2 and GLD data, the user can retrace the creation from its first step, data preparation 
until the creation of the outputs. More particularly, the codes follows the following steps: 

1. Data preparation: The first file "Dataset_Preparation" users the surveys already aggregated to a regional level, e.g. Sub-Saharan Africa, North America region etc., cleans the data in case needed and constructs the basic variables that are used in the next step. 

2. JOIN preparation: The second file "Join_Preparation" constructs all indicator variables that are used in step 3. 

3. JOIN Output: The third file "Join_Output" derives the JOIN indicators from the variables prepared in the two steps before. 

4. JOIN Missing: The fourth file "Join_Missing" creates the share of missing information for each of the main variables.

In case you have any questions on the code or suggestions, please feel free to get in touch.  



