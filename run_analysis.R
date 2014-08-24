#SECTION 1
# setwd("C:/Users/pottsi/Google Drive/coursera/Getting and Cleaning Data/project/Getting-and-Cleaning-Data-project/Getting-and-Cleaning-Data-project")

#Import train, add Y and subject columns, repeat for test
train = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
train[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
train[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
# train[,564] = as.factor("train")

test = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
test[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
test[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
# test[,564] = as.factor("test")

activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

#Import features and make better names
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '_', features[,2])
features[,2] = gsub('[,]', '_', features[,2])

# Merge train and test sets together
data = rbind(train, test)

#SECTION 2
# Get only the data on mean and std. dev.
colsWeWant <- grep(".*Mean.*|.*Std.*", features[,2]) 
# trim the features table to what we want
features <- features[colsWeWant,]

# ColsToDrop <- grep("*Freq_*", features[,2])
# features <- features[%%!in%% ColsToDrop,]

# Now add the last two columns (subject and activity)
colsWeWant <- c(colsWeWant, 562, 563)
# And remove the unwanted columns from data
data <- data[,colsWeWant]
# Add the column names (features) to data
colnames(data) <- c(features$V2, "Activity", "Subject")
# colnames(data) <- tolower(colnames(data))

#SECTION 3
currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  data$Activity <- gsub(currentActivity, currentActivityLabel, data$Activity)
  currentActivity <- currentActivity + 1
}

data$Activity <- as.factor(data$Activity)
data$Subject <- as.factor(data$Subject)

#SECTION 4
tidy = aggregate(data, by=list(activity = data$Activity, subject=data$Subject), mean)
# Remove the subject and activity column, since a mean of those has no use
tidy[,90] = NULL
tidy[,89] = NULL
write.table(tidy, "tidy.txt", sep="\t",row.name=FALSE)