#Loading in the required packages and data
library(pls)
load('data/RData-files/train-test-sets.RData')
scaled_colleges <- read.csv('data/datasets/scaled-colleges.csv')
scaled_colleges$X <- NULL

#removing the NA values from the dataset
train_nona <- complete.cases(train_set)
train_set2 <- train_set[train_nona, ]
test_nona <- complete.cases(test_set)
test_set2 <- test_set[test_nona, ]
colleges_nona <- complete.cases(scaled_colleges)
scaled_colleges2 <- scaled_colleges[colleges_nona, ]

#setting a random seed to run the ten-cross validation 
set.seed(27182)

#fitting a partial least squares regression to the training data: 
cv_pls <- plsr(ADM_RATE ~ ., data = train_set2, validation = 'CV')

#finding the "best" model which looks at the cross validated models
lambda_min_pls <- which.min(cv_pls$validation$PRESS)

#uploading an image of the MSE Plot
png(filename = 'images/cv-pls-mse-plot.png')
validationplot(cv_pls, val.type = 'MSEP')
dev.off()

#Using the model above to test using the test data set. 
pls_predictions <- predict(cv_pls, newdata = test_set2, ncomp = lambda_min_pls)

#Finding the MSE of the test data model fit. 
pls_mse <- mean((pls_predictions-test_set2$ADM_RATE)^2)

#Now we find the official coefficents by using the model calculated above on the full 
#data set
pls_fit <- plsr(ADM_RATE ~ ., data = scaled_colleges2, ncomp = lambda_min_pls)

#finding the official coefficients: 
pls_coef_full <- coef(pls_fit)

#saving these coefficients into an RData file
save(cv_pls, lambda_min_pls, pls_mse, pls_coef_full, file = 'data/RData-files/pls-regression.RData')

#Now we want to make a text file of the intermediary step of this regression analysis: 
sink(file = 'data/outputs/pls-regression-output.txt')
cat('This is the output of the ten-fold cross validation using Lasso regression\n on the training data set\n')
print(summary(cv_pls))
cat('\nThis is the minimum lambda that represents the "best" model\n')
print(lambda_min_pls)
cat('\nThis is the MSE of the testing data set when the training model is implemented\n')
print(pls_mse)
cat('\nThese are the official coefficients calcualted using the "best" model lambda and the full datset')
print(pls_coef_full)
sink()
