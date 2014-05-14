# Plot2.R

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
#SCCfile  <- "Source_Classification_Code.rds"
PM25file <- "summarySCC_PM25.rds"

# unzip and caching the result
#if(!file.exists(paste("./data", SCCfile,  sep="/"))){unzip("./data/FNEI.zip", files=SCCfile,  exdir="./data" )}
if(!file.exists(paste("./data", PM25file, sep="/"))){unzip("./data/FNEI.zip", files=PM25file, exdir="./data" )}

# ------------------------------------------------------------------------------
# 2.Have total emissions from PM2.5 decreased in the Baltimore City, 
# Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system 
# to make a plot answering this question.

# read files
#SCC  <- readRDS(paste("./data", SCCfile,  sep="/"))
NEI  <- readRDS(paste("./data", PM25file, sep="/"))

options(scipen=999)   
library(plyr)
em <- ddply(NEI, .(year), summarise, TotalEmissions = sum(Emissions))

NEI.Balt <- NEI[NEI$fips=="24510",]
em.Balt <- ddply(NEI.Balt, .(year), summarise, TotalEmissions = sum(Emissions))

# -- plotting 
png(filename="./figure/plot2.png",  width= 480, height = 480)

par(mfrow = c(1, 1), bg="transparent")

barplot(em.Balt$TotalEmissions, names.arg=em$year, ylab="Emissions (Tons)", main="Total PM2.5 Emissions in Baltimore")

dev.off()


