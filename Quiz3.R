## Question 1


fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl,destfile = "comm.csv")
commdata <- read.csv("comm.csv")
commdata$agricultureLogical = ifelse(commdata$ACR ==3 & commdata$AGS == 6, TRUE, FALSE)
which(commdata$agricultureLogical == TRUE)

##  125  238  262

## Question 2

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(fileUrl,destfile = "jeff.jpg",mode = "wb",method="auto")  
jeffimg <- readJPEG("jeff.jpg",native=TRUE)
quantile(jeffimg,probs = c(0.3,0.8))

## -15259150 -10575416

## Question 3
## put in format to deal with numbers with commas
setAs("character", "num.with.commas", function(from) as.numeric(gsub(",", "", from) ) )
## download gdp data, reduced list though
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv "
download.file(fileUrl,destfile = "gdp.csv")
gdpdata <- read.csv("gdp.csv", header=F, skip=5, nrows=190, colClasses=c('character','integer','character','character','num.with.commas'))
## download education data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl,destfile = "edu.csv")
edudata <- read.csv("edu.csv")
## download merge on countrycode
mergedData = as.data.frame(merge(gdpdata,edudata,by.y="CountryCode",by.x="V1",all=TRUE))
sortedmerge <- arrange(mergedData,(V5))
head(sortedmerge,n=20)
##189  (for exact match, need all=FALSE), St Kitts


## Question 4

summary(mergedData[mergedData$Income.Group=="High income: OECD",])
summary(mergedData[mergedData$Income.Group=="High income: nonOECD",])
##  32,91


## Question 5
  
library(Hmisc)
mergedData$gdpgroup = cut2(mergedData$V2,g=5)
table(mergedData$gdpgroup,mergedData$Income.Group)

## 5
