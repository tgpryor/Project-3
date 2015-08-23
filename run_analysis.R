##########################################################################################################

# Coursera Getting and Cleaning Data Course Project
# Travis Pryor
# 08-23-2015

# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
# The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers 
# on a series of yes/no questions related to the project. You will be required to submit: 
# 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing the analysis, and 
# 3) a code book that describes the variables, the data, and any transformations or work that you 
#    performed to clean up the data called CodeBook.md. You should also include a README.md in the repo 
#    with your scripts. This repo explains how all of the scripts work and how they are connected.  
#
# One of the most exciting areas in all of data science right now is wearable computing. Companies like 
# Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
# The data linked to from the course website represent data collected from the accelerometers from the 
# Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
# - http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# Here are the data for the project: 
# - https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles/UCI HAR Dataset.zip 
#
# You should create one R script called run_analysis.R that does the following. 
# - Merges the training and the test sets to create one data set.
# - Extracts only the measurements on the mean and standard deviation for each measurement. 
# - Uses descriptive activity names to name the activities in the data set
# - Appropriately labels the data set with descriptive variable names. 
# - From the data set in step 4, creates a second, independent tidy data set with the average of each 
#   variable for each activity and each subject.
##########################################################################################################

# Clean up workspace
rm(list=ls())

#set working directory to the location where the UCI HAR Dataset was unzipped
setwd('/Users/travis/Coursera/2 Getting and Cleaning Data/Course-Project/UCI HAR Dataset/');

# LOAD DATA FROM UNZIPPED FLAT FILES

# activity
dataActivityTest  <- read.table(file.path("./test/Y_test.txt" ), header = FALSE)
dataActivityTrain <- read.table(file.path("./train/Y_train.txt"), header = FALSE)

# subjects
dataSubjectTest  <- read.table(file.path("./test/subject_test.txt"), header = FALSE)
dataSubjectTrain <- read.table(file.path("./train/subject_train.txt"), header = FALSE)

# features
dataFeaturesTest  <- read.table(file.path("./test/X_test.txt"), header = FALSE)
dataFeaturesTrain <- read.table(file.path("./train/X_train.txt"), header = FALSE)

# MERGE TRAINING AND TEST DATA INTO ONE DATASET

# concatenate rows
dataSubject    <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity   <- rbind(dataActivityTrain, dataActivityTest)
dataFeatures   <- rbind(dataFeaturesTrain, dataFeaturesTest)

# name variables
names(dataSubject)  <- c("subject")
names(dataActivity) <- c("activity")
dataFeaturesNames   <- read.table(file.path("features.txt"), head=FALSE)
names(dataFeatures) <- dataFeaturesNames$V2

# create master dataset with necessary columns
dataCombine    <- cbind(dataSubject, dataActivity)
Data           <- cbind(dataFeatures, dataCombine)

# ONLY KEEP THE MEAN AND STDEV FOR EACH MEASUREMENT

# subset features, looking for "mean()" or "std()"
subdataFeaturesNames <- dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

# subset master dataset with selected features
selectedNames  <- c(as.character(subdataFeaturesNames), "subject", "activity" )
Data           <- subset(Data,select=selectedNames)

# APPLY DESCRIPTIVE ACTIVITY NAMES

# load activity names
activityLabels <- read.table(file.path("activity_labels.txt"), header=FALSE)

# apply labels to data values
Data$activity = activityLabels[,2][match(Data$activity, activityLabels[,1])]

# RENAME VARIABLES

# add descriptive variable names
names(Data) <- gsub("^t", "time", names(Data))
names(Data) <- gsub("^f", "frequency", names(Data))
names(Data) <- gsub("Acc", "Accelerometer", names(Data))
names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("Mag", "Magnitude", names(Data))
names(Data) <- gsub("BodyBody", "Body", names(Data))

# CREATE TIDY DATASET

# convert master dataset to flat file
#library(plyr);
Data2 <- aggregate(. ~subject + activity, Data, mean)
Data2 <- Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file="tidydata.txt", row.name=FALSE)