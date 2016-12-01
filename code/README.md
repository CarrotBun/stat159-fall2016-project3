Code

This directory contains all the code for our regression analyses. This directory contains three directories and one stand alone file.
Scripts:
* eda-script.R which creates eda-output.txt and creates the images of histograms. This code is used to explore the variables to be used in the linear regression to see if they are good candidates for a linear model.
* data-processing-script.R which took in the raw credit data and cleaned it up. This created the scaled-creditdata to be used in the regression analyses.
* train-test-sets-script.R which takes the scaled-credit data from data-processing-script.R and creates two sets, one training and one test. These sets are used in the lasso, ridge, PC and PLS regression analyses.
* ols-regression-script.R which produces the least squares regression analysis.
* ridge-regression-script.R which conducts the ridge regression analysis.
* lasso-regression-script.R which conducts the lasso regression analysis.
* pc-regression-script.R which conducts the principal component regression analysis.
* pls-regression-script.R which conducts the partial least squares regression analysis. 
* session-info-script.R which exports information about the session into a separate text file session-info.txt. This includes information about R, pandoc, latex, etc.
* session.sh which contains commands that help to create our session-info.txt

Functions:
* cleanig-helpers.R which contains functions that take in the raw data and extract the information needed for this analysis.
* ols-ression-functions.R which contains several functions that calculate statistics on a least squares regression object.
* general-regression-functions.R which contains several functions that calculate statistics on a general model. This works for all the models used in this project.

Tests:
* ols-regression-test.R which has tests via testthat that test whether the functions of ols-regression-functions.R are calculating correctly.
* general-regression-test.R which has tests via testthat that test whether the functions of general-regression-functions.R are calcualting correctly. 

test-that.R:
This file runs the code of the test function ols-regression-test.R and general-regression-test.R. This script essentially runs the test of the functions.

