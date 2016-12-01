#Loading the appropriate packages
library(testthat)
library(pls)

#Here I initialize the values that I will be using to test my regression functions. 
#We chose to test the functions using the plsr model, but these functions work for the other models as well.
reg <- plsr(mpg ~ disp + hp, data = mtcars)
ncomp <- 1

#loading in the functions to be tested.
source("../functions/general-regression-functions.R")

context("Testing the functions in general-regression-functions.R that calculate regression statistics")
test_that("Testing the predictions function to see if correctly calculates the fitted values", {
  expect_equal(predictions(reg, ncomp = ncomp)[ , , 1], reg$fitted.values[, , 1])
  expect_length(predictions(reg, ncomp = ncomp), 32)
  expect_type(predictions(reg, ncomp = ncomp), "double")
})

test_that("Testing the mean_squared_error function to see if correctly calculates the MSE", {
  expect_equal(mean_squared_error(reg, mtcars$mpg, ncomp = ncomp), mean(reg$residuals[ , , 1]^2))
  expect_length(mean_squared_error(reg, mtcars$mpg, ncomp = ncomp), 1)
  expect_type(mean_squared_error(reg, mtcars$mpg, ncomp = ncomp), "double")
})

test_that("Testing the rt_mean_squared function to see if correctly calculates the RMSE", {
  expect_equal(rt_mean_squared(reg, mtcars$mpg, ncomp = ncomp), sqrt(mean(reg$residuals[ , , 1]^2)))
  expect_length(rt_mean_squared(reg, mtcars$mpg, ncomp = ncomp), 1)
  expect_type(rt_mean_squared(reg, mtcars$mpg, ncomp = ncomp), "double")
})

test_that("Testing the residual_sum_squares function to see if correctly calculates the RSS", {
  expect_equal(residual_sum_squares(reg, mtcars$mpg, ncomp = ncomp), sum(reg$residuals[ , , 1]^2))
  expect_length(residual_sum_squares(reg, mtcars$mpg, ncomp = ncomp), 1)
  expect_type(residual_sum_squares(reg, mtcars$mpg, ncomp = ncomp), "double")
})
