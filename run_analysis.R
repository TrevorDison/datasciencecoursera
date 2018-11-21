
###############################################################################

# Johns Hopskins Data Science Course on Coursera
# Gathering and Cleaning Data, Week 4 Project
# November 20, 2018

###############################################################################

# Load needed tidyverse packages 
#  (my network will not allow the complete tidyverse package)
library(dplyr)
library(tidyr)
library(stringr)
library(tibble)
library(readr)
library(purrr)

# Clear the envionment
rm(list = ls())

###############################################################################

# 1. Merges the training and the test sets to create one data set.

# Create vector of column names
features <- read_lines(".\\UCI HAR Dataset\\features.txt")

# Create data frame for test data
df.test <- read_table(".\\UCI HAR Dataset\\test\\X_test.txt", col_names = F)
colnames(df.test) <- features
subject <- read_table(".\\UCI HAR Dataset\\test\\subject_test.txt", 
                      col_names = F)
activity <- read_table(".\\UCI HAR Dataset\\test\\Y_test.txt", col_names = F)
df.test <- cbind(subject, activity, df.test)

#  Create data frame for train data
df.train <- read_table(".\\UCI HAR Dataset\\train\\X_train.txt", col_names = F)
colnames(df.train) <- features
subject <- read_table(".\\UCI HAR Dataset\\train\\subject_train.txt", 
                      col_names = F)
activity <- read_table(".\\UCI HAR Dataset\\train\\Y_train.txt", col_names = F)
df.train <- cbind(subject, activity, df.train)

# Combine test and train data
df.all <- rbind(df.test, df.train)
names(df.all)[1] <- "Subject"
names(df.all)[2] <- "Activity"

# Clear unneeded objects from the environment
rm(df.test, df.train, subject, activity)

###############################################################################

# 2. Extracts only the measurements on the mean and standard deviation for 
#    each measurement. 

df.all <- df.all[,colnames(df.all[,c(1:2,grep("mean|std",
                                                colnames(df.all)))])]

###############################################################################

# 3. Uses descriptive activity names to name the activities in the data set

activity_labels <- read_table(".\\UCI HAR Dataset\\activity_labels.txt", 
                              col_names = c("Activity", "Activity_Label"))

df.all <- df.all %>% 
    left_join(activity_labels, by = c("Activity" = "Activity"))

###############################################################################

# 4. Appropriately labels the data set with descriptive variable names. 

labels <- colnames(df.all)

labels2 <- gsub("[0-9]+ ", "", labels)
labels2 <- gsub("\\(\\)", "", labels2)
labels2 <- gsub("\\-", "_", labels2)
labels2 <- gsub("mean", "Mean", labels2)
labels2 <- gsub("std", "StdDev", labels2)
labels2 <- gsub("^t", "Time_", labels2)
labels2 <- gsub("^f", "Fourier_", labels2)

colnames(df.all) <- labels2

###############################################################################

# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

# Group by Subject and Activity_Label, then summarize by mean for all variables
df.all.grp <- df.all %>% 
    group_by(Subject, Activity_Label) %>% 
    summarise_all(funs(mean))

# Remove Activity variable since it is redundant with Activity_Label
df.all.grp <- df.all.grp[,-3]

# Write final file to a tab delimited txt file in the same directory
write_delim(df.all.grp, ".\\UCI HAR Dataset\\tidydataset.txt", delim = "\t")

