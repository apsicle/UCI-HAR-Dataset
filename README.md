# UCI-HAR-Dataset
This repo contains the run_analysis.R script along with a README and codebook. The script can be placed in the UCI HAR Dataset folder and run to analyze the dataset.

# How to use:
1) Download and unzip data set from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
2) Load run_analysis.R into RStudio, and set the working directory in the 'UCI HAR Dataset' directory.
3) Run run_analysis, which will produce a tidy data set object in R and output a data table of average values of mean and std of
each feature variable in the data set to 'tidydataset.txt' in the working directory.

# Description of the dataset:
Dataset is from the result of signal data gathered from an experiment involving 30 subjects equipped with motion tracking equipment while doing 6 different acitvities. Contains numeric data from 561 different features, for 30 subjects divided into test and training sets.
Contains .txt files which contain labels and subject numbers separately. 

# What does run_analysis do: 
This script will analyze the UCI HAR dataset downloaded from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The script must be run using the main folder '../UCI HAR Dataset' as the working directory.

This script will read and merge the test and training data sets, apply proper labels as
column names for each variable, and attach the subject number and activity labels as the 
first two columns. It will then extract the mean and std columns of the data and retain these
as well as the first two identification columns as a new data.frame called 'tidy_table'.

Lastly, it will create an independent data table called 'means' which will store the average
value of each of the columns of data of tidy_table subsectioned for each subject and activity.
As in, the table will contain averages for the mean and standard deviation of each feature variable
for each subject, and for each activity. This 'means' data table will be written to a file located
at './tidydataset.txt'.
