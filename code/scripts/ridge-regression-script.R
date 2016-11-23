# Inital Set-Up for Code
library(glmnet)
load('data/RData-files/train-test-sets.RData')
set.seed(98765)
data <- read.csv('data/colleges.csv', header = TRUE)
data$X <- NULL

# Running cv.glmnet()
grid <- 10^seq(10, -2, length = 100) 
ridge_matrix <- as.matrix(train_set[ ,-22])
cv_ridge <- cv.glmnet(x = ridge_matrix, y = train_set$Balance, lambda = grid,
                      intercept = FALSE, standardize = FALSE, alpha = 0)
# We set alpha = 0 because in ridge regression, elasticity for ridge regression is 0.

# Saving the Output
lambda_min_ridge <- cv_ridge$lambda.min
cv_ridge_coef <- coef(cv_ridge, s = cv_ridge$lambda.min)

# Plotting Ridge Regression
png('images/cv-ridge-mse-plot.png')
plot(cv_ridge)
dev.off()

# Calculating the MSE
ridge_matrix_new <- as.matrix(test_set[ ,-12])
ridge_preditctions <- predict(cv_ridge,ridge_matrix_new, s = lambda_min_ridge)
ridge_MSE <- mean((ridge_preditctions-test_set$Balance)^2)

# Re-Fitting the Model on the Full Data Set
full_model <- as.matrix(scaled_credit[ ,-12])
ridge_fit <- glmnet(x = full_model, y = scaled_credit$Balance, lambda = lambda_min_ridge,
                    intercept = FALSE, standardize = FALSE, alpha = 0)
ridge_coef_full <- coef(ridge_fit, s = lambda_min_ridge)

# Saving Data and Generating an Output
save(lambda_min_ridge, cv_ridge, ridge_MSE, ridge_coef_full,file = 'data/RData-files/ridge-regression.RData')

sink('data/outputs/ridge-regression-output.txt')
cat('Output of 10-fold Cross-Validation using Ridge Regression on the Train Data Set\n')
print(cv_ridge)
cat('\nMinimum Lambda that will help us find Best Model\n')
print(lambda_min_ridge)
cat('\nRidge MSE of Test Data Set\n')
print(ridge_MSE)
cat('\nOfficial Coefficients of Full Model using Ridge Regression\n')
print(ridge_coef_full)
sink()