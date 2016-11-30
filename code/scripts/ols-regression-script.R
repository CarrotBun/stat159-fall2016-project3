#Loading in the data. 
scaled_colleges<- read.csv("data/datasets/scaled-colleges.csv", header = TRUE)
scaled_colleges$X <- NULL
load("data/RData-files/train-test-sets.RData")

#removing the NA values from the dataset
train_nona <- complete.cases(train_set)
train_set2 <- train_set[train_nona, ]
test_nona <- complete.cases(test_set)
test_set2 <- test_set[test_nona, ]
colleges_nona <- complete.cases(scaled_colleges)
scaled_colleges2 <- scaled_colleges[colleges_nona, ]

#Creating the OLS regression model. 
ols_reg <- lm(ADM_RATE ~ ., data = train_set2)

#model selection

#AIC
step(ols_reg)

#BIC
n <- nrow(train_set2)
step(ols_reg, k = log(n))

lm_1 <- lm(ADM_RATE ~ UGDS + UGDS_BLACK + UGDS_2MOR + AGE_ENTRY + 
             UGDS_WOMEN + FIRST_GEN + FAMINC + MN_EARN_WNE_P10 + ST_FIPS6 + 
             ST_FIPS9 + ST_FIPS10 + ST_FIPS11 + ST_FIPS12 + ST_FIPS13 + 
             ST_FIPS15 + ST_FIPS17 + ST_FIPS20 + ST_FIPS21 + ST_FIPS24 + 
             ST_FIPS25 + ST_FIPS29 + ST_FIPS30 + ST_FIPS34 + ST_FIPS35 + 
             ST_FIPS36 + ST_FIPS37 + ST_FIPS39 + ST_FIPS40 + ST_FIPS48 + 
             ST_FIPS50 + ST_FIPS53 + ST_FIPS54 + ST_FIPS78 + SATVR25 + 
             SATMT25 + SATMT75 + SATWR25 + SATWR75 + completion + transfer + 
             LOCALE23 + LOCALE31 + LOCALE32 + LOCALE33 + CCUGPROF5 + CCUGPROF6 + 
             CCUGPROF7 + CCUGPROF8 + CCUGPROF9 + CCUGPROF10 + CCUGPROF11 + 
             CCUGPROF12 + CCUGPROF13 + CCUGPROF14 + CCUGPROF15 + Year2011, 
           data = train_set2)

lm_2 <- lm(ADM_RATE ~ UGDS_BLACK + UGDS_WOMEN + FAMINC + ST_FIPS6 + 
             ST_FIPS10 + ST_FIPS12 + ST_FIPS20 + ST_FIPS21 + ST_FIPS24 + 
             ST_FIPS25 + ST_FIPS30 + ST_FIPS34 + ST_FIPS35 + ST_FIPS36 + 
             ST_FIPS37 + ST_FIPS50 + ST_FIPS53 + ST_FIPS54 + ST_FIPS78 + 
             SATVR25 + SATMT25 + SATMT75 + SATWR75 + completion + transfer + 
             CCUGPROF5 + CCUGPROF6 + CCUGPROF7 + CCUGPROF8 + CCUGPROF9 + 
             CCUGPROF10 + CCUGPROF11 + CCUGPROF12 + CCUGPROF13 + CCUGPROF14 + 
             CCUGPROF15, data = train_set2)

#Now we calculate the cross validation scores for each of these two models to determine which is better at predicting. 
cv.scores = rep(NA, 2)
cv.scores[1] = sum((lm_1$residuals^2)/((1 - influence(lm_1)$hat)^2))
cv.scores[2] = sum((lm_2$residuals^2)/((1 - influence(lm_2)$hat)^2))

#The model with the smaller cv score, is the better model
which.min(cv.scores)

#In this case lm_1 is better. 
lm1_indx <- match(c("STABBRAL", "STABBRAR", "STABBRAZ", "STABBRCO", "STABBRCT", "STABBRDC", "STABBRFL",
                    "STABBRGA", "STABBRIA", "STABBRID", "STABBRIL", "STABBRIN", "STABBRLA", "STABBRMA",
                    "STABBRMD", "STABBRME", "STABBRMI", "STABBRMN", "STABBRMO", "STABBRMT", "STABBRNC", 
                    "STABBRNE", "STABBRNH", "STABBRNJ", "STABBRNM", "STABBRNV", "STABBRNY", "STABBROH",
                    "STABBROR", "STABBRPA", "STABBRRI", "STABBRSC", "STABBRSD", "STABBRTN", "STABBRTX",
                    "STABBRUT", "STABBRVA", "STABBRVI", "STABBRVT", "STABBRWA", "STABBRWI", "STABBRWV", 
                    "ZIP", "UGDS_BLACK", "UGDS_2MOR", "UGDS_WOMEN", "MARRIED", "FAMINC", "MN_EARN_WNE_P10",
                    "SATVR25", "SATMT25", "SATMT75", "SATWR25", "SATWR75", "completion", "transfer", 
                    "CCUGPROF"), names(test_set2))

#Calculating MSE 
ols_matrix_new <- test_set2[ ,lm1_indx]
ols_preditctions <- predict(lm_1, ols_matrix_new)
ols_MSE <- mean((ols_preditctions-test_set2$ADM_RATE)^2)

#Generating Coefficents
ols_summary <- summary(lm(ADM_RATE ~ ., data = scaled_colleges2))

#Generating OLS Output
sink('data/outputs/ols-regression-output.txt')
cat('MSE of OLS Regression\n')
print(ols_MSE)
cat('\nCoefficients of Full Model using OLS Regression\n')
print(ols_summary$coefficients[ ,1])
sink()


#Saving Data
save(ols_reg, ols_summary, ols_MSE, file = 'data/RData-files/ols-regression.RData')

