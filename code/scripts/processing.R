colleges_df <- read.csv("data/colleges.csv")

options(na.action = 'na.pass')
# dummy out categorical variables 
temp_df <- model.matrix(ADM_RATE ~ ., data = colleges_df[ ,5:34])[ ,-1]

# removing column of ones, and appending regressors to Balance
new_colleges_df <- cbind(temp_df, ADM_RATE = colleges_df$ADM_RATE)

# scaling and centering
scaled_colleges <- scale(new_colleges_df, center = TRUE, scale = TRUE)
scaled_colleges <- scaled_colleges[ ,-1]


# export scaled data
write.csv(scaled_colleges, file = "data/scaled-colleges.csv", row.names = FALSE)
