#auslesen aller txt-files in "" inkl. Dateipfade
# setwd("/Volumes/CAXES2018/vertical-sections")
files <- dir("/Volumes/EGRIP PP1-7/EGRIP2018", recursive=TRUE, full.names=TRUE, pattern="\\grains2.txt$")

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
                   bag_only = character(),
                   bag_section= character()
                  )

Results <- data.frame(number = numeric(),
                      grainsize = numeric()
                      )

#Einlesen der files (read.csv ersetzen durch entsprechende Funktion - copy%paste 
#aus der Console nachdem 1x korrekt ueber "Import Dataset" eingelesen)
#Dann wird Dateipfad gesplittet und entsprechender Ordnername kann extrahiert werden
#Ggf. den Ordnernamen nochmal in wichtige Details aufdröseln mit strsplit
#Ordnernamen (oder entsprechend Details aus dem Namen) als Spalte Datensatz anhaengen,
#Datensatz mit rbind an bereits eingelesene Datensaetze anhaengen...
for (i in 1:length(files)){
  data <- read.delim(files[i], header=FALSE, comment.char="#")
  bag_no <- strsplit(files[i], "/")
  bag_name <-bag_no[[1]][5]
  bag_only <- stri_sub(bag_name,-8,-6)
  bag_section <-stri_sub(bag_name,-8,-4)
  data$bag <- bag_no[[1]][5]
  data$bag_only <- bag_only
  data$bag_section <- bag_section
  data$bag_section <- bag_section
  # write.table(data, file=paste(bag_name,"_.txt", sep="\t", row.names=F))   # write output file
  Data <- rbind(Data, data)
  
  grainsize_bag <- data[,3]
  
  size_mean <- mean(size)
 Results <- rbind(Results, grainsize_bag)
}

grainsize_data <-aggregate(Data[, 1:2], list(bag_number=Data$bag), mean)  # aggregate mean size
large <- filter(grains2, size > size_mean)  # comparison of grain-size vs mean value
small <- filter(grains2, size < size_mean)  # comparison of grain-size vs mean value

# for (j in 1:length())
# write.table(Data, "/Users/nicolasstoll/Documents/R/EGRIP2018/data/DATA_processed.txt", sep="\t")   # write output file
plot(large$azimuth,large$colatitude, xlab="azimuth", ylab="colatitude", main= "GS>mean")
plot(small$azimuth,small$colatitude, xlab="azimuth", ylab="colatitude",main= "GS<mean")

