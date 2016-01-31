# Author: Ezio Crestaz
# Date:   2016-01-28
# Project due for 'getting and cleaning data' course by John Hopkins Un.
# at Coursera.org
library(dplyr)

setwd("C:/Data1/Coursera/JohnHopkins/DataScienceSpecialization/GettingAndCleaningData/Assignments/project")

# Download zipped file and decompress
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/dataset.zip", mode="wb")
unzip ("./data/dataset.zip", exdir="./data")  

# Set reference data path and recursively access files
path <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)

# Coded activity files (6 different activities)
activityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
activityTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)

# Subject files (total of 30 people)
subjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
subjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)

# Features files (variables)
featuresTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
featuresTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

# Concatenate training and test data sets (subject,activity and features)
subject <- rbind(subjectTrain, subjectTest)
activity<- rbind(activityTrain, activityTest)
features<- rbind(featuresTrain, featuresTest)

# Assign call names to each one of the data frames, variable names being first read from file
colnames(subject)<-c("subject")
colnames(activity)<- c("activity")
names <- read.table(file.path(path, "features.txt"),head=FALSE)
colnames(features)<- names$V2

# Combine former data frames binding them by columns
data <- cbind(subject, activity, features)

# Select only columns containing mean and std information, plus those containing
# "activity" and "subject"
data <- data[,grep("mean\\(\\)|std\\(\\)", names$V2) & 
              grep("subject",colnames(data)) &
              grep("activity",colnames(data))]

# Read in activity labels, join them in data table, remove original activity and rename
# new added factor column reporting a description of the activity
activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)
colnames(activityLabels) <- c("activity","activitydescr")

data <- left_join(activityLabels,data,by="activity")
data <- data[,-1]
colnames(data)[1] <- "activity"

# Provide extended more informative column names
# Details on variables are provided in features.txt and features_info.txt
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))  # Erroneous repetition

# Group by activity and subject, computing mean values
dataSummary <- data  %>%  
  group_by(activity,subject) %>%
  # Summarise except for subject and activity
  summarise_each(funs(mean))   
