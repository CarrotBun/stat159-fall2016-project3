#This file contains functions that calculate regression statistics. All of the functions 
#below take a lm class object as an input. Therefore, certain attributes specific to lm
#variables are used. i.e. I used x$residuals because an object of class lm has this attribute. 

#This function calculates the RSS or the residual sum of squares, which sqaures the 
#residuals and adds them. 
residual_sum_squares <- function(x){
  sum(x$residuals^2)
}

#This function calculates the tSS or the total sum of squares. 
#This is the sum of the squared difference between the y values and their mean. 
total_sum_squares <- function(x){
  sum((x$model[ ,1]-mean(x$model[ ,1]))^2) 
}

#This function calculates the R^2 statistic which is calculated from the TSS and RSS. 
#The R^2 statistic is 1-RSS/TSS. This output is between zero and one. 
r_squared <- function(x){
  1-residual_sum_squares(x)/total_sum_squares(x)
}

#This function calculates the F statistic, which is calcualted using the the RSS and th TSS
#The statistic is the ratio of (TSS-RSS)/(p) to RSS/(n-p-1) where p is the number of 
#explanatory variables in the model and n is the number of data samples.
f_statistic <- function(x){
  top <- (total_sum_squares(x) - residual_sum_squares(x))/(x$rank-1)
  bottom <- residual_sum_squares(x)/x$df.residual
  top/bottom
}

#This function calculates the RSE using the RSS. The RSE is thw square root of the RSS/(n-p-1)
#where n and p are as defined above.
residual_std_error <- function(x){
  sqrt(residual_sum_squares(x)/x$df.residual)
}
