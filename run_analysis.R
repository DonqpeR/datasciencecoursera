require("dplyr")

### Loading the dataset ###
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "Dataset.zip"
setInternet2(use = TRUE) # Use IE with https on Windows
if (!file.exists(filename))
   { 
   download.file(url=fileURL, destfile=filename)
   unzip("Dataset.zip")
   }
folder <- "UCI HAR Dataset"

# Loading helper objects for determining meaningful activity names and selecting required measurements
activities <- read.table( file = paste( folder, "activity_labels.txt", sep="/" ))
features <- read.table( file = paste( folder, "features.txt", sep="/" ))

# Preparing vectors for loading only the required columns (mean and sd of each measurement)
# instead of loading all and selecting the columns later
# as suggested in https://class.coursera.org/getdata-014/forum/thread?thread_id=293#post-1277
cols <- grep( "mean\\(\\)|std\\(\\)", features$V2 )
cc <- rep( "NULL", nrow( features ) )
cc[cols] <- "numeric"

### Loading and merging test data 
x_test <- read.table( file = paste( folder, "test/x_test.txt", sep="/" )
                    , colClasses = cc
                    , col.names = features$V2
                    ) 

y_test <- read.table( file = paste( folder, "test/y_test.txt", sep="/" )
                    , col.names = "activity"
                    )
y_test$activity <- activities[y_test$activity, 2]

subject_test <- read.table( file = paste( folder, "test/subject_test.txt", sep="/" )
                          , col.names = "subject_id"  
                          )

#merged_test <- merge( subject_test, y_test, by="row.names", sort=FALSE ); merged_test$Row.names <- NULL
#merged_test <- merge( merged_test, x_test, by="row.names", sort=FALSE ); merged_test$Row.names <- NULL 
merged_test <- cbind( x_test, cbind( subject_test, y_test )) 


### Loading and merging train data 
x_train <- read.table( file = paste( folder, "train/x_train.txt", sep="/" )
                     , colClasses = cc
                     , col.names = features$V2
                     ) 

y_train <- read.table( file = paste( folder, "train/y_train.txt", sep="/" )
                     , col.names = "activity"
                     )
y_train$activity <- activities[y_train$activity, 2]

subject_train <- read.table( file = paste( folder, "train/subject_train.txt", sep="/" )
                           , col.names = "subject_id"  
                           )

#merged_train <- merge( subject_train, y_train, by="row.names", sort=FALSE ); merged_train$Row.names <- NULL
#merged_train <- merge( merged_train, x_train, by="row.names", sort=FALSE ); merged_train$Row.names <- NULL 
merged_train <- cbind( x_train, cbind( subject_train, y_train )) 

# Combining test and train data 
merged_all <- rbind(merged_test, merged_train)

### Creating data set with average values per activities and subjects
averages <- merged_all %>% group_by(activity, subject_id) %>% summarise_each("mean")
write.table( x = averages, file = "averages.txt", row.names = FALSE )
