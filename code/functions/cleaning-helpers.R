# select_data will take the raw files from college scorecard and ...
# 1. select the columns needed for this project
# 2. convert necessary columns to character and numeric
# 3. ZIP codes will be restricted to 5 digit only. 12345-XXXX x's will be removed
# 4. schools with no admissions data will be removed
# 5. completioin and transfer rates for different programs will be merged.

select_data <- function(x){
  # Select Columns Needed 
  x <- select(x, OPEID, INSTNM, CITY, STABBR, ZIP, UGDS,
             UGDS_WHITE, UGDS_BLACK, UGDS_HISP, UGDS_ASIAN, UGDS_AIAN, 
         UGDS_NHPI, UGDS_2MOR, UGDS_NRA, UGDS_UNKN, AGE_ENTRY, 
         UGDS_WOMEN, MARRIED, FIRST_GEN, FAMINC, MN_EARN_WNE_P10, ST_FIPS, 
         LOCALE, CCUGPROF, ADM_RATE, SATVR25, SATVR75, SATMT25, SATMT75, 
         SATWR25, SATWR75, C100_4, C100_L4, TRANS_4, TRANS_L4)

  x$ZIP = gsub("-[0-9]+","", x$ZIP)
  # Convert data to numeric/fix format
  x[,-c(2,3,4)] <- sapply(x[,-c(2,3,4)], as.character)
  x[,-c(2,3,4,5)] <- sapply(x[,-c(2,3,4,5)], as.numeric)
  
  # Filter out rows with NA in admission rate
  x <- x[!is.na(x$ADM_RATE),]
  
  # Merge some columns
  x$completion = ifelse(is.na(x$C100_4), x$C100_L4, x$C100_4)
  x$transfer = ifelse(is.na(x$TRANS_4), x$TRANS_L4, x$TRANS_4)
  x = select(x, -C100_4, -C100_L4, -TRANS_4, -TRANS_L4)
  
  x
}

# Factor_this will ensure setting information, ID, and year data are factors
factor_this <- function(x){
  x$LOCALE = as.factor(x$LOCALE)
  x$ZIP = as.factor(x$ZIP)
  x$CCUGPROF = as.factor(x$CCUGPROF)
  x$ST_FIPS = as.factor(x$ST_FIPS)
  x$OPEID = as.factor(x$OPEID)
  x$Year = as.factor(x$Year)
  x
}

# Apply_info will take in a data frame and helper data frame and merge 
# locale and classification information from 2014-2015 to all previous years
# where data is not available.
apply_info <- function(x, helper){
  x <- select(x, -LOCALE, -CCUGPROF)
  merged <- left_join(x, helper, by = c("OPEID"= "OPEID"))
  merged
}
