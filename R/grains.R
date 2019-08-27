# read ins grains.txt and do statistics

#auslesen aller txt-files in "" inkl. Dateipfade
setwd("/Users/nicolasstoll/Documents/R/EGRIP2018/data/cAxes_files/grains2")
files_grains <- dir("/Users/nicolasstoll/Documents/R/EGRIP2018/data/cAxes_files/grains2", recursive=TRUE, full.names=TRUE, pattern="\\grains2.txt$")


GRAINS <- data.frame(grain_number = numeric(),
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
GRAINS_x <- data.frame(grain_number = numeric(),
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
for (i in 1:length(files_grains)){
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
  Data <- rbind(Data, data)   #Datensatz mit rbind an bereits eingelesene Datensaetze anhaengen
}