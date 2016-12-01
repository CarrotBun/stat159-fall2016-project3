#In this script we have some functions to calcualte some important statistic that can apply 
#to different models, like lasso and principal components.

#This function calculates the fitted values or predicted values (if new data is given) given a model.
predictions <- function(x, ...){
  predict(x, ...)
}

#This function takes the values from the previous function and computes the mean squared errors.
mean_squared_error <- function(x, y, ...){
  mean((predictions(x, ...)-y)^2)
}

#This function calculates the root mean squared.
rt_mean_squared <- function(x, y, ...){
  sqrt(mean_squared_error(x, y, ...))
}

#This function calculates the residual sum of squares
residual_sum_squares <- function(x, y, ...){
  sum((predictions(x, ...)-y)^2)
}
