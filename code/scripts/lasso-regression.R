library(glmnet)
set.seed(98765)

########################### Load Data and T-T indicies ##########################
source("code/scripts/train-test-sets-script.R")
# rows with only no NA's
train_nona = complete.cases(train_set)


# lasso regression
source("code/scripts/Train-Test.R")

grid = 10^seq(10, -2, length = 100)
lasso_train = cv.glmnet(x = as.matrix(train_set[train_nona,1:83]), 
                        y = as.vector(train_set[train_nona, 84]), 
                      intercept = FALSE,
                      standardize = FALSE, 
                      lambda = grid)
# min lambda
lasso_best = lasso_train$lambda.min

# plot CV errors MSEP
png("images/lasso-validation.png")
plot(lasso_train)
dev.off()

# rows with only no NA's
test_nona = complete.cases(test_set)

############################ prediction plot ###########################
png("images/lasso-prediction-plot.png")
plot(predict(lasso_train, as.matrix(test_set[test_nona, -84]), s = "lambda.min"), type = "l"
     , col = "red",main = "Predicted and Actual Admissions Rate", 
     ylab = "Normalized Admissions Rate")

lines(test_set[test_nona, 84], col = "black")

legend(0, 3, legend = c("Predicted", "Actual"), fill = c("red", "black"), bty = "n")
dev.off()


lasso_pred = predict(lasso_train, as.matrix(test_set[test_nona, -84]), s = lasso_best)

# test MSE
lasso_tMSE = mean((lasso_pred - test_set[test_nona, 84])^2) 

# refit model on full data set
full_nona = complete.cases(scaled_colleges)
lasso_full= glmnet(as.matrix(scaled_colleges[full_nona,-84]), as.matrix(scaled_colleges[full_nona, 84]), 
                        intercept = FALSE, standardize = FALSE, lambda = lasso_best)


# save to RData
save(lasso_train, lasso_best, lasso_tMSE, lasso_full, file = "data/Lasso-Regression.RData")


# save to textfile
sink("data/lasso-output.txt")
cat("\n Best Lamba:")
lasso_best
cat("\n Lasso test MSE:")
lasso_tMSE
cat("\n Official Coefficients")
coef(lasso_full)
sink()



