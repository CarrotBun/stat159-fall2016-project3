dataset = data/College
.PHONY: data

# download data file
data:
	curl -o $(dataset).zip https://ed-public-download.apps.cloud.gov/downloads/CollegeScorecard_Raw_Data.zip
	unzip $(dataset).zip -d data/raw