#setwd("~/stat159/project3/")
setwd("data/raw/")
library(dplyr)


data2008 <- read.csv("MERGED2008_09_PP.csv")
data2009 <- read.csv("MERGED2009_10_PP.csv")
data2010 <- read.csv("MERGED2010_11_PP.csv")
data2011 <- read.csv("MERGED2011_12_PP.csv")
data2012 <- read.csv("MERGED2012_13_PP.csv")
data2013 <- read.csv("MERGED2013_14_PP.csv")
data2014 <- read.csv("MERGED2014_15_PP.csv")


select_data <- function(x){
  # Select Columns Needed 
  x <- select(x, OPEID, INSTNM, CITY, STABBR, ZIP,
             UGDS_WHITE, UGDS_BLACK, UGDS_HISP, UGDS_ASIAN, UGDS_AIAN, 
         UGDS_NHPI, UGDS_2MOR, UGDS_NRA, UGDS_UNKN, AGE_ENTRY, 
         UGDS_WOMEN, MARRIED, FIRST_GEN, FAMINC, MN_EARN_WNE_P10, ST_FIPS, 
         LOCALE, CCUGPROF, ADM_RATE, SATVR25, SATVR75, SATMT25, SATMT75, 
         SATWR25, SATWR75, C100_4, C100_L4, TRANS_4, TRANS_L4)
  
  x$ZIP = gsub("-[0-9]+","", x$ZIP)
  
  # Convert data to numeric/fix format
  x[,-c(2,3,4)] <- sapply(x[,-c(2,3,4)], as.character)
  x[,-c(2,3,4)] <- sapply(x[,-c(2,3,4)], as.numeric)
  
  # Filter out rows with NA in admission rate
  x <- x[!is.na(x$ADM_RATE),]
  
  # Merge some columns
  x$completion = ifelse(is.na(x$C100_4), x$C100_L4, x$C100_4)
  x$transfer = ifelse(is.na(x$TRANS_4), x$TRANS_L4, x$TRANS_4)
  x = select(x, -C100_4, -C100_L4, -TRANS_4, -TRANS_L4)
  
  x
}


test <- select_data(data2010)
## Only 2 years have WN_EARN_WNE_P10

data2008 <- select_data(data2008)
data2009 <- select_data(data2009)
data2010 <- select_data(data2010)
data2011 <- select_data(data2011)
data2012 <- select_data(data2012)
data2013 <- select_data(data2013)
data2014 <- select_data(data2014)

locale_category <- select(data2014, OPEID, LOCALE, CCUGPROF)

apply_info <- function(x, helper){
  x <- select(x, -LOCALE, -CCUGPROF)
  merged <- left_join(x, helper, by = c("OPEID"= "OPEID"))
  merged
}

data2008 <- apply_info(data2008, locale_category)
data2009 <- apply_info(data2009, locale_category)
data2010 <- apply_info(data2010, locale_category)
data2011 <- apply_info(data2011, locale_category)
data2012 <- apply_info(data2012, locale_category)
data2013 <- apply_info(data2013, locale_category)

data2008$Year = "2008"
data2009$Year = "2009"
data2010$Year = "2010"
data2011$Year = "2011"
data2012$Year = "2012"
data2013$Year = "2013"
data2014$Year = "2014"

data <- rbind(data2008, data2009, data2010, data2011, data2012, data2013, data2014)

save(data, file = "../colleges.RData" )
write.csv(data, file = "../colleges.csv")

