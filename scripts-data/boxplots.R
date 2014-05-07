library(ggplot2)
library(reshape)

data_android <- read.csv('android_repo_issues_metrics.txt', sep=';')
data_android$with_exception = (data_android$with_exception/ data_android$all) * 100
data_android$with_stack = (data_android$with_stack/ data_android$all) * 100
data_android$defect_issues = (data_android$defect_issues/ data_android$all) * 100
data_android$defect_with_exception = (data_android$defect_with_exception/ data_android$all) * 100
data_android$defect_with_stack = (data_android$defect_with_stack/ data_android$all) * 100
data_android <- data_android[ , -which(names(data_android) %in% c("all"))]
android_melted <- melt(data_android)

data_java <- read.csv('java_repo_issues_metrics.txt', sep=';')
data_java$with_exception = (data_java$with_exception/ data_java$all) * 100
data_java$with_stack = (data_java$with_stack/ data_java$all) * 100
data_java$defect_issues = (data_java$defect_issues/ data_java$all) * 100
data_java$defect_with_exception = (data_java$defect_with_exception/ data_java$all) * 100
data_java$defect_with_stack = (data_java$defect_with_stack/ data_java$all) * 100
data_java <- data_java[ , -which(names(data_java) %in% c("all"))]
java_melted <- melt(data_java)

pdf("android-stacks.pdf")
ggplot(android_melted) + aes(x=variable, y = value) + geom_boxplot() + scale_y_log10(name = "Percentage (log)") +  scale_x_discrete(name="Variable") + theme(axis.text.x = element_text(angle = 90)) + ggtitle("Android Projects")
dev.off()

pdf("java-stacks.pdf")
ggplot(java_melted) + aes(x=variable, y = value) + geom_boxplot() + scale_y_log10(name = "Percentage (log)") +  scale_x_discrete(name="Variable") + theme(axis.text.x = element_text(angle = 90)) + ggtitle("Java Projects")
dev.off()
