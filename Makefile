dataset = data/datasets/College
rawData = data/raw
extradata20 = $(wildcard data/raw/MERGED200*.csv)
extradata19 = $(wildcard data/raw/MERGED19*.csv)
dataout = data/outputs
codescr = code/scripts
dataR = data/RData-files

.PHONY: all data cleaning processing eda session traintest ridge ols

all: data cleaning processing

# download data file
data:
	curl -o $(dataset).zip https://ed-public-download.apps.cloud.gov/downloads/CollegeScorecard_Raw_Data.zip
	unzip -u $(dataset).zip -d $(rawData)
	rm -f $(rawData)/Crosswalks_20160908.zip
	
cleaning: 
	rm -f $(extradata19) 
	Rscript code/scripts/cleaning.R

processing:
	Rscript code/scripts/processing.R

# This target will output session-info.txt. 
session: session-info.txt

# This target allocates a target file for the output of sesison.sh
session-info.txt: $(codescr)/session.sh
	bash $(codescr)/session.sh

# This target takes the scaled data set and creates train and test sets. 
traintest: data/RData-files/train-test-sets.RData

data/RData-files/train-test-sets.RData: $(codescr)/train-test-sets-script.R
	Rscript $(codescr)/train-test-sets-script.R

# This target will run the script eda-script.R. This will output eda-out.txt which contains exploratory information and eda-correlation-matrix.txt. For this reason, we made two separate targets with the two output files.

eda: $(dataout)/eda-output.txt $(dataout)/eda-correlation-matrix.txt

# This target is for the output eda-output.txt.
$(dataout)/eda-output.txt: $(codescr)/eda-script.R
	Rscript $(codescr)/eda-script.R

# This target is for the eda-correlation-matrix.txt output. 
$(dataout)/eda-correlation-matrix.txt: $(codescr)/eda-script.R
	Rscript $(codescr)/eda-script.R 

# This target will run the script ols-regression-script.R which will run the OLS regression analysis. There are two data outputs for this analysis, ols-regression-output.txt and  ols-regression.RData which contain information about the regression analysis. 
ols: $(dataout)/ols-regression-output.txt $(dataR)/ols-regression.RData

# This is the target that creates the output ols-regression-output.txt.
$(dataout)/ols-regression-output.txt: $(codescr)/ols-regression-script.R
	Rscript $(codescr)/ols-regression-script.R

# This is the target that creates the output ols-regression.RData. 
$(dataR)/ols-regression.RData: $(codescr)/ols-regression-script.R
	Rscript $(codescr)/ols-regression-script.R


# This target will run the script ridge-regression-script.R which will run the ridge regression analysis. There are two data outputs for this analysis, ridge-regression-output.txt and ridge-regression.RData which contain information about the regression analysis.
ridge: $(dataout)/ridge-regression-output.txt $(dataR)/ridge-regression.RData

# This is the target that creates the output ridge-regression-output.txt.
$(dataout)/ridge-regression-output.txt: $(codescr)/ridge-regression-script.R
	Rscript $(codescr)/ridge-regression-script.R

# This is the target that creates the output ridge-regression.RData.
$(dataR)/ridge-regression.RData: $(codescr)/ridge-regression-script.R
	Rscript $(codescr)/ridge-regression-script.R

