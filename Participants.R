#source('LoadData.R')

library(tidyr)
### Reformat Participant Information for ARules Investigation###

#Age Group
dfPartAgeGroup <-  df[c('incident_id','participant_age_group')]

dfLongTemp <- dfPartAgeGroup %>% separate_rows(2, sep="\\|\\|")
dfLongTemp <- dfLongTemp[which(dfLongTemp[,2] != ''),]

dfPartAgeGroup <- separate(dfLongTemp,participant_age_group, into=c("part","age_group"), 
                           sep = "::", remove = TRUE, convert = TRUE)

#Gender
dfPartGender <-  df[c('incident_id','participant_gender')]

dfLongTemp <- dfPartGender %>% separate_rows(2, sep="\\|\\|")
dfLongTemp <- dfLongTemp[which(dfLongTemp[,2] != ''),]

dfPartGender <- separate(dfLongTemp,participant_gender, into=c("part","gender"), 
                           sep = "::", remove = TRUE, convert = TRUE)

#Relationship
dfPartRelationship <-  df[c('incident_id','participant_relationship')]

dfLongTemp <- dfPartRelationship %>% separate_rows(2, sep="\\|\\|")
dfLongTemp <- dfLongTemp[which(dfLongTemp[,2] != ''),]

dfPartRelationship <- separate(dfLongTemp,participant_relationship, into=c("part","relationship"), 
                         sep = "::", remove = TRUE, convert = TRUE)

#Status: Killed, Injured, Arrested, Unharmed
dfPartStatus <-  df[c('incident_id','participant_status')]

dfLongTemp <- dfPartStatus %>% separate_rows(2, sep="\\|\\|")
dfLongTemp <- dfLongTemp[which(dfLongTemp[,2] != ''),]

dfPartStatus <- separate(dfLongTemp,participant_status, into=c("part","status"), 
                               sep = "::", remove = TRUE, convert = TRUE)

#Type: Suspect or Victim
dfPartType <-  df[c('incident_id','participant_type')]

dfLongTemp <- dfPartType %>% separate_rows(2, sep="\\|\\|")
dfLongTemp <- dfLongTemp[which(dfLongTemp[,2] != ''),]

dfPartType <- separate(dfLongTemp,participant_type, into=c("part","type"), 
                         sep = "::", remove = TRUE, convert = TRUE)

#Merge all the participant variables
dfPart <- merge(dfPartType, dfPartStatus, by=c("incident_id","part"), all=TRUE)
dfPart <- merge(dfPart, dfPartAgeGroup, by=c("incident_id","part"), all=TRUE)
dfPart <- merge(dfPart, dfPartGender, by=c("incident_id","part"), all=TRUE)
dfPart <- merge(dfPart, dfPartRelationship, by=c("incident_id","part"), all=TRUE)
head(dfPart)

# Get Victims and Suspects Dataframes to Analyze
dfVictims <- dfPart[which(dfPart$type == "Victim"),]
dfVictims <- dfVictims[order(dfVictims$incident_id,dfVictims$part),]

dfSuspects <- dfPart[which(dfPart$type == "Subject-Suspect"),]
dfSuspects <- dfSuspects[order(dfSuspects$incident_id,dfSuspects$part),]

dfSuspects <- data.frame(unclass(dfSuspects))


library(arules)
suspectTrans <- as(dfSuspects[,4:ncol(dfSuspects)], "transactions")
suspectTrans

summary(suspectTrans)
itemFrequencyPlot(suspectTrans, support=0.01, cex.names=0.6)

unique(dfSuspects[,4])
suspectRules <- apriori(suspectTrans,
                        parameter = list(support = 0.01, confidence = 0.01),
                        appearance = list(rhs=
                                           c('status=Unharmed, Arrested','status=Unharmed',
                                              'status=Injured','status=Killed',
                                              'status=Injured, Arrested','status=Killed, Unharmed',
                                              'status=Arrested','status=Killed, Arrested',
                                              'status=Injured, Unharmed',
                                              'status=Injured, Unharmed, Arrested',
                                              'status=Killed, Injured',
                                              'status=Killed, Unharmed, Arrested'))
                                          )

summary(suspectRules)

inspect(head(suspectRules, n=28,by="confidence"))

plot(head(suspectRules,n=10, by="lift"), method="graph")#,,engine="htmlwidget",
     #igraphLayout = "layout_in_circle")

plot(suspectRules, method = "paracoord", control = list(reorder = TRUE))

