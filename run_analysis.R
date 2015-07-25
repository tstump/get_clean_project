####################################################################

# clean up workspace
rm(list=ls())

####################################################################
# 0. Read in the raw data

# read the training data
x_train <- read.table("./train/x_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

# read the test data
x_test <- read.table("./test/x_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

# read in the labels
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

####################################################################
# 1. Merge the training and the test sets to create one data set.

### concatenate features data and assign column names
### select only mean/std columns
data_features <- rbind(x_train,x_test)
names(data_features) <- features$V2
mean_std_names <- as.character(features$V2[grep("mean\\(\\)|std\\(\\)",features$V2)])
data_features <- subset(data_features,select=mean_std_names)

### concatenate activity data and assign column names
data_activity <- rbind(y_train,y_test)
names(data_activity) <- c("activity")

### concatenate subject data and assign column names
data_subject <- rbind(subject_train,subject_test)
names(data_subject) <- c("subject")

### combine columns to get dataset
data <- cbind(data_subject,data_activity,data_features)

####################################################################
# 2. Use descriptive activity names to name the activities in the 
# data set
### merge on activity names
data <- merge(data,activity_labels,by.x="activity",by.y="V1")

### drop activity number
data <- subset(data,select=-activity)

####################################################################
#3. Appropriately labels the data set with descriptive variable 
# names.

### clearly state what variables are
names(data) <- gsub("^t","time",names(data))
names(data) <- gsub("^f","frequency",names(data))
names(data) <- gsub("Acc","Accelerometer",names(data))
names(data) <- gsub("Gyro","Gyroscope",names(data))
names(data) <- gsub("Mag","Magnitude",names(data))
names(data) <- gsub("BodyBody","Body",names(data))
names(data) <- gsub("V2","activity_label",names(data))

####################################################################
#4. create independent tidy data set with the average of each 
#   variable for each activity and each subject.

### get tidy dataset
library(plyr)
tidydata <- aggregate(. ~subject+activity_label, data, mean)
tidydata <- tidydata[order(tidydata$subject,tidydata$activity_label),]
write.table(tidydata,file="tidydata.txt",row.names=FALSE)

####################################################################