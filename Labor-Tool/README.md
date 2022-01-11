# Jobs Diagnostic Labor Tool
A package to automate labor force survey analysis using the World Bank's I2D2/GLD/GMD harmonized datasets. 

- [Background](https://github.com/worldbank/Jobs-Diagnostic/tree/main/Labor-Tool/README.md#Background)
- [Install](https://github.com/worldbank/Jobs-Diagnostic/tree/main/Labor-Tool/README.md#Install)
- [FAQ](https://github.com/worldbank/Jobs-Diagnostic/tree/main/Labor-Tool/README.md#FAQ)
- [Citation](https://github.com/worldbank/Jobs-Diagnostic/tree/main/Labor-Tool/README.md#Citation)
- [Changelog](https://github.com/worldbank/Jobs-Diagnostic/tree/main/Labor-Tool/README.md#Changelog)

# Background
The Jobs Diagnostic Labor Tool (JDLT) provides standardized labor force survey analysis using the World Bank's I2D2/GLD/GMD harmonized datasets. It helps users conduct a Jobs Diagnostic [guided enquiry](https://openknowledge.worldbank.org/bitstream/handle/10986/33491/Theoretical-Underpinnings-of-Jobs-Diagnostics.pdf?sequence=1&isAllowed=y) focusing on the labor market supply side and its respective outcomes. The outputs of the tool present key labor market information ranging from labor force participation rates, types of employment, and unemployment to labor market outcomes for different population groups. The populations groups are automatically disaggregated by gender, area, age, and education. The tool processes nationally representative and harmonized surveys (World Bank I2D2, GLD, or GMD) and presents its results through indicators, figures, and regression tables, to better understand how a country's economy affects employment levels and workers. The results of the analysis are presented for each survey and over time in case of several surveys. A benchmarking between surveys from different countries is also possible. For further information on the results and their intepretation, please see the [FAQ](https://github.com/JoergLangbein/LM-Toolkit/blob/main/README.md#FAQ). 


# Install

To obtain the latest version through GitHub, from the main window in Stata, run:

net describe Labor-Tool, from("https://raw.githubusercontent.com/worldbank/Jobs-Diagnostic/main/Labor-Tool")

After download, install in Stata the Installation files

If the download from within Stata fails (e.g. because you are behind a firewall), you can always download the files directly from this repository. 


# FAQ
## How do I setup my computer and Stata?
On my computer:
- Download all Stata scripts from GitHub
- Store the input data (GLD/GMD/I2D2) in one other folder. There is an exemplary dataset in this GitHub that you can use to test the analysis.
In Stata: 
- set a global path to the data processing folder that also holds the input data by typing `global user "C:\wb007\JD\Analysis\"`. Do not forget the last backslash.
- set the country by typing `global y "country"` (e.g. `global y "Vietnam"`). 

## What do I need to do to get started? 
- type `Diagnostic` and follow the instructions on the screen
- Tip: If you work in a cloud environment, such as OneDrive, turn it off while running the package. The saving of the figures can stop the calculations.

## How is the package structured? 
After setting the global for the country and user, the next step is to prepare the datasets in the data processing folder. In order to do this, simply type `Prepare` and the datasets will undergo checks for quality and consistency before they are appended to one final dataset. Users can then select between three different types of analysis by either typing `Indicator`, `Figures` or `Regressions`.

## How do I interpret and access the results? 
All Outputs will be stored in a newly generated JDLT folder, within the country specific parent folder (e.g. ‘Vietnam’). This main folder contains five sub-folders that follow the five main questions of the [guided enquiry](https://openknowledge.worldbank.org/bitstream/handle/10986/33491/Theoretical-Underpinnings-of-Jobs-Diagnostics.pdf?sequence=1&isAllowed=y). Those questions are: 

- Question 1: What is the profile of jobs and work in the economy?
- Question 2: What is the trend in labor supply and how is it related to the country’s demography?
- Question 3: What are the trends in employment?
- Question 4: What are the trends in education and how does it affect how people work?
- Question 5: How much do workers earn from work and how do labor market outcomes compare across households?

The [guided enquiry](https://openknowledge.worldbank.org/bitstream/handle/10986/33491/Theoretical-Underpinnings-of-Jobs-Diagnostics.pdf?sequence=1&isAllowed=y) contains the theoretical underpinnings of any jobs diagnostic. Each question follows a certain logic and is explained in the linked documend. The three different commands `Indicator`, `Figures` and `Regressions` refer to different analytical tools to answer those questions. 

After typing `Indicator` in the command line in Stata an overview of main indicators relevant to the labor market is given for each survey in the first folder, named "Question 1 - Jobs and worker profile", .
Typing `Figures` provides answers to Question 2, 3, and 4. The folder are named accordingly. Typing `Regressions` gives deeper insights into the determinants of different labor market outcomes among households. Note that the commands do not need to follow any order. 


## Can I combine datasets from I2D2, GLD, GMD or with different ICLS definitions? 
The tool can be run with a mix of input datasets using different standardized surveys from the I2D2, GLD, or GMD repositories. However, users are advised to carefully explore the methodology and definitions used of the underlying survey datasets before conducting their joint analysis. 

## I want to rerun the analysis but use the already prepared dataset. What do I do? 
The prepared dataset is saved in the folder "Data". The code should automatically fetch the data from there if you do not run the `Prepare` code. However, if you are running the code on another date it may be necessary to recreate the folder structure with this data. To do this, simply run the first lines of the `Prepare` file. 

## The inflation data has changed since I last used the package and I want to update the results. What do i do? 
This is no problem. Simply delete the dataset "wbopendata" in the folder "Data" and redo the analysis starting with `Prepare`. 

## Can I benchmark my country of interest against others? 
Instead of analysing several surveys from one country, you could also analyze one survey from several countries. Include the surveys in the input dataset folder like you do for the time trend analysis. Just be aware of datasets with different definitions, either ICLS or harmonisations (see question above). 

## What Stata version do I need to run the tool? 
You would need at least Stata 14 for the package to run. 


# Citation 
Langbein, Jörg and Weber, Michael. 2021. Jobs Diagnostic Labor Tool. 


# Changelog
1.0. Is the version first published on GitHub







