setwd("c:/courseraData")
if(!file.exists("c:/courseraData")){dir.create("c:/courseraData")}
zip <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(zip,destfile="c:/courseraData/Dataset.zip")
unzip(zipfile="c:/courseraData/Dataset.zip",exdir="c:/courseraData")
route <- file.path("c:/courseraData" , "UCI HAR Dataset")
listfiles<-list.files(route, recursive=TRUE)
listfiles


# Merge the training and the test sets to create one data set.

xtrain <- read.table("c:/courseraData/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("c:/courseraData/UCI HAR Dataset/train/y_train.txt")
subtrain <- read.table("c:/courseraData/UCI HAR Dataset/train/subject_train.txt")
subtest <- read.table("c:/courseraData/UCI HAR Dataset/test/subject_test.txt")
xtest <- read.table("c:/courseraData/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("c:/courseraData/UCI HAR Dataset/test/y_test.txt")


dtrain <- cbind(subtrain, ytrain, xtrain)
dtest <- cbind(subtest, ytest, xtest)
datatest_datatrain <- rbind(dtrain, dtest)
dtrain
dtest
datatest_datatrain


# Extract only the measurements on the mean and standard deviation for each measurement. 

featureName <- read.table("c:/courseraData/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
featureName
featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName)
featureIndex
dataFinal <- datatest_datatrain[, c(1, 2, featureIndex+2)]
dataFinal
colnames(dataFinal) <- c("subject", "activity", featureName[featureIndex])
colnames(dataFinal)

# Uses descriptive activity names to name the activities in the data set


activityName <- read.table("c:/courseraData/UCI HAR Dataset/activity_labels.txt")
dataFinal$activity <- factor(dataFinal$activity, levels = activityName[,1], labels = activityName[,2])

# Appropriately labels the data set with descriptive variable names.

names(dataFinal) <- gsub("\\()", "", names(dataFinal))
names(dataFinal) <- gsub("^t", "time", names(dataFinal))
names(dataFinal) <- gsub("^f", "frequence", names(dataFinal))
names(dataFinal) <- gsub("-mean", "Mean", names(dataFinal))
names(dataFinal) <- gsub("-std", "Std", names(dataFinal))


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
install.packages("dplyr")
library(dplyr)
dataNew <- dataFinal %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(dataNew, "c:/courseraData/UCI HAR Dataset/variablesAverage.txt", row.names = FALSE)

