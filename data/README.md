## Overview of Data Folder

In this folder, you will find all of the different data files that were used and produced in this project.

### Files in this Folder

This folder is further divided into 3 different folders.

* datasets: This folder contains the data that we are working with in the final project.
    * college.zip: This contains all the data loaded from [here](https://collegescorecard.ed.gov/). This data contains information about colleges including college admition rates which is the variable we are most interested in. 
    * college.csv: This is a simplified and compiled version of college.zip. It contains only the college information that we consider important towards this regression analysis.
    * scaled-college.csv: This is a cleaned, centered, and standarized version of college.csv. In this csv, we have converted factors into dummy variables, centered the mean, and standardized our data. When we are doing our analysis for our regression models, this is the dataset that we are using. 
* outputs: This folder contains all of the outputs that are generated from the different scripts we wrote for this project. This folder contains all five of the different regression outputs that were created when we did regression via ordinary least squares, ridge, lasso, principal components, and partial least squares regression. Additionally, it has the eda-output.txt generated from our eda-regression-script.R, which contains the summary of the quantitative varaibles, frequencies and relative frequencies of qualitative varaibles, and the relationship between balance the qualitative variables.
* RData-files: This folder contains all of the R binary format files of our regression objects that were created in our various regression scripts.

