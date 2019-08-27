# activate needed packages
#.First <- function(){
#  library(utils); library(stringi); library(stats); library(stringr); library(RockFab); library(plyr); library(tidyverse);
#  library(methods); library(plotly); library(grDevices); library(graphics); library(ggplot2); library(plyr); library(dplyr); library(datasets);
#}

#auslesen aller txt-files in "" inkl. Dateipfade
setwd("/Volumes/Samsung_T5/EGRIP2018/vertical_sections_processed")
files <- dir("/Volumes/Samsung_T5/EGRIP2018/vertical_sections_processed", recursive=TRUE, full.names=TRUE, pattern="\\grains2.txt$")

# output <- file.path("Users","nicolasstoll","Documents","R","EGRIP2018","data", paste("bag_", bag_name, ".txt", sep = ""))
#Erstellen von leerem Dataframe fuer eingelesene Daten. Anzahl der Spalten sollte 
#uebereinstimmen mit Spaltenanzahl der eingelesenen Tabellen + ID-Spalten aus strsplit
#Spalten koennen entsprechend umbenannt werden
Data <- data.frame(grain_number = numeric(),
                   size = numeric(),
                   center_x = numeric(),
                   center_y = numeric(),
                   axis_0 = numeric(),
                   axis_1 = numeric(),
                   axis_2 = numeric(),
                   mean_azimuth = numeric(),
                   mean_colatitude = numeric(),
                   regelungsgrad = numeric(),
                   bag_name = character(),
                   bag_only = character(),
                   bag_section = character()
                   
)
data <- data.frame(grain_number = numeric(),
                   size = numeric(),
                   center_x = numeric(),
                   center_y = numeric(),
                   axis_0 = numeric(),
                   axis_1 = numeric(),
                   axis_2 = numeric(),
                   mean_azimuth = numeric(),
                   mean_colatitude = numeric(),
                   regelungsgrad = numeric(),
                   bag_name = character(),
                   bag_only = character(),
                   bag_section = character()
)

# loop to load in data
for (i in 1:5){  #length(files)){
  data <- read.delim(files[i], header=FALSE, comment.char="#")
  bag_no <- strsplit(files[i], "/")
  bag_name <-bag_no[[1]][6]             #Ordnernamen (oder entsprechend Details aus dem Namen) als Spalte Datensatz anhaengen,
  bag_only <- stri_sub(bag_name,-9,-6)    # name NOT for vertical cuts
  bag_section <-stri_sub(bag_name,-4,-4)  # name NOT for vertical cuts
  data$bag <- bag_no[[1]][6]              # name NOT for vertical cuts
  data$bag_only <- bag_only
  data$bag_section <- bag_section
  data$bag_section <- bag_section
  # write.table(data, file=paste(bag_name,"_.txt", sep="\t", row.names=F))   # write output file
  
  names(Data) [1] <- "grain_number"; names(Data) [2] <-"size"; names(Data) [3] <-"center x"; names(Data) [4] <-"center y"; names(Data) [5] <-"axis 0";
  names(Data) [6] <-"axis 1"; names(Data) [7] <-"axis 2"; names(Data) [8] <-"mean azimuth" ;names(Data) [9] <-"mean colatitude"; names(Data) [10] <-"regelungsgrad"
  names(data) [1] <- "grain_number"; names(data) [2] <-"size"; names(data) [3] <-"center x"; names(data) [4] <-"center y"; names(data) [5] <-"axis 0";
  names(data) [6] <-"axis 1"; names(data) [7] <-"axis 2"; names(data) [8] <-"mean azimuth" ;names(data) [9] <-"mean colatitude"; names(data) [10] <-"regelungsgrad"

  # create new file "Results" for needed data
  Results <- Data[c(1,2,8,9,12,13)]  # fill Results with needed data
  names(Results) [1] <- "grain_number" 
  names(Results) [2] <-"grain_size"
  names(Results) [3] <-"azimuth"
  names(Results) [4] <-"colatitude"
  names(Results) [5] <-"bag_number"
  names(Results) [6] <-"bag_section"
  
  ## processing to find smaller/larger grains
  
  
    mutate(mean_size = mean(grain_size))
  #1) put mean values in every row
  Results <- Results %>%
    group_by(bag_number) %>%
  mutate(Results, mean_size = mean(Results$grain_size))  # get mean in every row. so far wrong mean # names [6] <-"mean_size"
 # grainsize_data <-aggregate(Results[, 2], list(bag_number=Results$bag_number), mean)  # aggregate mean size per section
 # write.table(grainsize_data, "/Users/nicolasstoll/Documents/R/EGRIP2018/data/grainsize_processed.txt", sep="\t")   # write output file
  
  large <- filter(Results, grain_size > mean_size)  # all grains larger than the mean, ALL measurements
  small <- filter(Results, grain_size < mean_size)  # all grains smaller than the mean, ALL measurements
  
  ### plot#################################
 # 1) plot larger than mean grains_size
  # plot(large$azimuth,large$colatitude, xlab="azimuth", ylab="colatitude", main= "grain-size > mean")
   # hist(large$grain_size)
 
  layout(matrix(c(1,2), 2, 2, byrow = TRUE))
  qplot(azimuth,colatitude,data=large, color=grain_size) # simple plot with 3rd dimension -> size
  
  qplot(azimuth,colatitude,data=large, color=grain_size, geom=c("point","smooth")) #adding a geom for statistics
  qplot(grain_size, data=large,fill= azimuth)  # histogram
  
  # 2) plot smaller than mean grains_size
  #  plot(small$azimuth,small$colatitude, xlab="azimuth", ylab="colatitude",main= "grain-size < mean")
  #  hist(small$grain_size)
  
  layout(matrix(c(1,2), 2, 2, byrow = TRUE))
  qplot(azimuth,colatitude,data=small, color=grain_size) # simple plot with 3rd dimension -> size
  
  qplot(azimuth,colatitude,data=small, color=grain_size, geom=c("point","smooth")) #adding a geom for statistics
  qplot(grain_size, data=small,fill= azimuth)  # histogram
  
  
  
#  qplot(log(grain_size), data=large, fill=azimuth)  #histogram
 # qplot(log(grain_size), data=small, geom="density")  #histogram

  #qplot(size,colatitude, data=grains3, color= azimuth, geom=c("point","smooth"))
  #qplot(azimuth,colatitude, data=grains3, color= size, geom=c("point","smooth"))
  
  
  rm(Results)
  Data <- rbind(Data, data)   #Datensatz mit rbind an bereits eingelesene Datensaetze anhaengen

}