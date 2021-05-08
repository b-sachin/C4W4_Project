if(!file.exists("./data")){dir.create("./data")}
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile = "./data/exdata_data_NEI_data.zip",method = "curl")

# list zip archive
file_names <- unzip("./data/exdata_data_NEI_data.zip", list=TRUE)

# extract files from zip file
unzip("./data/exdata_data_NEI_data.zip",exdir="./data", overwrite=TRUE)

# use when zip file has only one file
Source_Classification_Code.rds <- file.path("./data", file_names$Name[1])
summarySCC_PM25.rds <- file.path("./data", file_names$Name[2])

#----------#----------#----------#----------#----------

# Read data 
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# Exploring data
head(NEI)
head(SCC)

dim(NEI)

# Extracting only required data

rd <- subset(NEI, fips == "24510", c("Emissions","type","year"))
head(rd)

# Calculating total emission of pm2.5 for each year and type
rdbl <- aggregate(Emissions ~ year + type, rd, sum)
head(rdbl)


# Set new Graphic Device as PNG
png(filename="plot3.png", width=480, height=480)

# Plotting data 
library(ggplot2)

g <- ggplot(rdbl, aes(year, Emissions, col = type))

g + geom_line() + geom_point(size = 3) + labs(x="Years", y="Total PM2.5 Emission (in Tons)") + 
  labs(title=expression("Total PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Type"))

# Close Device
dev.off()