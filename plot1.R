########################################################################################################################
## An R script created as part of the Course Project 1 of Exploratory Data Analysis
## The script download the necessary file, extract it, and load the data about the household power consumption.
## It will then draw a histogram on the Global Active Power for two selected dates.
########################################################################################################################

## First try to download the zipped file containing the data and store it as Household_power_consumption.zip if it does not yet exist
if (!file.exists("Household_power_consumption.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "Household_power_consumption.zip")
}

## When necessary, unzip the file that has just been downloaded into a folder called File
if (!file.exists("Files")){
  unzip("Household_power_consumption.zip", exdir="Files")
}

## List the files inside the extract folder
files <- list.files("Files")

## If the folder is empty, re-extract from the zip file
if (length(files) < 1){
  unzip("Household_power_consumption.zip", exdir="Files")
  files <- list.files("Files")
}
fname = paste("./Files/", files[1], sep="")

## Install sqldf package when it is not already insalled
if (!"sqldf" %in% rownames(installed.packages())){
  install.packages("sqldf")
}

## Load the sqldf library
library(sqldf)

## Identify the class of each column. This will accellerate the data frame reading
MyTestDF = read.table(fname, header=TRUE, sep=";", stringsAsFactors=FALSE, nrows = 1, na.strings="?")
MyClass = sapply(MyTestDF, class)

## Read the data into a data table
MyDataFrame = read.table(fname, header=TRUE, sep=";", stringsAsFactors=FALSE, na.strings="?",  colClasses = MyClass)
## Convert the Date column to have a uniform format
MyDataFrame$Date = as.character(as.Date.character(MyDataFrame$Date, format = "%d/%m/%Y"))
## Extract the two specific dates of interest, and order based on date and time
MySelectDF = sqldf("SELECT * FROM MyDataFrame WHERE Date BETWEEN '2007-02-01' AND '2007-02-02' ORDER BY Date, Time")

## Open a graphics device for png file plot1.png
png("plot1.png", width = 480, height = 480)
## Draw the figure, which in this case the histogram of Global Active Power
hist(MySelectDF$Global_active_power, col = "RED", xlab="Global Active Power (kilowatts)", ylab="Frequency", main="Global Active Power")
## Close the graphics device
dev.off()