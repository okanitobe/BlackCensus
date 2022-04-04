library(readr)

#import data
# data.census.gov
census2010 <- read_csv("data/census2010.csv")
census2011 <- read_csv("data/census2011.csv")
census2012 <- read_csv("data/census2012.csv")
census2013 <- read_csv("data/census2013.csv")
census2014 <- read_csv("data/census2014.csv")
census2015 <- read_csv("data/census2015.csv")
census2016 <- read_csv("data/census2016.csv")
census2017 <- read_csv("data/census2017.csv")
census2018 <- read_csv("data/census2018.csv")
census2019 <- read_csv("data/census2019.csv")
census2020 <- read_csv("data/census2020.csv")

#import regions dataset (created manually in Excel, using Regions as defined by US Census Bureau)
regions <- read_csv("data/regions.csv")

#create states vector using census2020
states <- c(colnames(census2020)[-1])

#clean up census2020
census2020 <- census2020[c(1,4) , ] #we only need Total and Black Population
census2020 <- data.frame(t(census2020))[-1 , ] # t() to transpose the table

#create data frames for for-loop
blackpop = as.data.frame(states)
census = data.frame()

#----------------test the for-loop - trial and error purposes-------------------
data <- get(paste("census",2010,sep = "")) 
data <- data[ , which(regexpr("Error", colnames(data))<0) ]
data <- data[ c(1,3) , ]
data <- data.frame(t(data))
data <- data[-1,]
data$X1 <- as.numeric(data$X1)
data$X2 <- as.numeric(data$X2)
data$Year <- 2010
blackpop = cbind(blackpop, data[ , 1:3])
census = rbind(census, blackpop)
remove(data)
blackpop = as.data.frame(states) #reset blackpop
#-------------------------------------------------------------------------------


#for-loop
for (year in seq(from = 2010, to = 2019, by=1)) {
  
  data <- get(paste("census",year,sep = "")) 
  data <- data[ , which(regexpr("Error", colnames(data))<0) ]
  data <- data[ c(1,3) , ]
  data <- data.frame(t(data))
  data <- data[-1,]
  data$X1 <- as.numeric(data$X1)
  data$X2 <- as.numeric(data$X2)
  data$Year <- year
  blackpop <- as.data.frame(states)
  blackpop <- cbind(blackpop, data[ , 1:3])
  census <- rbind(census, blackpop)

}

#change row names
row.names(census) <- c(1:nrow(census))

#add rows for 2020 from census2020
temp <- cbind(as.data.frame(states), census2020)
row.names(temp) <- c(1:nrow(temp))
temp$Year <- 2020
census <- rbind(census, temp)
rm(temp, data, blackpop)

colnames(census) <- c("States", "Total_Population", "Black_Population", "Year")

#Join population and region tables
census <- merge(x=census, y=regions, by="States", all.x = TRUE)

min(census$Total_Population)

library(writexl)
write_xlsx(census, "/Users/bryanokani/Documents/Data Science Projects/Black People/output/census.xlsx")

