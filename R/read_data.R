#auslesen aller txt-files in "" inkl. Dateipfade
setwd("/Volumes/CAXES2018/vertical-sections")
files <- dir("/Volumes/CAXES2018/vertical-sections", recursive=TRUE, full.names=TRUE, pattern="\\grains2.txt$")
names(files) [1] <- "grain_number" 
names(files) [2] <-"size"
names(files) [3] <-"center x"
names(files) [4] <-"center y"
names(files) [5] <-"axis 0"
names(files) [6] <-"axis 1"
names(files) [7] <-"axis 2"
names(files) [8] <-"mean azimuth"
names(files) [9] <-"mean colatitude"
names(files) [10] <-"regelungsgrad"
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
                   regelungsgrad = numeric())

#Einlesen der files (read.csv ersetzen durch entsprechende Funktion - copy%paste 
#aus der Console nachdem 1x korrekt ueber "Import Dataset" eingelesen)
#Dann wird Dateipfad gesplittet und entsprechender Ordnername kann extrahiert werden
#Ggf. den Ordnernamen nochmal in wichtige Details aufdröseln mit strsplit
#Ordnernamen (oder entsprechend Details aus dem Namen) als Spalte Datensatz anhaengen,
#Datensatz mit rbind an bereits eingelesene Datensaetze anhaengen...
for (i in 1:20){ #length(files)){
  data <- read.delim(files[i], header=FALSE, comment.char="#")
  bag_no <- strsplit(files[i], "/")
  bag_name <-bag_no[[1]][5]
 # bag_section <- strsplit(files[i], "_")
  data$bag <- bag_no[[1]][5]
  
  # data$bag_section<- bag_no[[1]][5] extract single sections instead of entire bags
  
#  file = output
#  write.table(data, file=paste("bla_"))
  
  write.table(data, file=paste(bag_name,"_.txt", sep="\t", row.names=F))   # write output file
  Data <- rbind(Data, data)
  
}
grainsize <- Data[,3]
b <- factor(data$bag)

# for (j in 1:length())
# write.table(Data, "/Users/nicolasstoll/Documents/R/EGRIP2018/data/DATA_processed.txt", sep="\t")   # write output file
