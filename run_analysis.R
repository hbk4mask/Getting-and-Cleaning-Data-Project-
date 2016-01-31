if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

# Loading activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Loading data column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Extracting only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)

# Loading and process X_test & y_test data.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_test = X_test[,extract_features]

# Loading activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Binding data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Loading and processesing X_train & y_train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features

# Extracting only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_features]

# Loading activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Binding data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merging test and train data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Applying mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")
