# Plot6.R

# (setting dir for interactive running)
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
# 6 Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

# read files
SCC  <- readRDS(paste("./data", SCCfile,  sep="/"))
NEI  <- readRDS(paste("./data", PM25file, sep="/"))


SCC.MV <- SCC[grep("On-Road", SCC$EI.Sector), ]
NEI.Balt.LA <- NEI[NEI$fips=="24510" | NEI$fips=="06037",]
NEI.MV.Balt.LA <- merge(NEI.Balt.LA,SCC.MV)

library(plyr)
em.MV.Balt.LA <- ddply(NEI.MV.Balt.LA, .(year, fips), summarise, TotalEmissions = sum(Emissions))

# beautify the names
em.MV.Balt.LA$City <- ""
em.MV.Balt.LA[em.MV.Balt.LA$fips=="24510",]$City <- "Baltimore"
em.MV.Balt.LA[em.MV.Balt.LA$fips=="06037",]$City <- "Los Angeles"

# create baseline for analysis variation
baseline.Balt <-   em.MV.Balt.LA[em.MV.Balt.LA$City=="Baltimore" & em.MV.Balt.LA$year==1999,]$TotalEmissions
baseline.LA   <-   em.MV.Balt.LA[em.MV.Balt.LA$City=="Los Angeles" & em.MV.Balt.LA$year==1999,]$TotalEmissions
em.MV.Balt.LA$EmissionsVar <- NA
em.MV.Balt.LA[em.MV.Balt.LA$City=="Baltimore" ,]$EmissionsVar   <- em.MV.Balt.LA[em.MV.Balt.LA$City=="Baltimore" ,]$TotalEmissions / baseline.Balt
em.MV.Balt.LA[em.MV.Balt.LA$City=="Los Angeles" ,]$EmissionsVar <- em.MV.Balt.LA[em.MV.Balt.LA$City=="Los Angeles" ,]$TotalEmissions / baseline.LA


# plot
# Note: label is fixed. I could parametrize them, (as with 1999 that is hardcoded)
#       but I thing that is beyond what requested
library(ggplot2)
g <- ggplot(em.MV.Balt.LA, aes(x=year, y=EmissionsVar*100, colour=City, group=City)) 
g <- g + geom_line(size=1) + ggtitle("Motor Vehicle PM 2.5 emission Variation in Baltimore and LA")
g <- g + ylab("Emission Variation (baseline 1999=100)")
g <- g + annotate("text", x = 2004, y = 80, size=4,
                  label = "LA PM 2.5 MV emission increased 4%,")
g <- g + annotate("text", x = 2004, y = 75, size=4,
                  label = "Baltimore PM 2.5 MV emission decreased 75%")

png(filename="./figure/plot6.png",  width= 480, height = 480)
print(g)
dev.off()
#-------------------------------------#


