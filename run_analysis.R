#Load and setup the training set
myTable<-read.table("~/UCI HAR Dataset/train/X_train.txt",stringsAsFactors=FALSE,quote="",na.strings="NA")
SubTrain<-read.table("~/UCI HAR Dataset/train/subject_train.txt")
LabTrain<-read.table("~/UCI HAR Dataset/train/y_train.txt")
features<-read.table("~/UCI HAR Dataset/features.txt")
colnames(myTable)<-features[,2]
DataTrain<-cbind(SubTrain,LabTrain,myTable)
colnames(DataTrain)[1]<-"Subject"
colnames(DataTrain)[2]<-"Labels"

#Load and setup the testing set
myTable<-read.table("~/UCI HAR Dataset/test/X_test.txt",stringsAsFactors=FALSE,quote="",na.strings="NA")
SubTest<-read.table("~/UCI HAR Dataset/test/subject_test.txt")
LabTest<-read.table("~/UCI HAR Dataset/test/y_test.txt")
features<-read.table("~/UCI HAR Dataset/features.txt")
colnames(myTable)<-features[,2]
DataTest<-cbind(SubTest,LabTest,myTable)
colnames(DataTest)[1]<-"Subject"
colnames(DataTest)[2]<-"Labels"
finalData<-rbind(DataTrain,DataTest)

finaldata<-finalData[,grepl("Subject|Labels|std()|mean()",names(finalData))]
finaldata<-finaldata[,grep("meanFreq()",names(finaldata),invert=TRUE)]
library(plyr)
library(dplyr)

desl<-read.table("~/UCI HAR Dataset/activity_labels.txt")
colnames(desl)<-c("Labels","Names")
finaldata[,2]<-as.factor(finaldata$Labels)
levels(finaldata[,2])<-desl$Names

library(reshape2)
finale<-melt(finaldata,id=c("Subject","Labels"))
finale1<-dcast(finale,Subject+Labels~variable,mean)

write.table(finale1,"tidyData.txt",row.names=FALSE)