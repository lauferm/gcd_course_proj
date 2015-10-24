
## Merges the training and the test sets to create one data set.

setwd("./Downloads/UCI HAR Dataset")
test1<-cbind(read.table("./test/subject_test.txt"),read.table("./test/y_test.txt"),read.table("./test/X_test.txt"))
train1<-cbind(read.table("./train/subject_train.txt"),read.table("./train/y_train.txt"),read.table("./train/X_train.txt"))
tt1<-rbind(test1,train1)

##Extracts only the measurements on the mean and standard deviation for each measurement. 
f<-read.table("features.txt")
tt1.mean<-tt1[c(TRUE,TRUE,grepl("mean",f[,2],ignore.case=TRUE))]
tt1.std<-tt1[c(TRUE,TRUE,grepl("std",f[,2],ignore.case=TRUE))]


##Uses descriptive activity names to name the activities in the data set
##Appropriately labels the data set with descriptive variable names. 

names(tt1.mean)<-c("subject","test",as.character(f[,2][grepl("mean",f[,2],ignore.case=TRUE)]))
names(tt1.std)<-c("subject","test",as.character(f[,2][grepl("std",f[,2],ignore.case=TRUE)]))
#tt1.data<-cbind(tt1.mean,tt1.std)
tt1.data<-cbind(tt1.mean,tt1.std[,3:(dim(tt1.std)[2]-2)])

l<-read.table("activity_labels.txt")
tt1.data.lab<-merge(tt1.data,l,by.x="test",by.y="V1")

#From the data set in step 4, creates a second, independent tidy data set
#with the average of each variable for each activity and each subject.

library("dplyr")
s<-group_by(tt1.data.lab,V2,subject)
s[,"test"]<-NULL
s.tab<-summarise_each(s,funs(mean))
names(s.tab)[1]<-"test"
write.table(s.tab,file="cproj.txt",row.name=FALSE)
