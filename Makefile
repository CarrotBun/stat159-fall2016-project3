dataset = data/College
rawData = data/raw
extradata20 = $(wildcard data/raw/MERGED200*.csv)
extradata19 = $(wildcard data/raw/MERGED19*.csv)

.PHONY: all data cleaning

all: data cleaning

# download data file
data:
	curl -o $(dataset).zip https://ed-public-download.apps.cloud.gov/downloads/CollegeScorecard_Raw_Data.zip
	unzip -u $(dataset).zip -d $(rawData)
	rm -f $(rawData)/Crosswalks_20160908.zip
	
cleaning: 
	rm -f $(extradata19) 
	Rscript code/scripts/cleaning.R
