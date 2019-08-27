# plot ellipsoids for each section -> image files which can be put together to create an animation
library(readxl); library(dplyr); library(stringi); library(tidyverse); library(ggplot2); library(rgl)   # load libraries
setwd("/Users/nicolasstoll/Documents/R/EGRIP2018/plots/ellipsoid/try_2")        # define location

# load in statistic data
total <- read_excel("~/Desktop/Msc_Arbeit/_Results/_statistics_total/total.xls", 
                    col_types = c("numeric", "numeric", "text", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", "numeric", 
                                  "numeric"))
  
# save in the following folder
setwd("/Users/nicolasstoll/Documents/R/EGRIP2018/plots/ellipsoid/try_5")

# loop to plot ellipsoid for each section
for (i in 1:nrow(total) ){       #nrow(total))

     # define eigenvalues
  name <-paste("sample_",i, sep ="")    # name files with counting numbers, going down with depht
  e1 <- total$e1[i]                     # define variables e1, e2 and e3 
  e2 <-  total$e2[i]
  e3 <-  total$e3[i]
  
  # create and save plot  
 #  open3d(windowRect=c(100,100,700,700))     # define size of output window
#  print(( paste("name",formatC(i,digits=1,flag="0"),".eps",sep="") ))
  elipsoid <- plot3d(ellipse3d(diag(3),centre=c(1, 1, 1 ), scale=c(e1, e2, e3), col=c("tomato"), aspect = TRUE,
                               grid = FALSE, surface = FALSE, box = FALSE, axes= FALSE, show.bbox = FALSE))   # plot 3D ellipsoid, scale is defines by eigenvalues
  rgl.bbox(xlen = 0, ylen = 0, zlen = 0, color = c('grey100'))      # define background box
  # text3d(x = e1, y = e2, z = e3, text = brands, adj = c(2.5,2.5), cex = 0.7)
  
  rgl.snapshot(name,fmt = "png")    # name files
 #  rgl.postscript(name, fmt = "pdf", =FALSE)
  }


