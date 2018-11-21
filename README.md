## CODEBOOK
#### Johns Hopkins University - Data Science Course
#### Gathering and Cleaning Data - Week 4
#### Final Project - November 20, 2018
===============================================================================

### DESCRIPTION OF FILES AND DATASET
This file provides a description of the process used to produce a tidy data set from raw data provided by the instructor. 

===============================================================================

The raw data is contained in a zipped file located at the following link: [UCI HAR Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

Files are located in the folder named 'UCI HAR Dataset'. The source and a brief description of the data is as described in the README.txt file within the folder.
The files needed to create the tidy data set and their locations are:
- UCI HAR Dataset\activity_labels.txt -- List of activity labels with their class labels
- UCI HAR Dataset\features.txt -- List of all features
- UCI HAR Dataset\test\subject_test.txt -- Subject number for each observation
- UCI HAR Dataset\test\X_test.txt -- Test data set
- UCI HAR Dataset\test\Y_test.txt -- Test labels (numeric code for activity label)
- UCI HAR Dataset\train\subject_train.txt -- Subject number for each observation
- UCI HAR Dataset\train\X_train.txt -- Training data set
- UCI HAR Dataset\train\Y_train.txt -- Training labels (numeric code for activity label)

Within the test and train data sets (X-train and Y-train), each feature vector is a row in the text file. Features are normalized and bounded within [-1,1].

A more detailed description of the features within the raw data is located in the file: UCI HAR Dataset\features_info.txt

The other files provided may be needed for future analysis, but are not required to create this tidy data set.

===============================================================================

### PROCESS TO CREATE TIDY DATA SET
The instructions provided were:

> You should create one R script called run_analysis.R that does the following.
> 1.  Merges the training and the test sets to create one data set.
> 2.  Extracts only the measurements on the mean and standard deviation for each measurement.
> 3.  Uses descriptive activity names to name the activities in the data set.
> 4.  Appropriately labels the data set with descriptive variable names.
> 5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The R script named 'run_analysis.R' contains the code required to create the tidy data set.
This R script should be copied into the same folder containing the 'UCI HAR Dataset' folder.

===============================================================================

#### The script performs the following steps:
1. The first step prepares the environment and loads/creates the needed data frames.
	+ Load the needed packages from the tidyverse package (dplyr, tidyr, stringr, tibble, readr, and purrr). NOTE: The developer's network cannot install the full tidyverse, so the R script loads the packages separately.
	+ Clear the current working environment of existing objects.
	+ For each data set (test and train):
		+ Load the data file (X_test or X-train) into a data frame.
		+ Add column names to the data frame from the features.txt file.
		+ Merge the data frame with its subject and activity tables to create a complete data frame with each observation containing the subject number, the activity number, and a vector of 561 features.
	+ Merge the test and train data sets into a single data frame.
2. Limit the data frame to only the first two fields (Subject and Activity) and any field that contains the text 'mean' or 'std'. This results in a data frame with 82 variables and 10299 observations.
3. The next step creates a new field to describe the activity. This is done using a left_join between the data frame and the activity labels file. The result of this step is an expanded data frame that also includes the label for each observation's activity code. This field is named 'Activity_Label'.
4. Next, the variable names are modified to make them more readable. For each variable, modifications include: deleting the numbers at the beginning, deleting the parentheses, replacing dashes with underscores, replacing 'mean' with 'Mean' and 'std' with 'StdDev', replacing the first letter 't' with 'Time_' and 'f' with 'Fourier_'. 
	+ Example: '1 tBodyAcc-mean()-X' becomes 'Time_BodyAcc_Mean_X'
	+ This provides a clearer description of each variable without becoming too lengthy.
5. The final step in the code is to group the data by 'Subject' and 'Activity_Label', then summarize the data using the mean of each variable. The end result is a data	frame containing a single row for each subject by activity (6 activities for each of the 30 subjects = 180 rows). The 'Activity' field is removed since the data now contains the 'Activity_Label' and would be redundant. A tab delimited text file is then created in the 'UCI HAR Dataset' folder containing the tidy data set. This file is named 'tidydataset.txt'.

===============================================================================	

