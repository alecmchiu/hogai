
dat <- read.table('outcomes1.txt',sep="\t",stringsAsFactors=F,quote="")


dat <- read.csv("archive.csv",check.names = F,stringsAsFactors = F)
dat <- subset(dat, dat$`Punxsutawney Phil` == 'Full Shadow' | dat$`Punxsutawney Phil` == 'No Shadow')
dat <- dat[complete.cases(dat),]
dat$`Punxsutawney Phil` <- as.factor(dat$`Punxsutawney Phil`)
dat$`Punxsutawney Phil` <- relevel(dat$`Punxsutawney Phil`,ref="No Shadow")
dat$Year <- as.numeric(dat$Year)

model <- glm(`Punxsutawney Phil` ~ ., data=dat, family="binomial")

library(pROC)
library(ggplot2)

stats <- roc(model$y,predict(model,type="link"))
roc_table <- data.frame(stats$sensitivities,stats$specificities)
colnames(roc_table) <- c("Sensitivity","Specificity")

best_metrics <- c(coords(stats,x="best",transpose = T),stats$auc)

ggplot(roc_table,aes(x=1-Specificity,y=Sensitivity)) + geom_point() + xlab("False Positive Rate") + ylab("Sensitivity") + theme_classic() + geom_abline(intercept=0,slope=1,linetype='dashed') + labs(subtitle=paste0("Specificity: ",round(best_metrics[2],2),", Sensitivity: ",round(best_metrics[3],2),", Accuracy: ",round((best_metrics[2]+best_metrics[3])/2,2),", C: ",round(best_metrics[4],2)))

library(ResourceSelection)
HLstats <-hoslem.test(model$y, predict(model,type="response"), g=10)
