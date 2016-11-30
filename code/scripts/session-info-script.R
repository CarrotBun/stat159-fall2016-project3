# Loading Packages that are Used 
library(ggplot2)
library(xtable)
library(glmnet)
library(pls)
library(testthat)
library(png)
library(grid)
library(knitr)
library(rmarkdown)
library(reshape)
library(Matrix)

# Generating Session-Info.txt
sink("../../session-info.txt", append = TRUE)
cat("Session Information\n\n")
print(sessionInfo())
devtools::session_info()
sink()
