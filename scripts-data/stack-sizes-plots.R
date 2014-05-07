library(ggplot2)
library(reshape)
library(plyr)

data <- read.csv('stack-sizes.csv', sep=';')

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

p1 <- ggplot(subset(data, type == 'java')) + 
      aes(x = size) + 
      geom_histogram(bin = 5) +
      ggtitle("Java")
p2 <- ggplot(subset(data, type == 'android')) + 
      aes(x = size) + 
      geom_histogram(bin = 5) +
      ggtitle("Android")

p3 <- ggplot(subset(data, type == 'java')) + 
      aes(x = wrappings) + 
      geom_histogram() +
      ggtitle("Java")
p4 <- ggplot(subset(data, type == 'android')) + 
      aes(x = wrappings) + 
      geom_histogram() +
      ggtitle("Android")

pdf("stack-size-wrappings-hist.pdf")
multiplot(p1, p3, p2, p4, cols = 2)
dev.off()
