# Step 1: loading training/test datasets
trainSubject <- read.table("./PRAData/train/subject_train.txt")
trainData <- read.table("./PRAData/train/X_train.txt")
trainLabel <- read.table("./PRAData/train/y_train.txt")

testSubject <- read.table("./PRAData/test/subject_test.txt")
testData <- read.table("./PRAData/test/X_test.txt")
testLable <- read.table("./PRAData/test/y_test.txt")

activity_labels <- read.table("./PRAData/activity_labels.txt", stringsAsFactors = FALSE)
activity_labels[,2] <- tolower(gsub("_", ".", activity_labels[,2]))

# Step 1. extracting mean/std for each measurement & labeling each feature
features <- read.table("./PRAData/features.txt")
features <- as.character(features[,2])
featureLabels <- grep("mean\\(\\)|std\\(\\)", features)
features <- features[featureLabels]
features <- gsub("\\(\\)", "", features)
features <- gsub("-", ".", features)
features <- gsub("mean", "Mean", features)
features <- gsub("std", "Std", features)

# Step 3. merging data
subject <- rbind(trainSubject, testSubject)
activityLabel <- rbind(trainLabel, testLable)
mergedData <- rbind(trainData[, featureLabels], testData[, featureLabels])
names(mergedData) <- features
mergedData$subject <- subject[,1]
mergedData$activity <- activity_labels[activityLabel[,1],2]
write.table(mergedData, "merged_data.txt", row.names = FALSE)

# Step 4. grouping dataset by subject & activity, computing average of each group
averageData <- aggregate(mergedData[, 1:66], 
                         list("subject" = mergedData$subject, 
                              "activity" = mergedData$activity), 
                              FUN = mean)

write.table(averageData, "average_data.txt", row.names = FALSE)
