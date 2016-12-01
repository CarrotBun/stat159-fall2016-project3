dataset = data/datasets/college
rawData = data/raw
extradata20 = $(wildcard data/raw/MERGED200*.csv)
extradata19 = $(wildcard data/raw/MERGED19*.csv)
dataout = data/outputs
codescr = code/scripts
dataR = data/RData-files
reprnw = report/report.Rnw
reppdf = report/report.pdf
sections = report/sections/*

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


# This target will run the script lasso-regression-script.R which will run the lasso regression analysis. There are two data outputs for this analysis, lasso-regression-output.txt and lasso-regression.RData which contain information about the regression analysis.
lasso: $(dataout)/lasso-regression-output.txt $(dataR)/lasso-regression.RData

# This is the target that creates the output lasso-regression-output.txt.
$(dataout)/lasso-regression-output.txt: $(codescr)/lasso-regression-script.R
	Rscript $(codescr)/lasso-regression-script.R

# This is the target that creates the output lasso-regression.RData.
$(dataR)/lasso-regression.RData:
	Rscript $(codescr)/lasso-regression-script.R


# This target will run the script pcr-regression-script.R which will run the principal components regression analysis. There are two data outputs for this analysis, pcr-regression-output.txt and pcr-regression.RData which contain information about the regression analysis.
pcr: $(dataout)/pcr-regression-output.txt $(dataR)/pcr-regression.RData

# This is the target that creates the output pcr-regression-output.txt.
$(dataout)/pcr-regression-output.txt: $(codescr)/pcr-regression-script.R
	Rscript $(codescr)/pcr-regression-script.R

# This is the target that creates the output pcr-regression.RData.
$(dataR)/pcr-regression.RData:
	Rscript $(codescr)/pcr-regression-script.R


# This target will run the script pls-regression-script.R which will run the partial least squares regression analysis. There are two data outputs for this analysis, pls-regression-output.txt and pls-regression.RData which contain information about the regression analysis.
plsr: $(dataout)/pls-regression-output.txt $(dataR)/pls-regression.RData

# This is the target that creates the output pls-regression-output.txt.
$(dataout)/pls-regression-output.txt: $(codescr)/pls-regression-script.R
	Rscript $(codescr)/pls-regression-script.R

# This is the target that creates the output pls-regression.RData.
$(dataR)/pls-regression.RData:
	Rscript $(codescr)/pls-regression-script.R

# This target will run the targets ols, ridge, lasso, pcr, and plsr. It will run all the regression scripts and generate their data outputs.
regressions: 
	make ols
	make ridge
	make lasso
	make pcr
	make plsr

# This target will generate the final reports report.pdf from report.Rnw which will be creates from the section files pasted together.
report: $(reprnw) $(reppdf)

# This target will take in all the sections of the report and create the file report.Rnw which will paste all the files together.
$(reprnw): $(sections)
	cat $(sections) > $(reprnw)

# This target will take the Rnw file report.Rnw and will knit the pdf document report.pdf
$(reppdf): $(reprnw)
	Rscript -e "library(rmarkdown); render('$(reprnw)', output_format = 'pdf_document')"

# This target will generate the html version of the report slides.
slides: slides/presentation.html

# This target will generate the presentation in html output. 
slides/presentation.html: 
	Rscript -e "library(rmarkdown); render('slides/presentation.Rmd')"

# This target will output session-info.txt. 
session: session-info.txt

# This target allocates a target file for the output of sesison.sh
session-info.txt: $(codescr)/session.sh
	bash $(codescr)/session.sh

# This target will delete the generated report, report.pdf.
clean: 
	rm -f $(reppdf)

