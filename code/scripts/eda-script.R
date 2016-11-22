# Loading Data and Necessary Packages
data <- read.csv('data/colleges.csv', header = TRUE)
data$X <- NULL
library(ggplot2)

# Correlation Matrix between Quantitative Variables
data$UGDS_WHITE <- as.numeric(data$UGDS_WHITE)
data$UGDS_BLACK <- as.numeric(data$UGDS_BLACK)
data$UGDS_HISP <- as.numeric(data$UGDS_HISP)
data$UGDS_ASIAN <- as.numeric(data$UGDS_ASIAN)
data$UGDS_AIAN <- as.numeric(data$UGDS_AIAN)
data$UGDS_2MOR <- as.numeric(data$UGDS_2MOR)
data$UGDS_NRA<- as.numeric(data$UGDS_NRA)
data$UGDS_UNKN <- as.numeric(data$UGDS_UNKN)
data$AGE_ENTRY <- as.numeric(data$AGE_ENTRY)
data$FIRST_GEN <- as.numeric(data$FIRST_GEN)
data$FAMINC <- as.numeric(data$UGDS_FAMINC)
data$ADM_RATE <- as.numeric(data$ADM_RATE)
data$C100_4 <- as.numeric(data$C100_4)
data$C100_L4 <- as.numeric(data$C100_L4)

quant <- data.frame(data$UGDS_WHITE, data$UGDS_BLACK, data$UGDS_HISP, data$UGDS_ASIAN,
                    data$UGDS_AIAN, data$UGDS_2MOR, data$UGDS_NRA, data$UGDS_UNKN,
                    data$AGE_ENTRY, data$FIRST_GEN, data$ADM_RATE, 
                    data$C100_4, data$C100_L4)
correlation_matrix <- cor(quant)
correlation_matrix[lower.tri(correlation_matrix)] <- ''

#Producing Eda Correlation Matrix
sink('data/outputs/eda-correlation-matrix.txt')
print(correlation_matrix)
sink()
