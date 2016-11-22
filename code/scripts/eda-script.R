# Loading Data and Necessary Packages
data <- read.csv('data/colleges.csv', header = TRUE)
data$X <- NULL
library(ggplot2)

# Correlation Matrix Quantitative Variables
quant <- data.frame(data$UGDS_WHITE, data$UGDS_BLACK, 
                    data$UGDS_HISP, data$UGDS_ASIAN,
                    data$UGDS_AIAN, data$UGDS_2MOR, data$UGDS_NRA, data$UGDS_UNKN,
                    data$AGE_ENTRY, data$FIRST_GEN, data$ADM_RATE, 
                    data$completion, data$transfer, data$FAMINC, data$MARRIED,
                    data$MN_EARN_WNE_P10, data$SATVR25, data$SATVR75, data$SATMT25, 
                    data$SATMT75, data$SATWR25, data$SATWR75)
correlation_matrix <- cor(quant, use = "complete.obs")
correlation_matrix[lower.tri(correlation_matrix)] <- ''


#Producing Eda Correlation Matrix
sink('data/outputs/eda-correlation-matrix.txt')
print(correlation_matrix)
sink()

# Scatterplot Matrix
pdf('images/scatterplot-matrix.pdf')
pairs(quant, pch = 16, cex.labels = .5)
dev.off()

# Histograms for Variables
# SAT Histograms
png('images/histogram-SATVR25.png')
ggplot(data = data) +
  geom_histogram(aes(SATVR25), binwidth = 50,
                 col = '#000000',fill = '#f55449') +
  xlab('SAT Verbal Score') +
  ylab('Count') +
  ggtitle('Histogram of SATVR25')
dev.off()

png('images/histogram-SATVR75.png')
ggplot(data = data) +
  geom_histogram(aes(SATVR75), binwidth = 50,
                 col = '#000000',fill = '#f55449') +
  xlab('SAT Verbal Score') +
  ylab('Count') +
  ggtitle('Histogram of SATVR75')
dev.off()

png('images/histogram-SATMT25.png')
ggplot(data = data) +
  geom_histogram(aes(SATMT25), binwidth = 50,
                 col = '#000000',fill = '#b698ff') +
  xlab('SAT Math Score') +
  ylab('Count') +
  ggtitle('Histogram of SATMT25')
dev.off()

png('images/histogram-SATMT75.png')
ggplot(data = data) +
  geom_histogram(aes(SATMT75), binwidth = 50,
                 col = '#000000',fill = '#b698ff') +
  xlab('SAT Math Score') +
  ylab('Count') +
  ggtitle('Histogram of SATMT75')
dev.off()

png('images/histogram-SATWR25.png')
ggplot(data = data) +
  geom_histogram(aes(SATWR25), binwidth = 50,
                 col = '#000000',fill = '#9bcdff') +
  xlab('SAT Writing Score') +
  ylab('Count') +
  ggtitle('Histogram of SATWR25')
dev.off()

png('images/histogram-SATWR75.png')
ggplot(data = data) +
  geom_histogram(aes(SATWR75), binwidth = 50,
                 col = '#000000',fill = '#9bcdff') +
  xlab('SAT Writing Score') +
  ylab('Count') +
  ggtitle('Histogram of SATWR75')
dev.off()

#Histogram for Completion 
png('images/histogram-completion.png')
ggplot(data = data) +
  geom_histogram(aes(completion), binwidth = .10,
                 col = '#000000',fill = '#008080') +
  xlab('Completion Rate') +
  ylab('Count') +
  ggtitle('Histogram of Completion Rates')
dev.off()

#Histogram for Transfer 
png('images/histogram-transfer.png')
ggplot(data = data) +
  geom_histogram(aes(transfer), binwidth = .10,
                 col = '#000000',fill = '#dc166a') +
  xlab('Transfer Rate') +
  ylab('Count') +
  ggtitle('Histogram of Transfer Rates')
dev.off()

#Histogram for Admission 
png('images/histogram-admission.png')
ggplot(data = data) +
  geom_histogram(aes(ADM_RATE), binwidth = .10,
                 col = '#000000',fill = '#e0f5ee') +
  xlab('Admission Rate') +
  ylab('Count') +
  ggtitle('Histogram of Admission Rates')
dev.off()

#Histogram for State Numbers
png('images/histogram-state.png')
ggplot(data = data) +
  geom_histogram(aes(ST_FIPS), binwidth = 1,
                 col = '#000000',fill = '#ff7373') +
  xlab('State Code') +
  ylab('Count') +
  ggtitle('Histogram of Distribution of States')
dev.off()

#Histogram for Average Wage After to Years
png('images/histogram-average-wage.png')
ggplot(data = data) +
  geom_histogram(aes(MN_EARN_WNE_P10), binwidth = 10000,
                 col = '#000000',fill = '#f3ff8d') +
  xlab('Wage') +
  ylab('Count') +
  ggtitle('Histogram of Distribution of Average Wage After 10 Years')
dev.off()

#Histogram for Family Income
png('images/histogram-family-income.png')
ggplot(data = data) +
  geom_histogram(aes(FAMINC), binwidth = 10000,
                 col = '#000000',fill = '#ffd28d') +
  xlab('Income') +
  ylab('Count') +
  ggtitle('Histogram of Distribution of Family Income')
dev.off()

#Histogram for First Generation Student
png('images/histogram-first-generation.png')
ggplot(data = data) +
  geom_histogram(aes(FIRST_GEN), binwidth = .1,
                 col = '#000000',fill = '#9cff8d') +
  xlab('Rate') +
  ylab('Count') +
  ggtitle('Histogram of Distribution of First Generation College Students')
dev.off()

#Histogram for Marriage Rates
png('images/histogram-married.png')
ggplot(data = data) +
  geom_histogram(aes(MARRIED), binwidth = .1,
                 col = '#000000',fill = '#4d6fbe') +
  xlab('Rate') +
  ylab('Count') +
  ggtitle('Histogram of Marriage Rates')
dev.off()

#Histogram for Women Rates
png('images/histogram-women.png')
ggplot(data = data) +
  geom_histogram(aes(UGDS_WOMEN), binwidth = .1,
                 col = '#000000',fill = '#f9b6ec') +
  xlab('Rate') +
  ylab('Count') +
  ggtitle('Histogram of Distribution of Percentage of Women')
dev.off()

#Histogram for Men Rates
png('images/histogram-men.png')
ggplot(data = data) +
  geom_histogram(aes(1-UGDS_WOMEN), binwidth = .1,
                 col = '#000000',fill = '#b6dcf9') +
  xlab('Rate') +
  ylab('Count') +
  ggtitle('Histogram of Distribution of Percentage of Men')
dev.off()

#Histogram for Average Age when Entering College
png('images/histogram-age-entering.png')
ggplot(data = data) +
  geom_histogram(aes(AGE_ENTRY), binwidth = 2,
                 col = '#000000',fill = '#ccb6f9') +
  xlab('Age') +
  ylab('Count') +
  ggtitle('Histogram of Average Age when Entering College')
dev.off()

#Histograms for Each Race
png('images/histogram-UGDS-white.png')
ggplot(data = data) +
  geom_histogram(aes(UGDS_WHITE), binwidth = .1,
                 col = '#000000',fill = '#fbf004') +
  xlab('Age') +
  ylab('Count') +
  ggtitle('Histogram of Percentage of UGDS White')
dev.off()

png('images/histogram-UGDS-black.png')
ggplot(data = data) +
  geom_histogram(aes(UGDS_BLACK), binwidth = .1,
                 col = '#000000',fill = '#8555fd') +
  xlab('Age') +
  ylab('Count') +
  ggtitle('Histogram of Percentage of UGDS black')
dev.off()

png('images/histogram-UGDS-hispanic.png')
ggplot(data = data) +
  geom_histogram(aes(UGDS_HISP), binwidth = .1,
                 col = '#000000',fill = '#c7eef6') +
  xlab('Age') +
  ylab('Count') +
  ggtitle('Histogram of Percentage of UGDS Hispanic')
dev.off()

png('images/histogram-UGDS-asian.png')
ggplot(data = data) +
  geom_histogram(aes(UGDS_ASIAN), binwidth = .1,
                 col = '#000000',fill = '#ffc5c5') +
  xlab('Age') +
  ylab('Count') +
  ggtitle('Histogram of Percentage of UGDS ASIAN')
dev.off()

png('images/histogram-UGDS-aian.png')
ggplot(data = data) +
  geom_histogram(aes(UGDS_AIAN), binwidth = .1,
                 col = '#000000',fill = '#f9f6b9') +
  xlab('Age') +
  ylab('Count') +
  ggtitle('Histogram of Percentage of UGDS AIAN')
dev.off()

png('images/histogram-UGDS-nhpi.png')
ggplot(data = data) +
  geom_histogram(aes(UGDS_NHPI), binwidth = .1,
                 col = '#000000',fill = '#b8f2c2') +
  xlab('Age') +
  ylab('Count') +
  ggtitle('Histogram of Percentage of UGDS NHPI')
dev.off()

png('images/histogram-UGDS-2mor.png')
ggplot(data = data) +
  geom_histogram(aes(UGDS_2MOR), binwidth = .1,
                 col = '#000000',fill = '#b2cdfb') +
  xlab('Age') +
  ylab('Count') +
  ggtitle('Histogram of Percentage of UGDS 2 or More Races')
dev.off()

png('images/histogram-UGDS-unknown.png')
ggplot(data = data) +
  geom_histogram(aes(UGDS_UNKN), binwidth = .1,
                 col = '#000000',fill = '#cfffc0') +
  xlab('Age') +
  ylab('Count') +
  ggtitle('Histogram of Percentage of UGDS Unknown')
dev.off()

png('images/histogram-UGDS-nra.png')
ggplot(data = data) +
  geom_histogram(aes(UGDS_NRA), binwidth = .1,
                 col = '#000000',fill = '#ffc0ee') +
  xlab('Age') +
  ylab('Count') +
  ggtitle('Histogram of Percentage of UGDS NRA')
dev.off()



