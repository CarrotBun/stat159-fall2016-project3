#setwd("~/stat159/project3/")
setwd("data/raw/")
library(dplyr)

data2010 <- read.csv("MERGED2010_11_PP.csv")
data2011 <- read.csv("MERGED2011_12_PP.csv")
data2012 <- read.csv("MERGED2012_13_PP.csv")
data2013 <- read.csv("MERGED2013_14_PP.csv")
data2014 <- read.csv("MERGED2014_15_PP.csv")


select_data <- function(x){
  x = select(x, OPEID, INSTNM, CITY, STABBR, ZIP,
             UGDS_WHITE, UGDS_BLACK, UGDS_HISP, UGDS_ASIAN, UGDS_AIAN, 
         UGDS_NHPI, UGDS_2MOR, UGDS_NRA, UGDS_UNKN, UGDS_WHITENH, 
         UGDS_BLACKNH, UGDS_API, UGDS_AIANOLD, UGDS_HISPOLD, AGE_ENTRY, 
         UGDS_WOMEN, MARRIED, FIRST_GEN, FAMINC, MN_EARN_WNE_P10, ST_FIPS, 
         LOCALE2, CCUGPROF, ADM_RATE, SATVR25, SATVR75, SATMT25, SATMT75, 
         SATWR25, SATWR75, C100_4, C100_L4, TRANS_4, TRANS_L4)
  x
}
data2010 <- select_data(data2010)
data2011 <- select_data(data2011)
data2012 <- select_data(data2012)
data2013 <- select_data(data2013)
data2014 <- select_data(data2014)

data2010$Year = "2010"
data2011$Year = "2011"
data2012$Year = "2012"
data2013$Year = "2013"
data2014$Year = "2014"

data <- rbind(data2010, data2011, data2012, data2013, data2014)

write.csv(data, file = "../colleges.csv")

