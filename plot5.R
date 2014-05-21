# Plot5.R

# (setting dir for interactive running)
# 
# wd="C:\\Users\\mmorelli\\Google Drive\\Data Science\\04 - Exploratory Data Analysis\\Project 02\\ExDataPlotting2"
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
if(!file.exists(paste("./data", SCCfile,  sep="/"))){unzip("./data/FNEI.zip", files=SCCfile,  exdir="./data" )}
if(!file.exists(paste("./data", PM25file, sep="/"))){unzip("./data/FNEI.zip", files=PM25file, exdir="./data" )}

# ------------------------------------------------------------------------------
# 5 How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City? 
# 

# read files
SCC  <- readRDS(paste("./data", SCCfile,  sep="/"))
NEI  <- readRDS(paste("./data", PM25file, sep="/"))

#  (check)
# unique(SCC[grep("On-Road", SCC$EI.Sector), ]$EI.Sector)

SCC.MV <- SCC[grep("On-Road", SCC$EI.Sector), ]
NEI.Balt <- NEI[NEI$fips=="24510",]
NEI.MV.Balt <- merge(NEI.Balt,SCC.MV)
library(plyr)
em.MV.Balt <- ddply(NEI.MV.Balt, .(year), summarise, TotalEmissions = sum(Emissions))
# plot
library(ggplot2)
png(filename="./figure/plot5.png",  width= 480, height = 480)
print(qplot(year, TotalEmissions, geom=c("line"), data=em.MV.Balt, 
      main= "Total PM2.5 emissions related to Motor Vehicle Sources in Baltimore", ylab="Total Emissions (Tons)"))
# +theme_bw()

#-------------------------------
getwd()
dev.off()
dir(full.names=T)
?dir
