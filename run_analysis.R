## 1: Merge the training and the test sets 
1. Download file
```{r}
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
               destfile = './hw4_data.zip', method = 'curl', quiet = T)
               unzip(zipfile = 'hw4_data.zip')
               ```
               
               2. Prepare label files
               ```{r}
               # Read in label files
               data1 <- read.table('./UCI HAR Dataset/activity_labels.txt', 
               col.names = c('activityLabels', 'activityName'), quote = "")
               # Links the class labels with their activity name
               features <- read.table('./UCI HAR Dataset/features.txt', 
               col.names = c('featureLabels', 'featureName'), quote = "")
               ```
               
               3. Prepare test data
               ```{r}
               # Read in test data
               subTest <- read.table('./UCI HAR Dataset/test/subject_test.txt', col.names = c('subjectId'))
               yTest <- read.table('./UCI HAR Dataset/test/y_test.txt')
               #Result for the test data (outcomes)
               
               # Combine all test data and give column names
               colnames(XTest) <- features$featureName
               colnames(yTest) <- c('activityLabels')
               testData <- cbind(subTest, XTest, yTest)
               
               ```
               
               
               4. Prepare training data
               ```{r}
               # Read in training data
               subTrain <- read.table('./UCI HAR Dataset/train/subject_train.txt', col.names = c('subjectId'))
               XTrain <- read.table('./UCI HAR Dataset/train/X_train.txt')
               yTrain <- read.table('./UCI HAR Dataset/train/y_train.txt')
               
               # Combine all training data and give column names
               colnames(XTrain) <- features$featureName
               colnames(yTrain) <- c('activityLabels')
               trainData <- cbind(subTrain, XTrain, yTrain)
               ```
               
               
               5. Combine test and training data
               ```{r}
               All <- rbind(trainData, testData)
               ```
               
               
               ## 2: Extract the mean and standard deviation
               ```{r}
               meansd <- All[, c(1, grep(pattern = 'mean\\(\\)|std\\(\\)', x = names(All))]
               #select only variables with mean and std - excludes meanFreq() and angle()
               ```
               
               
               ## 3: Use descriptive activity names for the activities in the data set
               ```{r}
               meansd$subjectId <- as.factor(meansd$subjectId)
               meansd$activity <- factor(meansd$activityLabels,
               levels = data1$activityLabels,
               labels = data1$activityName)
               
               #remove the activity labels column to tidy up the data
               names(meansd)
               #double check that the activityLabels column is gone
               ```
               
               
               ## 4: Label the data
               ```{r}
               colnames(meansd) <- gsub(pattern = '\\(\\)', replacement = "", x = names(meansd))
               #remove the () for the mean and std in the measurements
               #move the activity column to the second column
               write.table(meansd, file = 'tidy.txt', row.names = F, quote = F, sep = "\t")
               ```
               
               
               ## 5: Generate the average of each variable 
               ```{r, message=FALSE, warning=FALSE}
               library(dplyr)
               meanStandard <- group_by(meansd, subjectId, activity) %>% summarise_all(funs(mean))
               write.table(meanStandard, file = 'step5.txt', row.names = F, quote = F, sep = "\t")
               ```
               
               
               
               
               
               
               
               
               
