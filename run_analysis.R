rm(list = ls())
library(dplyr)
setwd("/Users/artem/Documents/Coursera/Course 3/Week 4")
#Creating projecct directory
if (!file.exists("Project")) {
  dir.create("Project")
}
setwd("./Project")

#Downloading and unzipping file 
if (!file.exists("dataset.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./dataset.zip")
}
if (!file.exists("UCI HAR Dataset")) { 
  unzip("dataset.zip") 
}


# Preparing the variables names and labels to be subsetted
varNames <- read.table("./UCI HAR Dataset/features.txt")
activityLab <- read.table("./UCI HAR Dataset/activity_labels.txt")

## vectors to use to subset the variables
toExtract <- grep(".*mean.*|.*std.*", as.character(varNames$V2))


#loading and binding lables and subjects for train and test
trainLab <- read.table("./UCI HAR Dataset/train/y_train.txt")
trainSub <- read.table("./UCI HAR Dataset/train/subject_train.txt")
testLab <- read.table("./UCI HAR Dataset/test/y_test.txt")
testSub <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# bind by row to later attach to whol data
allLab <- bind_rows(trainLab,testLab); allSub <- bind_rows(trainSub,testSub)

# Reading and binding data to respecitive train or test
train <- read.table("./UCI HAR Dataset/train/X_train.txt") 
test <- read.table("./UCI HAR Dataset/test/X_test.txt")

# Binding train and test sets
dataMerged <- bind_rows(train, test)

# Assigning variable's proper names to merged data and extracting the needed columns
names(dataMerged) <- as.character(varNames$V2)
extractedData <- dataMerged[toExtract]
names(extractedData) <- gsub("-mean", "Mean", names(extractedData))
names(extractedData) <- gsub("-std", "Std", names(extractedData))
names(extractedData) <- gsub("[-()]", "", names(extractedData))
names(extractedData)
# Column binding activities and subjects
completeData <- bind_cols(extractedData,allSub,allLab)
names(completeData)[80] <- "Subject"
names(completeData)[81] <- "Activity"
names(completeData)

# Label Acitvity and Subject
completeData$Subject <- as.factor(completeData$Subject)
completeData$Activity <- factor(completeData$Activity, levels = activityLab$V1, labels = activityLab$V2)
head(completeData)

# Summarizing Data for each subject and activity by mean
summaryData <- completeData %>% group_by(Subject, Activity) %>%
                          summarise_all(funs(mean))
head(summaryData)
write.table(summaryData, "tidyData.txt", row.names = F, quote = F)
