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
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
s_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Classifying test data
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
s_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#Reading features
variable_names <- read.table("./data/UCI HAR Dataset/features.txt")

#Reading activity labels
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

##### 

#1.- Merges the training and the test sets to create one data set.

x_total <- rbind(x_train, x_test)
y_total <- rbind(y_train, y_test)
s_total <- rbind(s_train, s_test)

#####

#2.- Extracts only the measurements on the mean and standard deviation for each measurement.

selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
x_total <- x_total[,selected_var[,1]]

#####

#3.- Uses descriptive activity names to name the activities in the data set

colnames(y_total) <- "activity"
y_total$activitylabel <- factor(y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- y_total[,-1]

#####

#4.- Appropriately labels the data set with descriptive variable names.

colnames(x_total) <- variable_names[selected_var[,1],2]

#####

#5.- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

colnames(s_total) <- "subject"
total <- cbind(x_total, activitylabel, s_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./data/UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
