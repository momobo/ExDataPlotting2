
# EDA Project 2 (third week)

# ------------------------------------------------------------------------------
# preparation

wd="C:\\Users\\mmorelli\\Google Drive\\Data Science\\04 - Exploratory Data Analysis\\Project 02"
setwd(wd)
getwd()
#dir()
SCC  <- readRDS("Source_Classification_Code.rds")
NEI  <- readRDS("summarySCC_PM25.rds")

#
str(SCC)
#str(NEI)
#object.size(NEI)
# so big
#head(SCC)
#head(NEI)

# ------------------------------------------------------------------------------
# 1.Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission 
# from all sources for each of the years 1999, 2002, 2005, and 2008.

# better work with sampling, to accelerate developement
# try all with sampled data, then with full data
# NEIs <- NEI[sample(nrow(NEI), 100000), ]

options(scipen=999)   
library(plyr)
em <- ddply(NEI, .(year), summarise, TotalEmissions = sum(Emissions))
barplot(em$TotalEmissions, names.arg=em$year, ylab="Total PM2.5 emissions (Tons)")

# ------------------------------------------------------------------------------
# 2.Have total emissions from PM2.5 decreased in the Baltimore City, 
# Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system 
# to make a plot answering this question.
NEI.Balt <- NEI[NEI$fips=="24510",]
em.Balt <- ddply(NEI.Balt, .(year), summarise, TotalEmissions = sum(Emissions))
#boxplot(Emissions ~ year,NEI.Balt)
barplot(em.Balt$TotalEmissions, names.arg=em$year, ylab="Total PM2.5 emissions in Baltimore (Tons)")

#unique(SCC$Short.Name)



# ------------------------------------------------------------------------------
# 3.Of the four types of sources indicated by the type (point, nonpoint, 
# onroad, nonroad) variable, which of these four sources have seen decreases 
# in emissions from 1999-2008 for Baltimore City? Which have seen increases 
# in emissions from 1999-2008? 
# Use the ggplot2 plotting system to make a plot answer this question. 
library(ggplot2)
em2.Balt <- ddply(NEI.Balt, .(year, type), summarise, TotalEmissions = sum(Emissions))
#str(em2.Balt)
qplot(year, TotalEmissions, facets=.~type, geom=c("line"), data=em2.Balt,
      main= "Total PM2.5 emissions in Baltimore by type", ylab="Total Emissions (Tons)")+theme_bw()

# ------------------------------------------------------------------------------
# 4.Across the United States, how have emissions from coal combustion-related 
# sources changed from 1999-2008?


# id the coal combustion relate source:
SCC.Coal <- SCC[grep("[Cc]omb.*[cC]oal", SCC$Short.Name), ]
# join (after the id, the reverse would be extremely inefficient)
NEI.Coal <- merge(NEI,SCC.Coal)

em.Coal <- ddply(NEI.Coal, .(year), summarise, TotalEmissions = sum(Emissions))
qplot(year, TotalEmissions, geom=c("line"), data=em.Coal, 
      main= "Total PM2.5 emissions related to Coal combustion in USA", ylab="Total Emissions (Tons)")+theme_bw()

# other possibility, but it is not pretty
library(lattice)
em2.Coal <- ddply(NEI.Coal, .(year, SCC), summarise, TotalEmissions = sum(Emissions))
xyplot(TotalEmissions ~ year | SCC,data=em2.Coal )

# ------------------------------------------------------------------------------
# 5 How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City? 
# 
SCC.MV <- SCC[grep("^Mobile", SCC$EI.Sector), ]
NEI.Balt <- NEI[NEI$fips=="24510",]
NEI.MV.Balt <- merge(NEI.Balt,SCC.MV)
em.MV.Balt <- ddply(NEI.MV.Balt, .(year), summarise, TotalEmissions = sum(Emissions))

qplot(year, TotalEmissions, geom=c("line"), data=em.MV.Balt, 
      main= "Total PM2.5 emissions related to Motor Vehicle sources in Baltimore", ylab="Total Emissions (Tons)")+theme_bw()


# ------------------------------------------------------------------------------
# 6 Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

SCC.MV <- SCC[grep("^Mobile", SCC$EI.Sector), ]
NEI.Balt.LA <- NEI[NEI$fips=="24510" | NEI$fips=="06037",]
NEI.MV.Balt.LA <- merge(NEI.Balt.LA,SCC.MV)

em.MV.Balt.LA <- ddply(NEI.MV.Balt.LA, .(year, fips), summarise, TotalEmissions = sum(Emissions))
str(em.MV.Balt.LA$fips)

# beautify the names
em.MV.Balt.LA$City <- ""
em.MV.Balt.LA[em.MV.Balt.LA$fips=="24510",]$City <- "Baltimore"
em.MV.Balt.LA[em.MV.Balt.LA$fips=="06037",]$City <- "Los Angeles"

qplot(year, TotalEmissions, facets=.~City, geom=c("line"), data=em.MV.Balt.LA,
      main= "Total PM2.5 emissions in Baltimore and LA", ylab="Total Emissions (Tons)")+theme_bw()


# ------------------------------------------------------------------------------

source("./plot1.R", chdir=TRUE)
source("./plot2.R", chdir=TRUE)
source("./plot3.R", chdir=TRUE)
source("./plot4.R", chdir=TRUE)
source("./plot5.R", chdir=TRUE)
source("./plot6.R", chdir=TRUE)


?barplot
names(NEI)
names(SCC)
?qplot

intersect(names(NEI), names(SCC))

str(NEI)
?sample
?hist
?plot
library(data.table)
# NEI.DT <- data.table(NEIs)
#s <- split(NEI$Emissions, NEI$year)
#em <- lapply(s,sum)
#str(em)
