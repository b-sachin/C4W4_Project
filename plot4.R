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

sccrd0 <- grep("[Cc][Oo][Aa][Ll]",SCC$Short.Name, value = TRUE)

sccrd1 <- subset(SCC, Short.Name %in% sccrd0, SCC)
head(sccrd1)

rd <- merge(NEI,sccrd1,by="SCC")


# Calculating total emission of pm2.5 for each year and type
rdbl <- aggregate(Emissions ~ year, rd, sum)
head(rdbl)


# Set new Graphic Device as PNG
png(filename="plot4.png", width=480, height=480)

# Plotting data 
library(ggplot2)

g <- ggplot(rdbl, aes(factor(year), Emissions))

g + geom_bar(stat = "identity")+  geom_text(aes(label = round(Emissions,0)), vjust = -0.2, size = 5,
                                            position = position_dodge(0.9)) +labs(x="Years", y="Total PM2.5 Emission (in Tons)") + 
  labs(title=expression("Total PM2.5 Emissions by Coal Combustion, U.S 1999-2008"))

# Close Device
dev.off()