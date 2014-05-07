library(ellipse)
library(ggplot2)
library(reshape)
library(xtable)
library(digest)
library(xtable)
library(plyr)

quant5 <- function(x){quantile(x, 0.05)}
quant95 <- function(x){quantile(x, 0.95)}

run <- function(all = data.frame(), descr.stats = data.frame(), 
                ref="descr.stats", capt = "" ) {

  descr.stats$Feature <- as.character(descr.stats$Feature)

  descr.stats$quant_5 <- lapply(descr.stats$Feature, 
                                function(x){quantile(all[,x], 0.05,na.rm = T)})
  descr.stats$mean <- lapply(descr.stats$Feature, 
                             function(x){mean(all[,x], na.rm = T)})
  descr.stats$median <- lapply(descr.stats$Feature, 
                               function(x){median(all[,x], na.rm = T)})
  descr.stats$quant_95 <- lapply(descr.stats$Feature, 
                                 function(x){quantile(all[,x], 0.95, na.rm = T)})

  descr.stats$histogram <- lapply(descr.stats$Feature, function(x) {
  
    print(sprintf("Histogram for %s", x))
    data <- all[, x]
    unq <- digest(sprintf("%s.%s", ref, as.character(x)))
    fname <- sprintf("hist-%s.pdf",unq)

    par(mar=c(0,0,0,0))
    plot.window(c(0,1),c(0,1),  xaxs='i', yaxs='i')
    pdf(file = fname , width = 6, height = 3)
    hist(log(data), probability = TRUE, col = "red", border = "white",
         breaks = 10, xlab = "", ylab = "", axes = F, main = NULL)
    dev.off()
    sprintf("\\includegraphics[scale = 0.1, clip = true, trim= 50px 60px 50px 60px]{hist-%s.pdf}", unq)
})

  table <- xtable(descr.stats, label=sprintf("tab:%s", ref),
                  caption= sprintf("%s%s", capt, " Historgrams are in log scale."),
                  align = c("l", "r","p{16em}", rep("r", 4), "c"))

  print.xtable(table, file = sprintf("%s.tex", ref),
               floating.environment = "table*",
               include.rownames = F, size = c(-2),
               sanitize.text.function = 
                  function(str)gsub("_","\\_",str,fixed=TRUE))
}

# Java src code statistics
java.src <- read.csv('java_repo_src_metrics.txt')

descr.stats.src <- data.frame(
  Feature = c('loc',
              'ehloc',
              'num_classes',
              'userdefined_exceptions',
              'num_methods',
              'num_methods_throw',
              'num_public_methods',
              'num_public_methods_throws',
              'num_nonpublic_methods',
              'num_nonpublic_methods_throws',
              #'percent_nonpublic_method_throws',
              'num_throw_statements',
              'num_try',
              'num_catch',
              #'empty_catchs',
              'throw_on_catch',
              'return_on_catch',
              'return_on_finall',
              'log_on_finally',
              'specific_action_onfinally'
             ),
  Description = c(
    "Lines of code.",
    "Lines of code devoted to exception handling.",
    "Number of user defined exception types.",
    "Number of classes.",
    "Number of methods.",
    "Number of methods that throw an exception.",
    "Number of public methods.",
    "Number of public methods that throw an exception.",
    "Number of private/protected/package methods.",
    "Number of private/protected/package methods that throw an exception.",
#    "Percentage of non-public methods that throw",
    "Number of throw statements.",
    "Number of try blocks.",
    "Number of catch blocks.",
#   "Number of empty catch blocks"    
    "Number of try blocks that throw an exception.",
    "Number of catch blocks with an explicit return statement.",
    "Number of finally blocks with an explicit return statement.",
    "Number of finally blocks including logging statements.",
    "Number of finally blocks including resource cleanup actions."
  )
)

run(java.src, descr.stats.src, "java-descr-stats", "Descriptive statistics for the Java dataset.")

# Android and Java stacktrace statistics
java.stacks <- read.csv('java_repo_issues_metrics.txt', sep = ";")
android.stacks <- read.csv('android_repo_issues_metrics.txt', sep = ";")
java.stacks<-rename(java.stacks, c("X.repo_java" = "repo"))
android.stacks<-rename(android.stacks, c("X.repo_android" = "repo"))

all.stacks <- rbind(java.stacks, android.stacks)

descr.stats.stacks <- data.frame(
  Feature = c('all',
              'with_exception',
              'with_stack',
              'defect_issues',
              'defect_with_exception',
              'defect_with_stack'
             ),
  Description = c(
    "All issues recorded for the project.",
    "All issues featuring an exception.",
    "All issues featuring a stack trace.",
    "All issues labeled as defect.",
    "All issues labeled labeled as defect and including an exception.",
    "All issues labeled labeled as defect and including a stacktrace"
  )
)

run(all.stacks, descr.stats.stacks, "stacktrace-stats", "Descriptive statistics for the analyzed issue dataset.")

# Android stats just for selected projects
android.stacks <- read.csv('android_repo_issues_metrics.txt', sep = ";")
android.stacks <- rename(android.stacks, c("X.repo_android" = "repo"))
android.repos <-  read.csv('android-projects.txt')

all.stacks <- merge(android.stacks, android.repos, by.x="repo", by.y="repo") 

descr.stats.stacks <- data.frame(
  Feature = c('all',
              'with_exception',
              'with_stack',
              'defect_issues',
              'defect_with_exception',
              'defect_with_stack'
             ),
  Description = c(
    "All issues recorded for the project.",
    "All issues featuring an exception.",
    "All issues featuring a stack trace.",
    "All issues labeled as defect.",
    "All issues labeled labeled as defect and including an exception.",
    "All issues labeled labeled as defect and including a stacktrace"
  )
)

run(all.stacks, descr.stats.stacks, "android-stack-stats", "Descriptive statistics for the analyzed issue dataset for Android projects.")

