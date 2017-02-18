##Script to read and tidy data for Week4 assignment

# read the activity labels and set the data frame column names
activity_labels <- read.table("activity_labels.txt", sep=" ")
setnames(activity_labels, c("activity_code", "activity_label"))

# read the features text file and retain the descriptive feature names
features <- read.table("features.txt", sep = " ")
features <- features[,2]

# read the files for train data
# activity file for the train data
y_train <- read.table("train\\y_train.txt")
setnames(y_train, c("activity"))
# train data collected for all the features; retain only the mean and std deviation results from the 1st 6 columns
x_train <- read.table("train\\x_train.txt")
setnames(x_train, as.character(features))
# read the subject file for the train data
subject_train <- read.table("train\\subject_train.txt")
# combine all the separate data frames into one and set column names
train_data <- cbind(subject_train, y_train, x_train)
colHeadings1 <- c("subject", "activity")
colHeadings2 <- as.character(features)
colHeadings <- c(colHeadings1, colHeadings2)
setnames(train_data, colHeadings)

# do the same for the test data
y_test <- read.table("test\\y_test.txt")
setnames(y_test, c("activity"))
x_test <- read.table("test\\X_test.txt")
setnames(x_test, as.character(features))
subject_test <- read.table("test\\subject_test.txt")
test_data <- cbind(subject_test, y_test, x_test)
setnames(test_data, colHeadings)


#combine the test and train data sets
test_and_train <- rbind(test_data, train_data)

#convert the activity column into a factor (so that that labels are displayed)
test_and_train$activity <- factor(test_and_train$activity, levels = activity_labels[,1], labels = activity_labels[,2])

# instal and load the reshape package
install.packages("reshape")
library(reshape)

# melt the combined data over subject and activity
meltdata <- melt(test_and_train, id = c("subject", "activity"))

# cast the melted data to calculate the mean for every subject and activity
meandata <- cast(meltdata, subject + activity ~ variable, mean)

#retain only the mean and std deviation features; add the subject and activity back
colretain <- grep(".*mean.*|.*std.*", colHeadings, value = TRUE)
colretain <- c(colHeadings1, colretain)
meandata <- meandata[, colretain] 

# write the data into a file in your working directory
write.table(meandata, "Week4Assignment.txt", row.names = FALSE)