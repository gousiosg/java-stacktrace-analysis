library(ellipse)
library(ggplot2)
library(reshape)
library(xtable)

issue_metrics <- read.csv('java_repo_issues_metrics.txt', sep=';')
src_metrics <- read.csv('java_repo_src_metrics.txt')
src_metrics$repo_java <- apply(src_metrics, 1, function(x){strsplit(x,
                                                                    "/")[[1]][2]})
src_metrics$repo_java <- as.factor(src_metrics$repo_java)

combined<-merge(src_metrics, issue_metrics, by.x="repo_java", by.y="X.repo_java")

used <- combined[ , -which(names(combined) %in% c('repo_java', 'repo'))]

# Cross correlation ellipses
ctab <- cor(used, method = "spearman", use='complete.obs')
colorfun <- colorRamp(c("#ff0000","white","#0000ff"), space="rgb")
pdf("cross-cor.pdf")
plotcorr(ctab,col=rgb(colorfun((ctab+1)/2), maxColorValue=255),
         outline = FALSE)
dev.off()

# Cross correlation table
print(xtable(ctab,
             caption="Cross correlation matrix (Spearman) between examined factors",
             label="tab:crosscor"),
      type = "latex",
      size = "small",
      file = "cross-cor.tex")

# Cross correlation heatmap
ctab.m <- melt(ctab)
pdf("cross-cor-heat.pdf")
ggplot(ctab.m, aes(X1, X2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(space = "Lab") +
  theme(axis.title = element_blank(),
        axis.text = element_text(size = 11),
        axis.text.x = element_text(angle = -90, hjust = 0, vjust = 0.5))
dev.off()
