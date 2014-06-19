# README.md

The following files were submitted in accordance with the coursera course: Getting and Cleaning Data by the Johns Hopkins University.



## README.md
This is the readme-file to explain all other files within the "Project"-folder


## README.txt
This is the readme-file to explain the "untidy dataset" obtained by downloading the following zip-file:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The README.txt file gives explanation on the following data as well:
* features.txt
* features_info.txt
* activity_labels.txt
* test-folder
* train-folder


## CodeBook.md
This file gives a more detailed explanation of the code used to run the analysis in run_analysis.R


## run_analysis.R
This file contains a computer readable R-code. It is code which anyone can run on his or her R-version checking for all relevant packages, creating all relevant directories, loading the relevant data from the web! Fully independent!!! And it performs the following analyses:

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## CleanAccelerometerData.txt
This file is the output of the run_analysis.R file which can itself be read into R again to perform further analyses.