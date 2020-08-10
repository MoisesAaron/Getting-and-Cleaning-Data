#Installing dplyr if necessary and calling the library
if(!require(dplyr)) install.packages("dplyr")
library(dplyr)

#Downloading the dataset
if(!file.exists("./data")){dir.create("./data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,destfile="./data/Dataset.zip")

#Unzipping the dataset
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Classifyng trainning data
xtrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
subjecttrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Classifying test data
xtest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
subjecttest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#Reading features
variable_names <- read.table("./data/UCI HAR Dataset/features.txt")

#Reading activity labels
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

##### 

#1.- Merges the training and the test sets to create one data set.

x <- rbind(xtrain, xtest)
y <- rbind(ytrain, ytest)
subjectt <- rbind(subjecttrain, subjecttest)

#####

#2.- Extracts only the measurements on the mean and standard deviation for each measurement.

selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
x <- x[,selected_var[,1]]

#####

#3.- Uses descriptive activity names to name the activities in the data set

colnames(y) <- "activity"
y$activitylabel <- factor(y$activity, labels = as.character(activity_labels[,2]))
activitylabel <- y[,-1]

#####

#4.- Appropriately labels the data set with descriptive variable names.

colnames(x) <- variable_names[selected_var[,1],2]

#####

#5.- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

colnames(subjectt) <- "subject"
total <- cbind(x, activitylabel, subjectt)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./data/UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
