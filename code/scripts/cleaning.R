#setwd("~/stat159/project3/")
# Set Directory
setwd("data/raw/")

# Load necessary library
library(dplyr)

# Load functions
source("../../code/functions/cleaning-helpers.R")

# Read raw files for 2008-2014
data2008 <- read.csv("MERGED2008_09_PP.csv")
data2009 <- read.csv("MERGED2009_10_PP.csv")
data2010 <- read.csv("MERGED2010_11_PP.csv")
data2011 <- read.csv("MERGED2011_12_PP.csv")
data2012 <- read.csv("MERGED2012_13_PP.csv")
data2013 <- read.csv("MERGED2013_14_PP.csv")
data2014 <- read.csv("MERGED2014_15_PP.csv")


# Select only necessary columns from original data
data2008 <- select_data(data2008)
data2009 <- select_data(data2009)
data2010 <- select_data(data2010)
data2011 <- select_data(data2011)
data2012 <- select_data(data2012)
data2013 <- select_data(data2013)
data2014 <- select_data(data2014)

# Locale and CCUGPROF is only available for 2014, extra info to apply to other years
locale_category <- select(data2014, OPEID, LOCALE, CCUGPROF)

# Apply LOCALE and CCUGPROF info to all other years
data2008 <- apply_info(data2008, locale_category)
data2009 <- apply_info(data2009, locale_category)
data2010 <- apply_info(data2010, locale_category)
data2011 <- apply_info(data2011, locale_category)
data2012 <- apply_info(data2012, locale_category)
data2013 <- apply_info(data2013, locale_category)

# Add year information before merge
data2008$Year = "2008"
data2009$Year = "2009"
data2010$Year = "2010"
data2011$Year = "2011"
data2012$Year = "2012"
data2013$Year = "2013"
data2014$Year = "2014"

# combine all years' data together
data <- rbind(data2008, data2009, data2010, data2011, data2012, data2013, data2014)
# make sure certain columns are factored
data <- factor_this(data)

# saving data in both RData and csv files
save(data, file = "../RData-files/colleges.RData" )
write.csv(data, file = "../datasets/colleges.csv")

