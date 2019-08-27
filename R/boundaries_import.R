# activate needed packages
library(utils); library(stringi); library(stats); library(stringr); library(plyr); library(tidyverse);library(stringi);
 library(plotly); library(graphics); library(ggplot2); library(plyr); library(dplyr); library(ggplot2)


#auslesen aller txt-files in "" inkl. Dateipfade
 setwd("/Volumes/PP 3-2/Nico/vertical_sections_processed")

 # define boundaries for each file. Boundaries is used to add each single file onto each other
 boundaries <- dir("/Volumes/PP 3-2/Nico/vertical_sections_processed", recursive=TRUE, full.names=TRUE, pattern="boundaries.txt")
Boundaries <- read.delim("~/Documents/R/EGRIP2018/data/Boundaries.txt", header=TRUE, row.names=1)

Boundaries <- data.frame(boundary_number = numeric(),
                   grain1 = numeric(),
                   grain2 = numeric(),
                   length = numeric(),
                   misorientation_angle = numeric(),
                   ijdistance_length = numeric(),
                   slope_angle = numeric(),
                   tilt_boundaryangle = numeric(),
                   twist_boundaryangle = numeric(),
                   rotation_vector = numeric() )

Boundaries_2 <- data.frame(boundary_number = numeric(),
                           grain1 = numeric(),
                           grain2 = numeric(),
                           length = numeric(),
                           misorientation_angle = numeric(),
                           ijdistance_length = numeric(),
                           slope_angle = numeric(),
                           tilt_boundaryangle = numeric(),
                           twist_boundaryangle = numeric(),
                           rotation_vector = numeric() )



# loop to load in Boundaries
for (i in 1:length(boundaries)){
              Boundaries_2 <- read.delim(boundaries[i], header=FALSE, comment.char="#")
              bag_no <- strsplit(boundaries[i], "/")
              bag_name <-bag_no[[1]][6]             # Ordnernamen (oder entsprechend Details aus dem Namen) als Spalte Datensatz anhaengen
              amount <- stri_length(bag_name)
              
                       if (amount == 14 ){ 
                         bag_only <- stri_sub(bag_name, -9,-6) 
                         bag_section <-stri_sub(bag_name, -4,-4) 
                         } else { 
                           if  (amount == 13) {
                           bag_only <- stri_sub(bag_name, -8,-6)   
                           bag_section <-stri_sub(bag_name, -4,-4) 
                          } else {
                            if  (amount == 30) {
                            bag_only <- stri_sub(bag_name, -25,-22)
                            bag_section <-stri_sub(bag_name,-4,-4)
                          } else {
                              (amount == 29) 
                            bag_only <- stri_sub(bag_name, -25,-23) 
                          bag_section <-stri_sub(bag_name, -4,-4) 
                          }
                            }
                         }

  Boundaries_2$bag <- bag_no[[1]][6]             
  Boundaries_2$bag_only <- bag_only
  Boundaries_2$bag_section <- bag_section
  Boundaries_2$bag_section <- as.numeric(as.character(Boundaries_2$bag_section))
  Boundaries_2$bag_only <- as.numeric(as.character(Boundaries_2$bag_only))
  name <-paste("sample_",i, sep ="")   # define name for plot
  
  # single file plot
  Boundaries_2 %>%
    ggplot(aes(x=Boundaries_2$V5)) +
   geom_histogram(aes(y=(..count..)/sum(..count..)), binwidth = 5, fill = "steelblue2", colour ="grey28") + 
    scale_y_continuous( limits=c(0, 0.1)) +
    # geom_point(aes(misorientation_angle, Center_depth)) +
    labs( x = "Misorientation angle", y = "realtive frequency") +
    theme_linedraw() +
    theme(legend.title=element_blank()) +
    ggsave(filename = name, device = "jpeg", path = "/Users/nicolasstoll/Documents/R/EGRIP2018/plots/_Boundaries/misorientation/single_files")
  
    }
  # write.table(Boundaries, file=paste(bag_name,"_.txt", sep="\t", row.names=F))   # write output file
  #Boundaries <- rbind(Boundaries, Boundaries_2)   # Datensatz mit rbind an bereits eingelesene Datensaetze anhaengen!!

# correct naming of Boundaries + Boundaries, gets screwed up after loop
names(Boundaries) [1] <- "boundary_number"; names(Boundaries) [2] <-"grain1"; names(Boundaries) [3] <-"grain2"; names(Boundaries) [4] <-"length"; names(Boundaries) [5] <-"misorientation_angle";
names(Boundaries) [6] <-"ijdistance_length"; names(Boundaries) [7] <-"slope_angle"; names(Boundaries) [8] <-"tilt_boundaryangle" ;names(Boundaries) [9] <-"twist_boundaryangle"; names(Boundaries) [10] <-"rotation_vector"

  write.table(Boundaries, "/Users/nicolasstoll/Documents/R/EGRIP2018/data/Boundaries.txt", sep="\t")   # write output file



  