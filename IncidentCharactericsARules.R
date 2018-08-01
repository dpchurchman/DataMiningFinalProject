#source('LoadData.R')

# Create dfInc for initial Association Rules analysis on just "Incident Characterics"
dfInc <-  df[c('incident_id','incident_characteristics')]


# Reshape dfInc into long format using tidyr in order to get it into transaction format for arules
library(tidyr)
dfIncLong <- dfInc %>%  # Since the separator || is an operator, need \\ as escape
  separate_rows(incident_characteristics, sep="\\|\\|") 

# Change into transaction data for arules
library(arules)
transInc <- as(split(dfIncLong[,'incident_characteristics'],dfIncLong[,'incident_id']),
               "transactions")
inspect(head(transInc))
summary(transInc)

library(arulesViz)
# Plot to see most frequent items
itemFrequencyPlot(transInc, support=0.01, cex.names=.6)

rulesInc <- apriori(transInc, parameter = list(support=0.01, confidence=.1))

rulesInc
summary(rulesInc)
# See top 10 transactions
inspect(head(rulesInc, n=10), by="confidence")

#head(quality(rulesInc),20)

plot(rulesInc)
plot(rulesInc, measure = c("support", "lift"), shading = "confidence")
plot(rulesInc, method="two-key plot")
plot(rulesInc, method = "matrix", measure = "lift")

plot(rulesInc, method = "grouped", control = list(k = 50), xlab=NULL)

plot(rulesInc, method = "paracoord")
plot(rulesInc, method = "paracoord", control = list(reorder = TRUE))

plot(head(rulesInc, n=1, by="lift"), method = "doubledecker", data = transInc)

##THIS IS MY FAVORITE GRAPH##
plot(head(rulesInc,n=30, by="lift"), method="graph")


