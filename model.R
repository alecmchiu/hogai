#!/bin/env Rscript

library(reshape)
library(dplyr)
library(mice)

dat <- read.table("outcomes_clean.txt",stringsAsFactors = F,header=F,sep="\t")
colnames(dat) <- c("year","outcome")
dat$outcome <- as.factor(dat$outcome)

climate <- read.csv("data_raw/DS3505/data.csv",stringsAsFactors = F, na.strings = c("*","**","***","****","*****","******","********"))
climate[,c(1,2)] <- NULL
climate$YR..MODAHRMN <- as.POSIXlt(as.character(climate$YR..MODAHRMN),format="%Y%m%d%H%M", tz="GMT")
climate <- climate[which(climate$YR..MODAHRMN$hour == 11),]
climate <- climate[which(climate$YR..MODAHRMN$mon == 1),]
climate <- climate[which(climate$YR..MODAHRMN$mday == 2),]
climate <- climate[,-which(apply(climate,2,function(x){sum(is.na(x))/nrow(climate)}) == 1)]
climate$YR..MODAHRMN <- as.numeric(substr(as.character(climate$YR..MODAHRMN),1,4))
climate$SKC <- as.factor(climate$SKC)

climate$DIR[is.na(climate$DIR)] <- 0
climate$DIR[climate$DIR == 990] <- NA

climate_imp <- mice(climate,seed=1,m = 10,maxit = 10)
climate_imp <- complete(climate_imp)
climate <- climate_imp

climate[,c(8:13)] <- NULL
climate[,c(4,9:17)] <- NULL
climate[,4] <- NULL

colnames(climate) <- c("year","wind_angle","wind_speed","sky_coverage",'visibility','temperature')

full_data <- right_join(dat,climate,by="year")
#full_data$sky_coverage[is.na(full_data$sky_coverage)] <- names(which.max(table(full_data$sky_coverage)))

set.seed(0)
test_set <- sample(1:nrow(full_data),.1*nrow(full_data))

log_reg <- glm(outcome ~ .,data=full_data[-test_set,],family="binomial")

library(pROC)
library(ggplot2)
library(ResourceSelection)

stats <- roc(log_reg$y,predict(log_reg,type="response"))
roc_table <- data.frame(stats$sensitivities,stats$specificities)
colnames(roc_table) <- c("Sensitivity","Specificity")
best_metrics <- c(coords(stats,x="best",transpose = T),stats$auc)
ggplot(roc_table,aes(x=1-Specificity,y=Sensitivity)) + geom_point() + xlab("False Positive Rate") + ylab("Sensitivity") + theme_classic() + geom_abline(intercept=0,slope=1,linetype='dashed') + labs(subtitle=paste0("Specificity: ",round(best_metrics[2],2),", Sensitivity: ",round(best_metrics[3],2), ", Accuracy: ",round((best_metrics[2]+best_metrics[3])/2,2),", C: ",round(best_metrics[4],2)))
hoslem.test(log_reg$y,predict(log_reg,type="response"),g=10)

metrics <- function(preds,acc_tests){
  stats <- roc(log_reg$y,as.numeric(preds))
  roc_table <- data.frame(stats$sensitivities,stats$specificities)
  colnames(roc_table) <- c("Sensitivity","Specificity")
  best_metrics <- c(coords(stats,x="best",transpose = T),stats$auc)
  print(ggplot(roc_table,aes(x=1-Specificity,y=Sensitivity)) + geom_point() + xlab("False Positive Rate") + ylab("Sensitivity") + theme_classic() + geom_abline(intercept=0,slope=1,linetype='dashed') + labs(subtitle=paste0("Specificity: ",round(best_metrics[2],2),", Sensitivity: ",round(best_metrics[3],2), ", Accuracy: ",round((best_metrics[2]+best_metrics[3])/2,2),", C: ",round(best_metrics[4],2),", Test: ",round(acc_tests,2))))
  hoslem.test(log_reg$y,as.numeric(preds),g=10)
}

library(e1071)
library(rpart)
library(randomForest)

nb <- naiveBayes(outcome~.,data=full_data[-test_set,])
metrics(apply(predict(nb,full_data[-test_set,-2],type="raw"),1,max))
svm_model <- svm(outcome~.,data=full_data[-test_set,])
metrics(attr(predict(svm_model,full_data[-test_set,],decision.values = T),"decision.values"))
rp <- rpart(outcome~.,data=full_data[-test_set,])
metrics(apply(predict(rp,full_data[-test_set,]),1,max))
rand_for <- randomForest(outcome~.,data=data.matrix(full_data[-test_set,]),importance=T)
metrics(predict(rand_for,data.matrix(full_data[-test_set,-2])))

lr_test <- sum(round(predict(log_reg,full_data[test_set,],type="response")) + 1 == as.numeric(full_data[test_set,2]))
nb_test <- sum(predict(nb,full_data[test_set,],type="class") == full_data[test_set,2])
svm_test <- sum(predict(svm_model,newdata=full_data)[test_set] == full_data[test_set,2])
rp_test <- sum(predict(rp,full_data[test_set,],type='class') == full_data[test_set,2])
rf_test <- sum(round(predict(rand_for,data.matrix(full_data[test_set,]))) == as.numeric(full_data[test_set,2]))
acc_tests <- c(lr_test,nb_test,svm_test,rp_test,rf_test)/5


metrics(predict(log_reg,full_data[-test_set,-2],type="response"),acc_tests[1])
metrics(apply(predict(nb,full_data[-test_set,-2],type="raw"),1,max),acc_tests[2])
metrics(attr(predict(svm_model,full_data[-test_set,],decision.values = T),"decision.values"),acc_tests[2])
metrics(apply(predict(rp,full_data[-test_set,]),1,max),acc_tests[2])
metrics(predict(rand_for,data.matrix(full_data[-test_set,-2])),acc_tests[2])

save(rand_for,file="rf.RData")

