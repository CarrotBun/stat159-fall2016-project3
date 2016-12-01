#Loading the appropriate packages
library(testthat)

#Here I initialize the values that I will be using to test my regression functions. 
reg <- lm(mpg ~ disp + hp, data = mtcars)
regsum <- summary(reg)

#loading in the functions to be tested.
source("../functions/ols-regression-functions.R")

context("Testing the functions in regression-functions.R that calculate regression statistics")
test_that("Testing residual_sum_squares function to see if correctly calculates RSS", {
  expect_equal(residual_sum_squares(reg), sum(reg$residuals^2))
  expect_length(residual_sum_squares(reg), 1)
  expect_type(residual_sum_squares(reg), "double")
})

test_that("Testing that total_sum_squares correctly calculates TSS", {
  expect_equal(total_sum_squares(reg), sum((mtcars$mpg - mean(mtcars$mpg))^2))
  expect_length(total_sum_squares(reg), 1)
  expect_type(total_sum_squares(reg), "double")
})

test_that("Testing that the function r_squared correctly computes the R^2 statistic", {
  expect_equal(r_squared(reg), regsum$r.squared)
  expect_length(r_squared(reg), 1)
  expect_type(r_squared(reg), "double")
})

test_that("Testing that the function f_statistic correctly calculates the F statistic", {
  expect_equivalent(f_statistic(reg), regsum$fstatistic[1])
  expect_length(f_statistic(reg), 1)
  expect_type(f_statistic(reg), "double")
})

test_that("Testing that the function residual_std_error correctly calculates the RSE", {
  expect_equal(residual_std_error(reg), regsum$sigma)
  expect_length(residual_std_error(reg), 1)
  expect_type(residual_std_error(reg), "double")
})

