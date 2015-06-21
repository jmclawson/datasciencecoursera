# This script does the following. 
  # 1. Merges the training and the test sets to create one data 
    # set.
  # 2. Extracts only the measurements on the mean and standard 
    # deviation for each measurement. 
  # 3. Uses descriptive activity names to name the activities in 
    # the data set
  # 4. Appropriately labels the data set with descriptive 
    # variable names. 
  # 5. From the data set in step 4, creates a second, 
    # independent tidy data set with the average of each 
    # variable for each activity and each subject.

# Load necessary library
library("dplyr")

# Establish working locations
destdir <- "course-project"
destname <- "projectdata.zip"
destpath <- paste(".", destdir, destname, sep="/")

# Create directory if needed
if (!file.exists(destdir)){dir.create(destdir)}

# Download file if needed
if (!file.exists(destpath)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, destfile=destpath, method="curl")
}

# Unzip data and introduce its path
unzip(destpath, exdir=paste(".", destdir, "", sep="/"))
fpath <- paste(paste(".", destdir, sep="/"),"UCI HAR Dataset",sep="/")

# Add train and test data to fulldata if it doesn't exist
fulldata <- data.frame()
targets <- c("train", "test")
for(target in targets){
  aimX <- paste("X_", target, ".txt", sep="")
  aimY <- paste("y_", target, ".txt", sep="")
  aimSubject <- paste("subject_", target, ".txt", sep="")
  targetpathX <- paste(fpath,target,aimX,sep="/")
  targetpathY <- paste(fpath,target,aimY,sep="/")
  targetSubject <- paste(fpath,target,aimSubject,sep="/")
  targetdata <- cbind(read.table(targetpathX),
                      read.table(targetpathY),
                      read.table(targetSubject))
  fulldata <- rbind(fulldata, targetdata)
}

# for step 4, name columns, adding activity and subject
features <- read.table(paste(fpath,"features.txt",sep="/"))
colnames(fulldata) <- features[,2]
colnames(fulldata)[562:563] <- c("activity","subject")
# Strip illegal characters from column names
colnames(fulldata) <- make.names(names=names(fulldata), 
                                 unique=TRUE, allow_ = TRUE)
 
# Subset the appropriate data for step 2
subData <- select(fulldata, 
                  contains(".mean"), 
                  contains(".std"), 
                  -contains(".meanFreq"),
                  contains("activity"),
                  contains("subject"))

# Name the activities descriptively for step 3
activitylabels <- read.table(paste(fpath,"activity_labels.txt",sep="/"))
subData[,67] <- activitylabels[subData[,67], 2]

# For step 5, average columns for each subject / activity
answer <- matrix(ncol=68,nrow=0)
for (subject in unique(subData$subject)) {
  for (activity in unique(subData$activity)) {
    this.row <- subset(subData, subject == subject & activity==activity)
    variable.means <- sapply(this.row[,1:66], mean, na.rm=TRUE)
    variable.means <- c(subject, activity, variable.means)
    names(variable.means)[1:2] <- c("Subject", "Activity")
    answer <- rbind(answer, variable.means)
  }
}

# Format the output
answer <- as.data.frame(answer, stringsAsFactors = FALSE)
row.names(answer) <- NULL
answer <- arrange(answer,as.numeric(Subject),Activity)

# Save the answer to a file
write.table(answer, 
            file = paste(".", destdir, "data_analysis.csv", sep="/"), 
            sep=",", 
            row.names = FALSE)
