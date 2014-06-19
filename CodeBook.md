# set your own working directory here if you would like to specify a specific directory with the following command:
# setwd()

# checking if file directory already exists
if(!file.exists("./data")){dir.create("./data")}
setwd("./data")

# downloading and unziping the file
if(!file.exists("AccelerometerData.zip")){
      fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileURL,destfile="./data/AccelerometerData.zip", method="curl")
      unzip("./data/AccelerometerData.zip")
}
setwd("..")


###########
###########

# reading the test-files
if(file.exists("./test")){
      setwd("./test")
      subject_test<-read.table("subject_test.txt")
      X_test<-read.table("X_test.txt")
      y_test<-read.table("y_test.txt")
      setwd("..")
} else {warning("AccelerometerData.zip was not correctly unzipped. The directory << ./test >> is missing")}

# reading the train-files
if(file.exists("./train")){
      setwd("./train")
      subject_train<-read.table("subject_train.txt")
      X_train<-read.table("X_train.txt")
      y_train<-read.table("y_train.txt")
      setwd("..")
} else {warning("AccelerometerData.zip was not correctly unzipped. The directory << ./train >> is missing")}

# reading the features
features<-read.table("features.txt")


###########
###########

# combining test and train sub-data (test/ train)
subject_total <- rbind(subject_test, subject_train)
X_total <- rbind(X_test, X_train)
y_total <- rbind(y_test, y_train)

# preparing the merging of the datasets
total <- data.frame(count = 1:nrow(subject_total))
total$subject_total <- subject_total
colnames(X_total) <- features$V2
colnames(y_total) <- "activity_labels"

# merging datasets - total, y_total and X_total to create total
y_total$count <- 1:nrow(y_total)
y_total[y_total$activity_labels==1,1] <- "activity_walking"
y_total[y_total$activity_labels=="2",1] <- "activity_walking_upstairs"
y_total[y_total$activity_labels=="3",1] <- "activity_walking_downstairs"
y_total[y_total$activity_labels=="4",1] <- "activity_sitting"
y_total[y_total$activity_labels=="5",1] <- "activity_standing"
y_total[y_total$activity_labels=="6",1] <- "activity_laying"
total <- merge(total, y_total, by = "count")
X_total$count <- 1:nrow(X_total)
total <- merge(total, X_total, by = "count")

# checking if package stringr is already installed and if not download it
if(!("stringr" %in% row.names(installed.packages()))){
      install.packages(stringr)
}
# activate stringr package
library(stringr)


# creating a vector which shows the wanted cases (good) and the unwanted ones (bad)
## bug string cannot detect more than one search-condition)
count <- 1:length(names(total))
good <- c(
      count[str_detect(names(total), "subject_total")],
      count[str_detect(names(total), "std")],
      count[str_detect(names(total), "mean")],
      count[str_detect(names(total), "Mean")],
      count[str_detect(names(total), "activity_labels")]
)
bad <- count[!(count %in% good)]
bad <- sort(bad,decreasing=T)

# renaming the names(total) to valid R-names
names(total) <- str_replace_all(names(total), "[,-]", "_")
names(total) <- str_replace_all(names(total), "[()]", "")

# removing other than mean or std
options(warn = -1)
for (i in bad){
      total <- total[ , -(i), drop = FALSE]
}
options(warn = 0)

# creating a tidy data-list by subsetting the total data.frame by subject_total and activity_labels
tidyDataList <- list()
rep_vector <- matrix(ncol=30,nrow=4)
rep_vector[1,] <- rep.int(6,30)
rep_vector[2,] <- 0:29
rep_vector[3,] <- rep.int(1,30)
rep_vector[4,] <- rep_vector[1,]*rep_vector[2,]+rep_vector[3,]
for (k in rep_vector[4,]){
      for (i in 1:30){
            tidyDataList[[k]] <- list(total[total$subject_total==i & total$activity_labels=="activity_walking",])
            tidyDataList[[k+1]] <- list(total[total$subject_total==i & total$activity_labels=="activity_walking_upstairs",])
            tidyDataList[[k+2]] <- list(total[total$subject_total==i & total$activity_labels=="activity_walking_downstairs",])
            tidyDataList[[k+3]] <- list(total[total$subject_total==i & total$activity_labels=="activity_sitting",])
            tidyDataList[[k+4]] <- list(total[total$subject_total==i & total$activity_labels=="activity_standing",])
            tidyDataList[[k+5]] <- list(total[total$subject_total==i & total$activity_labels=="activity_laying",])
      }
}

# creating the tidyData data.frame
tidyData <- matrix(nrow = 180, ncol = 88 - 2)
for (i in 1:180){
      tidyData[i,] <- colMeans(as.data.frame(tidyDataList[[i]])[,3:88])
}

# renaming the tidyData column names to the appropriate labels
tidyData <- as.data.frame(tidyData)
names(tidyData) <- names(as.data.frame(tidyDataList[[1]]))[-(1:2)]

# adding the subject_id and the activity_label according to the subsetting approach in the nested for loop
tidyData$subject_id <- rep(1:30, each = 6)
tidyData$activity_label <- rep.int(c("activity_walking", "activity_walking_upstairs", "activity_walking_downstairs", "activity_sitting", "activity_standing", "activity_laying"),30)


###########
###########

# Writing the tidyData set into a .txt file
if(!file.exists("./CleanAccelerometerData.txt")){
      write.table(tidyData, file = "CleanAccelerometerData.txt")
} else if (file.exists("./CleanAccelerometerData.txt")){
      print("The file << CleanAccelerometerData.txt >> already exists.")
}

# command to read the file which was created by write.table
# tidyData3 <- read.table("CleanAccelerometerData.txt")