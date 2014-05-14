# Plot6.R

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
if(!file.exists(paste("./data", SCCfile,  sep="/"))){unzip("./data/FNEI.zip", files=SCCfile,  exdir="./data" )}
if(!file.exists(paste("./data", PM25file, sep="/"))){unzip("./data/FNEI.zip", files=PM25file, exdir="./data" )}

# ------------------------------------------------------------------------------
# 6 Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

# read files
SCC  <- readRDS(paste("./data", SCCfile,  sep="/"))
NEI  <- readRDS(paste("./data", PM25file, sep="/"))


SCC.MV <- SCC[grep("^Mobile", SCC$EI.Sector), ]
NEI.Balt.LA <- NEI[NEI$fips=="24510" | NEI$fips=="06037",]
NEI.MV.Balt.LA <- merge(NEI.Balt.LA,SCC.MV)

em.MV.Balt.LA <- ddply(NEI.MV.Balt.LA, .(year, fips), summarise, TotalEmissions = sum(Emissions))

# beautify the names
em.MV.Balt.LA$City <- ""
em.MV.Balt.LA[em.MV.Balt.LA$fips=="24510",]$City <- "Baltimore"
em.MV.Balt.LA[em.MV.Balt.LA$fips=="06037",]$City <- "Los Angeles"

# plot
library(ggplot2)

png(filename="./figure/plot6.png",  width= 480, height = 480)
print(qplot(year, TotalEmissions, facets=.~City, geom=c("line"), data=em.MV.Balt.LA,
      main= "Total PM2.5 emissions in Baltimore and LA", ylab="Total Emissions (Tons)"))
#+theme_bw()
dev.off()
