#install.packages('arules')
#install.packages('arulesViz')

library('arules')
library('arulesViz')

merge.dataframes <- function(dfs, min_num_rows = 1) {
  Reduce(function(acc, x){
    if (nrow(x) >= min_num_rows) {
      rbind(acc, x)
    } else {
      printf("Warning: %s has less than %d rows (%d), skipping", project.name(x), min_num_rows, nrow(x))
      acc
    }
  }, dfs)
}

files <- list.files(pattern= "*.csv")
csvs <- Map(function(x){read.csv(x, sep = ";")}, files)
all <- merge.dataframes(csvs)
all <- all[,!(names(all) %in% c("stack"))]

# assoc.rules.df <- all[,(names(all)) %in% c("exception_extends", "exception_from", 
#                                            "main_extends", "main_from", 
#                                            "mainsignaler_from", "root_extends", 
#                                            "root_from")]

#assoc.rules.df <- all[,(names(all)) %in% c("exception_extends", "signaler_from", 
#                                            "root_extends", "rootsignaler_from")]

assoc.rules.df <- all[,(names(all)) %in% c("main_extends", "mainsignaler_from", "exception_extends")]

rules <- apriori(assoc.rules.df, 
                 parameter = list(minlen=2, supp=0.005, conf=0.8),
                 appearance = list(rhs=c("exception_extends=CHECKED", 
                                         "exception_extends=ERROR", 
                                         "exception_extends=RUNTIME", "exception_extends=UNDEFINED"), 
                                   default="lhs"),
                 control = list(verbose=F))

rules.sorted <- sort(rules, by="lift")

subset.matrix <- is.subset(rules.sorted, rules.sorted)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant <- colSums(subset.matrix, na.rm=T) >= 1
rules.pruned <- rules.sorted[!redundant]

inspect(rules.pruned)

plot(rules.pruned, method="graph", control=list(type="items", cex=0.6))
