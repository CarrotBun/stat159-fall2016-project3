#This code will parse out what data is used for the train or tests sets. 
#The train set will be used to build the model, and the test will be used to test the model. 

#Loading in the data to be parsed. 
scaled_colleges <- read.csv('data/datasets/scaled-colleges.csv', header = TRUE)
scaled_colleges$X <- NULL

#creating a sample of indices 
set.seed(98765)
indx <- sample(1:nrow(scaled_colleges), round(.75*nrow(scaled_colleges), digits = 0))

#creating a train set using the indices chosen from the sample above. 
train_set <- scaled_colleges[indx, ]

#creating a test set from the indices not chosen from the sample above. 
test_set <- scaled_colleges[-indx, ]

#Saving the data sets.
save(train_set, test_set, file = "data/RData-files/train-test-sets.RData")
