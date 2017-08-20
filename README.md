# Course 3:  Getting and cleaning data
## This repo contains the run_analysis.R file which performs the following tasks:
* Creates folder, downloads and unzips the file if it does not exist.
* Loads activity labels and feature names, prepase vector to subset reuired variables.
* Loads activity and subject labels for train and test sets, binds them separately by rows
* Loads train and test files with 561 features, and then merges them together by rows.
* Assigns the names to all 561 features in combined dataset, then changes variables name to be more readable.
* Binds by columns Subject and Activity sets, provides the proper names for them.
* Transforms the latter variables into factors with proper labelling.
* Using "Dplyr", groups and summarizes the data for each subject and activity.
* Writes the final version of tidy data.


