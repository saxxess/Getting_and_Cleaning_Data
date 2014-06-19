# set your own working directory here
setwd("/Users/saxxess/Dropbox/Coursera/Data Science/03 Getting and Cleaning Data/Project/")
# getwd()

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
# subject_total <- subject_test
# X_total <- X_test
# y_total <- y_test

##############
##############

# if(!("data.table" %in% row.names(installed.packages()))){
#       install.packages(data.table)
# }
# library(data.table)
total <- data.frame(count = 1:nrow(subject_total))
# library(plyr) # maybe needed
total$subject_total <- subject_total
# head(total)
# names(total$subject_total) <- c("subject_total")
# head(total)
colnames(X_total) <- features$V2
# nrow(X_total)
colnames(y_total) <- "activity_labels"
# head(X_total)

# merging datasets
# total und y_total
y_total$count <- 1:nrow(y_total)
y_total[y_total$activity_labels==1,1] <- "activity_walking"
y_total[y_total$activity_labels=="2",1] <- "activity_walking_upstairs"
y_total[y_total$activity_labels=="3",1] <- "activity_walking_downstairs"
y_total[y_total$activity_labels=="4",1] <- "activity_sitting"
y_total[y_total$activity_labels=="5",1] <- "activity_standing"
y_total[y_total$activity_labels=="6",1] <- "activity_laying"
total <- merge(total, y_total, by = "count")
# y_total$activity_labels <- as.vector(y_total$activity_labels)
# class(y_total$activity_labels)
# head(y_total)
# total und X_total
X_total$count <- 1:nrow(X_total)
total <- merge(total, X_total, by = "count")
# head(names(total),20)
# names(total)

library(stringr)
# head(names(total),20)
# head(str_detect(names(total), c("ubject_total", "y_tes", "mean", "std")),20)

# bug string cannot detect more than one search-condition)
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

# totalTest <- total
# renaming the names(total) to valid names
names(total) <- str_replace_all(names(total), "[,-]", "_")
names(total) <- str_replace_all(names(total), "[()]", "")


# removing other than mean or std
# library(data.table)
# total <- as.data.table(total)
options(warn = -1)
for (i in bad){
#       total[ , names(total)[i] := NULL]
      total <- total[ , -(i), drop = FALSE]
}
options(warn = 0)
# total <- as.data.frame(total)



# ### go on here
# head(names(total))
# names(total)
# head(total,2)
# nrow(total$subject_total)
# ncol(total)
# nrow(total)
# dim(total)
# class(total)
# total[,2]


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


# as.data.frame(tidyDataList[[175]])[,2]
# as.data.frame(tidyDataList[[1]])[,2]
# as.data.frame(tidyDataList[[2]])[,2]
# as.data.frame(tidyDataList[[3]])[,2]
# as.data.frame(tidyDataList[[4]])[,2]
# as.data.frame(tidyDataList[[5]])[,2]
# as.data.frame(tidyDataList[[6]])[,2]
# as.data.frame(tidyDataList[[7]])[,2]
# as.data.frame(tidyDataList[[8]])[,2]
# as.data.frame(tidyDataList[[9]])[,2]



# identical(as.data.frame(tidyDataList[[1]])[,2], as.data.frame(tidyDataList[[2]])[,2])

tidyData <- matrix(nrow = 180, ncol = 88 - 2) # length(names(as.data.frame(tidyDataList[[1]]))) - 2)                   
for (i in 1:180){
      tidyData[i,] <- colMeans(as.data.frame(tidyDataList[[i]])[,3:88])
#       tidyData <- sapply(tidyDataList[[i]], colmean)
#       for k in 
#       tidyData <- mean(tidyDataList[[1]][,3])
#       colnames(tidyData) <- tidyData[i,1]
}
tidyData <- as.data.frame(tidyData)
names(tidyData) <- names(as.data.frame(tidyDataList[[1]]))[-(1:2)]
head(tidyData)

tidyData$subject_id <- rep(1:30, each = 6)
tidyData$activity_label <- rep.int(c("activity_walking", "activity_walking_upstairs", "activity_walking_downstairs", "activity_sitting", "activity_standing", "activity_laying"),30)






###########
###########




##############
##############



# Writing the tidyData set into a .txt file
# setwd("./")
if(!file.exists("./CleanAccelerometerData.txt")){
      write.table(tidyData, file = "CleanAccelerometerData.txt")
} else if (file.exists("./CleanAccelerometerData.txt")){
      print("The file << CleanAccelerometerData.txt >> already exists.")
}

# 
# tidyData3 <- read.table("CleanAccelerometerData.txt")