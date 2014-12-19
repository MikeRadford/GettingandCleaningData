## Course Project Cleaning Data
## Library for later use on data manipulation
library(plyr)


if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = "./data/health.zip")
## unzip file
unzip("./data/health.zip")

## load train and test datasets
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt")
testData <- read.table("./UCI HAR Dataset/test/X_test.txt")

## load column names
columnTitles <- read.table("./UCI HAR Dataset/features.txt",sep = "")[,2]

## bind together into one data set
fullData <- rbind(trainData,testData)
## name the variables
names(fullData) <- columnTitles

# load the activity data
yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
yTest  <- read.table("./UCI HAR Dataset/test/y_test.txt")
# bind into one dataset
yMerged <- rbind(yTrain, yTest)
# rename with meaningful activity names
activityNames <- read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors=FALSE)[,2]
Activity <- activityNames[yMerged[,1]]

## vector of mean variable positions
meanVariablePos <- c(1,2,3,41,42,43,81,82,83,121,122,123,161,162,163,201,214,227,240,253,266,267,268,345,346,347,424,425,426,503,516,529,542)
## vector of standard deviation variable positions
stdVariablePos <- c(4,5,6,44,45,46,84,85,86,124,125,126,164,165,166,202,215,228,241,254,268,270,271,348,349,350,425,426,427,504,517,530,543)
## combined vector
extractVariablePos <- c(meanVariablePos,stdVariablePos)
## create subset of Data using only desired extracted variables
subData <- fullData[c(extractVariablePos)]

## Appropriately label the data set with descriptive variable names.
## t <- Time, f <- Frequency, mean() <- Mean and std() <- StdDev

names(subData) <- gsub("^t", "Time", names(subData))
names(subData) <- gsub("^f", "Frequency", names(subData))
names(subData) <- gsub("-mean\\(\\)", "Mean", names(subData))
names(subData) <- gsub("-std\\(\\)", "StdDev", names(subData))

## load the subject data
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subjectTest  <- read.table("./UCI HAR Dataset/test/subject_test.txt")
## bind into one dataset
subjectMerged <- rbind(subjectTrain, subjectTest)
names(subjectMerged) <- "Subject"

## combine all into one for further processing
cleanData <- cbind(subjectMerged, Activity, subData)

## function to create column means for all numbers
cleanDataColMeans <- function(data) { colMeans(data[,-c(1,2)]) }
## list of means by subject and activity
cleanMean <- ddply(cleanData, .(Subject, Activity), cleanDataColMeans)

# Write dataset
write.table(cleanMean, "tidydataset.txt", row.names = FALSE)
