# Load in data
df <- read.csv("gunViolence.csv", header=TRUE)

# Remove less helpful columns
df <- subset(df, select=-c(incident_url,notes,location_description,participant_name,
                           state_senate_district, sources,
                           longitude,latitude,congressional_district,state_house_district,
                           incident_url_fields_missing,source_url,address,city_or_county))

# Remove non-shooting incidents
library(arules)
library(arulesViz)

df <- read.csv("gunViolence.csv", header=TRUE)

df <- df[!grepl("Non-Shooting Incident", df$incident_characteristics),]
df <- df[!grepl("Gun buy back action", df$incident_characteristics),]
df <- df[!grepl("Possession \\(gun\\(s\\) found during commission of other crimes\\)", 
                df$incident_characteristics),]

#str(df)
#summary(df)
