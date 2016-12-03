## Comparing Different Regression Models 

Project Name: stat159-fall2016-project3

Authors: Erica Wong, Elly Wang, Bryana Gutierrez, and Lily Li

Description: This project was created for the purpose of analyzing school data for our clients: a group of school administrators. In order to present to them what attributes they need to work on to improve the competiveness of their school we show them how like schools compare. To do this we look at all colleges listed in the data from College Scorecard, a link for which can he found [here](https://collegescorecard.ed.gov/). We look at college demographic, geographic, academic, and other information to build regression models for admission rates. The lower admission rates, the more competitive a school is. These models will help us, as consultatnts, decide how to best help the needs of the administrators. We perform ordinary least squares, ridge, lasso, principal components, and partial least sqaures regression analysis. 

Organization:
* Code: This folder contains all of our R Scripts. Within the code folder, the scripts are further divided into functions, scripts, and tests.
* Data: This folder contains all of the different data files were produced in this project. Within the data folder, the outputs are further seperated into datasets, outputs, and RData-files.
* .gitignore: In the .gitignore file, we would put files and directories that we want to ignore in Git. In this project, we want to ignore files such as .Rhistory and .DS_Store and large data files like college.zip which is too large for Git Hub.
* Images: This folder contains all of my plots and charts that were made throughout the project in PNG form.
* Makefile: This files contains the commands that will run our R scripts and allow for reproducibility. Additonally, through Makefile, we are going to produce everything that exists in the data folder and the report.
* LICENSE: This document contains the full BSD-2-Clause for our project.  
* Report: This file contains the report for this project in both .Rnw and .pdf form. Additonally, because we wrote the Report.Rnw in different sections, there is a sections folder that contains all of the different parts of our report. 
* session-info.txt: This document contains information about all of the softwares that we used in this project.
* slides: In this folder, you will find the presentation for this project in Rmd and HTML format via ioslides. 

Instructions on How to Reproduce (Assuming you have already have all the scripts made and ready to use):

1. First start off by cloning our project. To do this you will type `https://github.com/ellywjy/stat159-fall2016-project3` into your terminal.
2. Next, to reproduce our report, you will first have to start by deleting the report that we already have in our project. To do this, run the command `make clean`.
3. Then, you will run through all of the different scripts just to make sure that everything is up to date and that you have a version of each of the output files you will do this by `make data eda session processing traintest regressions`
4. In this project, we also had to create tests to be tested under testthat functions. To run the test-that tests, run the command `make tests`.
5. Now you are ready to generate the report. To make the report, run the command `make report`, this will run the report.Rnw and generate the report.pdf.
6. For presentation, you can run `make slides` to generate the HTML presentation slides.
7. To run the applet, run the command `make applet` to run the shiny app in terminal. To see the applet, open up the browser and go to the address at which the app is "listening on". For example, if terminal shows "Listening on http://127.0.0.1:4355", you should go to "http://127.0.0.1:4355/" to see the app (note the forward slash at the end). To terminate, use cltr+C.  

Note: All the scripts in this project that involves randomization used `set.seed()` to assure reproducibility of the results. 

List of Make Commands for Phony Targets:
If you type `make` followed by a phony target you will get the following results.

* `make all`: This will tell make which are the main targets to run.
* `make data`: This target downloads the credit data. 
* `make cleaning`: This target will clean up all the data files so that we only have the data we need.
* `make processing`: This target takes in the credit data set loaded in the data target and standardizes it.
* `make traintest`: This target assigns the file outout for the output of the data processing script.
* `make tests`: This target will run the script file that has command to run the tests of the regression functions.
* `make eda`: This target will run the script eda-script.R. This will output eda-out.txt which contains exploratory information and eda-correlation-matrix.txt.
* `make ols`: This target will run the script ols-regression-script.R which will run the OLS regression analysis. here are two data outputs for this analysis, ols-regression-output.txt and  ols-regression.RData which contain information about the regression analysis. 
* `make ridge`: This target will run the script ridge-regression-script.R which will run the ridge regression analysis. There are two data outputs for this analysis, ridge-regression-output.txt and ridge-regression.RData which contain information about the regresison analysis.
* `make lasso`: This target will run the script lasso-regression-script.R which will run the lasso regression analysis. There are two data outputs for this analysis, lasso-regression-output.txt and lasso-regression.RData which contain information about the regression analysis.
* `make pcr`: This target will run the script pc-regression-script.R which will run the principal components regression analysis. There are two data outputs for this analysis, pc-regression-output.txt and pc-regression.RData which contain information about the regression analysis.
* `make plsr`: This target will run the script pls-regression-script.R which will run the partial least squares regression analysis. There are two data outputs for this analysis, pls-regression-output.txt and pls-regression.RData which contain information about the regression analysis.
* `make regressions`: This target will run the targets ols, ridge, lasso, pcr, and plsr. It will run all the regression scripts and generate their data outputs.
* `make report`: This target will generate the final reports report.pdf and report.html from report.Rmd which will be creates from the section files pasted together.
* `make slides`: This target will generate the html version of the report slides.
* `make session`: This target will output session-info.txt. 
* `make clean`: This target will delete the generated reports, report.pdf and report.html.

Licenses:  

![License](https://i.creativecommons.org/l/by-nc/4.0/88x31.png)

All media in this work is licensed under a [Creative Commons Attribution-NonCommercial 4.0 International](https://creativecommons.org/licenses/by-nc/4.0/legalcode).  

All code is licensed under BSD-2-Clause, more information about this license can be found in the License file.


