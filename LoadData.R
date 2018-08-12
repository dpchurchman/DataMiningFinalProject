# Load in data
load <- read.csv("gunViolence.csv", header=TRUE)

library(rmarkdown)
library(arules)
library(tidyr)
library(arulesViz)
library(knitr)
library(htmltools)

render('Lab3Markdown.Rmd')
