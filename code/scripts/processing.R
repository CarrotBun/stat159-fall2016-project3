#setwd("~/stat159/project3/")
colleges_df <- read.csv("data/datasets/colleges.csv")
source("code/functions/cleaning-helpers.R")

colleges_df <- factor_this(colleges_df)

options(na.action = 'na.pass')
# dummy out categorical variables 
temp_df <- model.matrix(ADM_RATE ~ ., data = colleges_df[ ,7:35])[ ,-1]

# removing column of ones, and appending regressors to Balance
new_colleges_df <- cbind(temp_df, ADM_RATE = colleges_df$ADM_RATE)

# scaling and centering
scaled_colleges <- scale(new_colleges_df, center = TRUE, scale = TRUE)

# export scaled data
write.csv(scaled_colleges, file = "data/datasets/scaled-colleges.csv", row.names = FALSE)
save(scaled_colleges, file = "data/RData-files/scaled-colleges.RData")

