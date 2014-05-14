# Plot4.R

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
# 4.Across the United States, how have emissions from coal combustion-related 
# sources changed from 1999-2008?

# read files
SCC  <- readRDS(paste("./data", SCCfile,  sep="/"))
NEI  <- readRDS(paste("./data", PM25file, sep="/"))

# id the coal combustion relate source:
SCC.Coal <- SCC[grep("[Cc]omb.*[cC]oal", SCC$Short.Name), ]
# join (after the id, the reverse would be extremely inefficient)
NEI.Coal <- merge(NEI,SCC.Coal)

em.Coal <- ddply(NEI.Coal, .(year), summarise, TotalEmissions = sum(Emissions))

# -- plotting 
library(ggplot2)
png(filename="./figure/plot4.png",  width= 480, height = 480)

print(qplot(year, TotalEmissions, geom=c("line"), data=em.Coal, 
      main= "Total PM2.5 emissions related to Coal combustion in USA", ylab="Total Emissions (Tons)"))
      #+theme_bw()
dev.off()

#-----------------------------------------------------------------------------------------------------
# other possibility, but it is not pretty
#library(lattice)
#em2.Coal <- ddply(NEI.Coal, .(year, SCC), summarise, TotalEmissions = sum(Emissions))
#xyplot(TotalEmissions ~ year | SCC,data=em2.Coal )

