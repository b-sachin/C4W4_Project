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
rd <- data.frame(Emissions=NEI$Emissions,year=as.factor(NEI$year))
str(rd)

head(rd)
tail(rd)

# Calculating total emission of pm2.5 for each year
rdp <- tapply(rd$Emissions,rd$year, sum, na.rm = TRUE)
rdp

# Set new Graphic Device as PNG
png(filename="plot1.png", width=480, height=480)

# Plotting data on barplot
rdpf <- barplot(rdp, main = "Total Emmision of PM2.5 decreased in the U.S. from 1999 to 2008", xlab = "Years", ylab = "Total PM2.5 Emission (in tons)", col = 2:5)
text(rdpf, 0, round(rdp, 0),cex=1,pos=3)
legend("topright", legend = unique(rd$year), col = 2:5, pch = 15)

# Close Device
dev.off()