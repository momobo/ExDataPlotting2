# Plot1.R

# (setting dir for interactive running)
# wd="C:\\Users\\mmorelli\\Google Drive\\Data Science\\04 - Exploratory Data Analysis\\Project 02"
# setwd(wd)

Url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

#  --- general data preparation --
# create directory if they do not exists
if(!file.exists("./data")){dir.create("./data")}
if(!file.exists("./figure")){dir.create("./figure")}

# check if data exists. If not download it.
if(!file.exists("./data/FNEI.zip")){
    Url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(Url,destfile="./data/FNEI.zip", mode = "wb", method="auto") 
}

# list of files in zip
SCCfile  <- "Source_Classification_Code.rds"
PM25file <- "summarySCC_PM25.rds"

# unzip and caching the result
#if(!file.exists(paste("./data", SCCfile,  sep="/"))){unzip("./data/FNEI.zip", files=SCCfile,  exdir="./data" )}
if(!file.exists(paste("./data", PM25file, sep="/"))){unzip("./data/FNEI.zip", files=PM25file, exdir="./data" )}

# ------------------------------------------------------------------------------
# plot
# 1.Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission 
# from all sources for each of the years 1999, 2002, 2005, and 2008.

# read files
#SCC  <- readRDS(paste("./data", SCCfile,  sep="/"))
NEI  <- readRDS(paste("./data", PM25file, sep="/"))

options(scipen=999)   
library(plyr)
em <- ddply(NEI, .(year), summarise, TotalEmissions = sum(Emissions))

# plotting plot
png(filename="./figure/plot1.png",  width= 480, height = 480)

par(mfrow = c(1, 1), bg="transparent")

barplot(em$TotalEmissions, names.arg=em$year, ylab="Emissions (Tons)", main="Total PM2.5 Emissions")

dev.off()



