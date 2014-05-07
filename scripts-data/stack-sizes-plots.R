library(ggplot2)
library(reshape)
library(plyr)

data <- read.csv('stack-sizes.csv', sep=';')
ggplot(data) + facet_grid(size ~ type) + geom_histogram() + aes(x = )


