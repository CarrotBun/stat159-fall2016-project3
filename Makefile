dataset = data/datasets/College
rawData = data/raw
extradata20 = $(wildcard data/raw/MERGED200*.csv)
extradata19 = $(wildcard data/raw/MERGED19*.csv)
dataout = data/outputs
codescr = code/scripts

.PHONY: all data cleaning eda

all: data cleaning

# download data file
data:
	curl -o $(dataset).zip https://ed-public-download.apps.cloud.gov/downloads/CollegeScorecard_Raw_Data.zip
	unzip -u $(dataset).zip -d $(rawData)
	rm -f $(rawData)/Crosswalks_20160908.zip
	
cleaning: 
	rm -f $(extradata19) 
	Rscript code/scripts/cleaning.R

# This target will run the script eda-script.R. This will output eda-out.txt which contains exploratory information and eda-correlation-matrix.txt. For this reason, we made two separate targets with the two output files.

eda: $(dataout)/eda-output.txt $(dataout)/eda-correlation-matrix.txt

# This target is for the output eda-output.txt.
$(dataout)/eda-output.txt: $(codescr)/eda-script.R
	Rscript $(codescr)/eda-script.R

# This target is for the eda-correlation-matrix.txt output. 
$(dataout)/eda-correlation-matrix.txt: $(codescr)/eda-script.R
	Rscript $(codescr)/eda-script.R 
