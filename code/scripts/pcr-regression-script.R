library(pls)
set.seed(98765)

########################### Load Data and T-T indicies ##########################
source("code/scripts/train-test-sets-script.R")
# rows with only no NA's
train_nona = complete.cases(train_set)

########################### Run PCR and Cross Validation ##########################
pcr_train = pcr(ADM_RATE ~ ., data= train_set[train_nona, ], validation = "CV")

########################### Best lambda/model ##########################
pcr_best = which.min(pcr_train$validation$PRESS)

########################### Validation plot ##########################
png(filename = "images/cv-pcr-mse-plot.png")
validationplot(pcr_train, val.type = "MSEP", main = "PCR Cross Validated Error")
abline(v = pcr_best, lty = 2)
dev.off()

########################### Apply best model to test set ##########################

# rows with only no NA's
test_nona = complete.cases(test_set)

# get predicted admissions rates with test set
pcr_pred <- predict(pcr_train, test_set[test_nona,-114], ncomp = pcr_best)
pcr_tMSE <- mean((pcr_pred - test_set[test_nona, "ADM_RATE"])^2)

########################### Full Model ##########################
full_nona = complete.cases(scaled_colleges)
pcr_full <- pcr(ADM_RATE ~ ., data= scaled_colleges[full_nona, ], ncomp = pcr_best)


########################### output primary results ##########################
sink("data/outputs/pcr-regression-output.txt")
cat("Best Model's Lambda:\n")
pcr_best
cat("\n Test MSE:\n")
pcr_tMSE
cat("\n Official Model and Coefficients:\n")
summary(pcr_full)
cat("\n")
coefficients(pcr_full)
sink()

save(pcr_train, pcr_best, pcr_tMSE, pcr_full, file ="data/RData-files/pcr-regression.RData")




