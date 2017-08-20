# Getting and Cleaning Data Course Project Code Book

## Data Source with full description:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Download Link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
It comes in zip file, which is donwloaded by script below


## Structure of data:
Unzipped file containes descriptive txt files, train and test folder which have 561 feature file, subject and activity labels.
It is important to know about features
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

## The script file: run_analysis.R
The R script in general manipultes the data, so that later analysis can be performed as folows.

## Downloading the file
```R
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
```

## Getting labels and creating logical vector to be used for subsetting:
```R
# Preparing the variables names and labels to be subsetted
varNames <- read.table("./UCI HAR Dataset/features.txt")
activityLab <- read.table("./UCI HAR Dataset/activity_labels.txt")

## vectors to use to subset the variables
toExtract <- grep(".*mean.*|.*std.*", as.character(varNames$V2))
```

```
> toExtract
 [1]   1   2   3   4   5   6  41  42  43  44  45  46  81  82  83  84  85  86 121 122 123 124 125 126 161 162 163 164 165
[30] 166 201 202 214 215 227 228 240 241 253 254 266 267 268 269 270 271 294 295 296 345 346 347 348 349 350 373 374 375
[59] 424 425 426 427 428 429 452 453 454 503 504 513 516 517 526 529 530 539 542 543 552
```

## Loading and binding the subject and activity labels:
```R
#loading and binding lables and subjects for train and test
trainLab <- read.table("./UCI HAR Dataset/train/y_train.txt")
trainSub <- read.table("./UCI HAR Dataset/train/subject_train.txt")
testLab <- read.table("./UCI HAR Dataset/test/y_test.txt")
testSub <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# bind by row to later attach to whol data
allLab <- bind_rows(trainLab,testLab); allSub <- bind_rows(trainSub,testSub)
```
## Loading and bindin 561 feature train and test sets:
```R
# Reading and binding data to respecitive train or test
train <- read.table("./UCI HAR Dataset/train/X_train.txt") 
test <- read.table("./UCI HAR Dataset/test/X_test.txt")

# Binding train and test sets
dataMerged <- bind_rows(train, test)
```
## Naming the variables, and some doing some string manipulations to have proper names:
```R
# Assigning variable's proper names to merged data and extracting the needed columns
names(dataMerged) <- as.character(varNames$V2)
extractedData <- dataMerged[toExtract]
names(extractedData) <- gsub("-mean", "Mean", names(extractedData))
names(extractedData) <- gsub("-std", "Std", names(extractedData))
names(extractedData) <- gsub("[-()]", "", names(extractedData))
names(extractedData)
```
```R
> head(names(completeData))
[1] "tBodyAccMeanX" "tBodyAccMeanY" "tBodyAccMeanZ" "tBodyAccStdX"  "tBodyAccStdY"  "tBodyAccStdZ" 
```
## Column binding label vectors to features datasets, then converting the mentioned into factor variables:

```R
# Column binding activities and subjects
completeData <- bind_cols(extractedData,allSub,allLab)
names(completeData)[80] <- "Subject"
names(completeData)[81] <- "Activity"
head(names(completeData))

# Label Acitvity and Subject
completeData$Subject <- as.factor(completeData$Subject)
completeData$Activity <- factor(completeData$Activity, levels = activityLab$V1, labels = activityLab$V2)
head(completeData)
```
```R
> head(completeData)
  tBodyAccMeanX tBodyAccMeanY tBodyAccMeanZ tBodyAccStdX tBodyAccStdY tBodyAccStdZ tGravityAccMeanX tGravityAccMeanY
1     0.2885845   -0.02029417    -0.1329051   -0.9952786   -0.9831106   -0.9135264        0.9633961       -0.1408397
2     0.2784188   -0.01641057    -0.1235202   -0.9982453   -0.9753002   -0.9603220        0.9665611       -0.1415513
3     0.2796531   -0.01946716    -0.1134617   -0.9953796   -0.9671870   -0.9789440        0.9668781       -0.1420098
4     0.2791739   -0.02620065    -0.1232826   -0.9960915   -0.9834027   -0.9906751        0.9676152       -0.1439765
5     0.2766288   -0.01656965    -0.1153619   -0.9981386   -0.9808173   -0.9904816        0.9682244       -0.1487502
6     0.2771988   -0.01009785    -0.1051373   -0.9973350   -0.9904868   -0.9954200        0.9679482       -0.1482100
```

### Using Dplyr package, grouping data by subject and activity and then summurising it by those groups:
```R
# Summarizing Data for each subject and activity by mean
summaryData <- completeData %>% group_by(Subject, Activity) %>%
                          summarise_all(funs(mean))
head(summaryData)
write.table(summaryData, "tidyData.txt", row.names = F, quote = F)
```
## The ouput structure

```R
> str(head(summaryData))
Classes ‘grouped_df’, ‘tbl_df’, ‘tbl’ and 'data.frame':	6 obs. of  81 variables:
 $ Subject                     : Factor w/ 30 levels "1","2","3","4",..: 1 1 1 1 1 1
 $ Activity                    : Factor w/ 6 levels "WALKING","WALKING_UPSTAIRS",..: 1 2 3 4 5 6
 $ tBodyAccMeanX               : num  0.277 0.255 0.289 0.261 0.279 ...
 $ tBodyAccMeanY               : num  -0.01738 -0.02395 -0.00992 -0.00131 -0.01614 ...
 $ tBodyAccMeanZ               : num  -0.1111 -0.0973 -0.1076 -0.1045 -0.1106 ...
 $ tBodyAccStdX                : num  -0.284 -0.355 0.03 -0.977 -0.996 ...
 $ tBodyAccStdY                : num  0.11446 -0.00232 -0.03194 -0.92262 -0.97319 ...
 $ tBodyAccStdZ                : num  -0.26 -0.0195 -0.2304 -0.9396 -0.9798 ...
 $ tGravityAccMeanX            : num  0.935 0.893 0.932 0.832 0.943 ...
 $ tGravityAccMeanY            : num  -0.282 -0.362 -0.267 0.204 -0.273 ...
 $ tGravityAccMeanZ            : num  -0.0681 -0.0754 -0.0621 0.332 0.0135 ...
 $ tGravityAccStdX             : num  -0.977 -0.956 -0.951 -0.968 -0.994 ...
 $ tGravityAccStdY             : num  -0.971 -0.953 -0.937 -0.936 -0.981 ...
 $ tGravityAccStdZ             : num  -0.948 -0.912 -0.896 -0.949 -0.976 ...
 $ tBodyAccJerkMeanX           : num  0.074 0.1014 0.0542 0.0775 0.0754 ...
 $ tBodyAccJerkMeanY           : num  0.028272 0.019486 0.02965 -0.000619 0.007976 ...
 $ tBodyAccJerkMeanZ           : num  -0.00417 -0.04556 -0.01097 -0.00337 -0.00369 ...
 $ tBodyAccJerkStdX            : num  -0.1136 -0.4468 -0.0123 -0.9864 -0.9946 ...
 $ tBodyAccJerkStdY            : num  0.067 -0.378 -0.102 -0.981 -0.986 ...
 $ tBodyAccJerkStdZ            : num  -0.503 -0.707 -0.346 -0.988 -0.992 ...
 $ tBodyGyroMeanX              : num  -0.0418 0.0505 -0.0351 -0.0454 -0.024 ...
 $ tBodyGyroMeanY              : num  -0.0695 -0.1662 -0.0909 -0.0919 -0.0594 ...
 $ tBodyGyroMeanZ              : num  0.0849 0.0584 0.0901 0.0629 0.0748 ...
 $ tBodyGyroStdX               : num  -0.474 -0.545 -0.458 -0.977 -0.987 ...
 $ tBodyGyroStdY               : num  -0.05461 0.00411 -0.12635 -0.96647 -0.98773 ...
 $ tBodyGyroStdZ               : num  -0.344 -0.507 -0.125 -0.941 -0.981 ...
 $ tBodyGyroJerkMeanX          : num  -0.09 -0.1222 -0.074 -0.0937 -0.0996 ...
 $ tBodyGyroJerkMeanY          : num  -0.0398 -0.0421 -0.044 -0.0402 -0.0441 ...
 $ tBodyGyroJerkMeanZ          : num  -0.0461 -0.0407 -0.027 -0.0467 -0.049 ...
 $ tBodyGyroJerkStdX           : num  -0.207 -0.615 -0.487 -0.992 -0.993 ...
 $ tBodyGyroJerkStdY           : num  -0.304 -0.602 -0.239 -0.99 -0.995 ...
 $ tBodyGyroJerkStdZ           : num  -0.404 -0.606 -0.269 -0.988 -0.992 ...
 $ tBodyAccMagMean             : num  -0.137 -0.1299 0.0272 -0.9485 -0.9843 ...
 $ tBodyAccMagStd              : num  -0.2197 -0.325 0.0199 -0.9271 -0.9819 ...
 $ tGravityAccMagMean          : num  -0.137 -0.1299 0.0272 -0.9485 -0.9843 ...
 $ tGravityAccMagStd           : num  -0.2197 -0.325 0.0199 -0.9271 -0.9819 ...
 $ tBodyAccJerkMagMean         : num  -0.1414 -0.4665 -0.0894 -0.9874 -0.9924 ...
 $ tBodyAccJerkMagStd          : num  -0.0745 -0.479 -0.0258 -0.9841 -0.9931 ...
 $ tBodyGyroMagMean            : num  -0.161 -0.1267 -0.0757 -0.9309 -0.9765 ...
 $ tBodyGyroMagStd             : num  -0.187 -0.149 -0.226 -0.935 -0.979 ...
 $ tBodyGyroJerkMagMean        : num  -0.299 -0.595 -0.295 -0.992 -0.995 ...
 $ tBodyGyroJerkMagStd         : num  -0.325 -0.649 -0.307 -0.988 -0.995 ...
 $ fBodyAccMeanX               : num  -0.2028 -0.4043 0.0382 -0.9796 -0.9952 ...
 $ fBodyAccMeanY               : num  0.08971 -0.19098 0.00155 -0.94408 -0.97707 ...
 $ fBodyAccMeanZ               : num  -0.332 -0.433 -0.226 -0.959 -0.985 ...
 $ fBodyAccStdX                : num  -0.3191 -0.3374 0.0243 -0.9764 -0.996 ...
 $ fBodyAccStdY                : num  0.056 0.0218 -0.113 -0.9173 -0.9723 ...
 $ fBodyAccStdZ                : num  -0.28 0.086 -0.298 -0.934 -0.978 ...
 $ fBodyAccMeanFreqX           : num  -0.2075 -0.4187 -0.3074 -0.0495 0.0865 ...
 $ fBodyAccMeanFreqY           : num  0.1131 -0.1607 0.0632 0.0759 0.1175 ...
 $ fBodyAccMeanFreqZ           : num  0.0497 -0.5201 0.2943 0.2388 0.2449 ...
 $ fBodyAccJerkMeanX           : num  -0.1705 -0.4799 -0.0277 -0.9866 -0.9946 ...
 $ fBodyAccJerkMeanY           : num  -0.0352 -0.4134 -0.1287 -0.9816 -0.9854 ...
 $ fBodyAccJerkMeanZ           : num  -0.469 -0.685 -0.288 -0.986 -0.991 ...
 $ fBodyAccJerkStdX            : num  -0.1336 -0.4619 -0.0863 -0.9875 -0.9951 ...
 $ fBodyAccJerkStdY            : num  0.107 -0.382 -0.135 -0.983 -0.987 ...
 $ fBodyAccJerkStdZ            : num  -0.535 -0.726 -0.402 -0.988 -0.992 ...
 $ fBodyAccJerkMeanFreqX       : num  -0.209 -0.377 -0.253 0.257 0.314 ...
 $ fBodyAccJerkMeanFreqY       : num  -0.3862 -0.5095 -0.3376 0.0475 0.0392 ...
 $ fBodyAccJerkMeanFreqZ       : num  -0.18553 -0.5511 0.00937 0.09239 0.13858 ...
 $ fBodyGyroMeanX              : num  -0.339 -0.493 -0.352 -0.976 -0.986 ...
 $ fBodyGyroMeanY              : num  -0.1031 -0.3195 -0.0557 -0.9758 -0.989 ...
 $ fBodyGyroMeanZ              : num  -0.2559 -0.4536 -0.0319 -0.9513 -0.9808 ...
 $ fBodyGyroStdX               : num  -0.517 -0.566 -0.495 -0.978 -0.987 ...
 $ fBodyGyroStdY               : num  -0.0335 0.1515 -0.1814 -0.9623 -0.9871 ...
 $ fBodyGyroStdZ               : num  -0.437 -0.572 -0.238 -0.944 -0.982 ...
 $ fBodyGyroMeanFreqX          : num  0.0148 -0.1875 -0.1005 0.1892 -0.1203 ...
 $ fBodyGyroMeanFreqY          : num  -0.0658 -0.4736 0.0826 0.0631 -0.0447 ...
 $ fBodyGyroMeanFreqZ          : num  0.000773 -0.133374 -0.075676 -0.029784 0.100608 ...
 $ fBodyAccMagMean             : num  -0.1286 -0.3524 0.0966 -0.9478 -0.9854 ...
 $ fBodyAccMagStd              : num  -0.398 -0.416 -0.187 -0.928 -0.982 ...
 $ fBodyAccMagMeanFreq         : num  0.1906 -0.0977 0.1192 0.2367 0.2846 ...
 $ fBodyBodyAccJerkMagMean     : num  -0.0571 -0.4427 0.0262 -0.9853 -0.9925 ...
 $ fBodyBodyAccJerkMagStd      : num  -0.103 -0.533 -0.104 -0.982 -0.993 ...
 $ fBodyBodyAccJerkMagMeanFreq : num  0.0938 0.0854 0.0765 0.3519 0.4222 ...
 $ fBodyBodyGyroMagMean        : num  -0.199 -0.326 -0.186 -0.958 -0.985 ...
 $ fBodyBodyGyroMagStd         : num  -0.321 -0.183 -0.398 -0.932 -0.978 ...
 $ fBodyBodyGyroMagMeanFreq    : num  0.268844 -0.219303 0.349614 -0.000262 -0.028606 ...
 $ fBodyBodyGyroJerkMagMean    : num  -0.319 -0.635 -0.282 -0.99 -0.995 ...
 $ fBodyBodyGyroJerkMagStd     : num  -0.382 -0.694 -0.392 -0.987 -0.995 ...
 $ fBodyBodyGyroJerkMagMeanFreq: num  0.191 0.114 0.19 0.185 0.334 ...
 - attr(*, "vars")= chr "Subject"
 - attr(*, "drop")= logi TRUE
 - attr(*, "indices")=List of 1
  ..$ : int  0 1 2 3 4 5
 - attr(*, "group_sizes")= int 6
 - attr(*, "biggest_group_size")= int 6
 - attr(*, "labels")='data.frame':	1 obs. of  1 variable:
  ..$ Subject: Factor w/ 30 levels "1","2","3","4",..: 1
  ..- attr(*, "vars")= chr "Subject"
  ..- attr(*, "drop")= logi TRUE
  ```


```R
> head(summaryData)
# A tibble: 6 x 81
# Groups:   Subject [1]
  Subject           Activity tBodyAccMeanX tBodyAccMeanY tBodyAccMeanZ tBodyAccStdX tBodyAccStdY tBodyAccStdZ
   <fctr>             <fctr>         <dbl>         <dbl>         <dbl>        <dbl>        <dbl>        <dbl>
1       1            WALKING     0.2773308  -0.017383819    -0.1111481  -0.28374026  0.114461337  -0.26002790
2       1   WALKING_UPSTAIRS     0.2554617  -0.023953149    -0.0973020  -0.35470803 -0.002320265  -0.01947924
3       1 WALKING_DOWNSTAIRS     0.2891883  -0.009918505    -0.1075662   0.03003534 -0.031935943  -0.23043421
4       1            SITTING     0.2612376  -0.001308288    -0.1045442  -0.97722901 -0.922618642  -0.93958629
5       1           STANDING     0.2789176  -0.016137590    -0.1106018  -0.99575990 -0.973190056  -0.97977588
6       1             LAYING     0.2215982  -0.040513953    -0.1132036  -0.92805647 -0.836827406  -0.82606140
```




