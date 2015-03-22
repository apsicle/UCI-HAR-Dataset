# Getting and Cleaning Data Course Project
# run_analysis.R
# 
# Coded by: Ryan Yan
# Revision Date: 03.22.15
#
# This script will analyze the UCI HAR dataset downloaded from
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# The script must be run using the main folder '../UCI HAR Dataset' as the working directory.
#
# This script will read and merge the test and training data sets, apply proper labels as
# column names for each variable, and attach the subject number and activity labels as the 
# first two columns. It will then extract the mean and std columns of the data and retain these
# as well as the first two identification columns as a new data.frame called 'tidy_table'.
#
# Lastly, it will create an independent data table called 'means' which will store the average
# value of each of the columns of data of tidy_table subsectioned for each subject and activity.
# As in, the table will contain averages for the mean and standard deviation of each feature variable
# for each subject, and for each activity. This 'means' data table will be written to a file located
# at './tidydataset.txt'.
library(dplyr)
library(reshape2)

#Reads the observations, the subject data, and the activity labels into tables. 
#First checks if they exist since the process takes a fair bit of time.
if(!exists("x_test")) {
    x_test <- read.table("./test/X_test.txt")
    x_train <- read.table("./train/X_train.txt")
    y_test <- read.table("./test/y_test.txt")
    y_train <- read.table("./train/y_train.txt")
    subject_training <- read.table("./train/subject_train.txt")
    subject_test <- read.table("./test/subject_test.txt")
    activity_labels <- read.table("./activity_labels.txt")
    features <- read.table("./features.txt")
}

#Merges the labels and data tables in the order subject number > activity > features
test_table <- cbind(subject_test, y_test, x_test)
train_table <- cbind(subject_training, y_train, x_train)

#Combines the test and training sets together so that training sets are above test
merged_table <- rbind(train_table, test_table)

#Finds the columns that have mean values and std values and stores the indices
mean_cols <- grep("mean", features[,2])
std_cols <- grep("std", features[,2])

#Sets the variable names for each column
variable_names = as.character(features[,2])
variable_names <- c("Subject_Number", "Activity_Label", variable_names)
names(merged_table) <- variable_names

#Changes the activity code numbers to readable labels
merged_table$"Activity_Label" <- as.factor(merged_table$"Activity_Label")
levels(merged_table$"Activity_Label") <- activity_labels[,2]

#Creates a table with only the extracted mean and std columns, retaining
#subject number, decoded activity level, and variable labels.
#NOTE: THIS 'tidy_table' DATA.FRAME IS NOT THE INDEPENDENT TABLE
#SPECIFIED IN PART 5. 
tidy_table <- merged_table[,c(1,2, mean_cols+2, std_cols+2)]

#Preallocates space for the independent data table for step 5: 'means'
means <- data.frame(matrix(0, nrow = 79, ncol = 36))

#Goes through tidy_table and calculates the average of each variable for each subject using colMeans
for(i in 1:30) {
    test <- tidy_table[tidy_table$Subject_Number ==i, ]
    means[, i] <- colMeans(test[,c(-1,-2)])
}

#Goes through tidy_table and calculates the average of each variable for each activity using colMeans
for(i in 31:36) {
    test <- tidy_table[as.numeric(tidy_table$Activity_Label) ==i-30, ]
    means[, i] <- colMeans(test[,c(-1,-2)])
}

#Adds descriptive names for the independent data table 'means'
rownames(means) <- paste("Average of", variable_names[c(mean_cols+2, std_cols+2)])
cnames <- rep("Subject Number", 30)
cnames <- paste(cnames, as.character(1:30))
cnames <- c(cnames, as.character(activity_labels[,2]))
colnames(means) <- cnames

#Writes 'means' data table to a new file called 
write.table(means, file = "./tidydataset.txt", row.names = FALSE)

