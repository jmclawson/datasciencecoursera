# Summary
The script provided here allows for analysis of a specific dataset. The original dataset included sensor measurements from the phones of thirty subjects taking part in one of six activities; these data are originally split across a number of tables. For each activity performed by each subject, 'run_analysis.R' returns a single tidy dataset of the averages of the variables that are standard deviations or means.

# Method
1. First, 'run_analysis.R' checks for a local version of the dataset, downloading and unzipping it if needed. 
2. Next, reading 'subject_test.txt', 'y_test.txt', 'X_test.txt', 'subject_train.txt', 'y_train.txt', and 'X_train.txt', it combines these data into one main table. 
3. From 'features.txt', it names most variables, adding "subject" as the variable name for data from 'subject_test.txt' and 'subject_train.txt', and adding "activity" as the variable name for data from 'y_test.txt' and 'y_train.txt'.
4. Using these variable names, it subsets only those that include '.mean', '.std', 'activity', and 'subject', excluding those that include '.meanFreq'.
5. Finally, it organizes the data to find and return variable averages for each activity performed by each subject. It outputs this data to a file, 'data_analysis.csv'. 

# Variables
The first two columns indicate the subject (numbered 1 to 30) and activity (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING). Variable names for columns 3 through 68 derive from the original dataset and describe records from motion sensors in Samsung Galaxy S II smartphones. These variables are prefixed by 't' to indicate time domain signals or 'f' to indicate frequency domain signals. All variable names provide abbreviations of a set of measurements. Some variables are split among three dimensions (marked by X, Y, and Z), while others mark the magnitude of these dimensions (marked by 'Mag').

# Sources
The original dataset can be found at 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
