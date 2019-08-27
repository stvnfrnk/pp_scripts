# process and plot general statistics e.g.  mean_grainsize and several other parameters
library(readxl); library(dplyr); library(stringi); library(tidyverse); library(ggplot2); library(readODS)


cbbPalette <- c("#000000", "#009E73", "#e79f00", "#9ad0f3", "#0072B2", "#D55E00", 
                "#CC79A7", "#F0E442")


# import EGRIP data
total <- read_excel("/Users/nicolasstoll/Desktop/Msc_Arbeit/_Results/_statistics_total/total.xls")

mean_grainSize_mm2 <- data.frame((total$mean_grainSize*400)/1000000)
total <- cbind(total, mean_grainSize_mm2)             # add new column to total-data set
names(total)[names(total)=="X.total.mean_grainSize...400..1e.06"] <- "mean_grainArea_mm2"  # change name of new column -> area in mm^2

total_horizontal <- read_excel("/Users/nicolasstoll/Desktop/Msc_Arbeit/_Results/_statistics_total/total_horizontal.xlsx")

mean_grainSize_mm2_hor <- data.frame(((total_horizontal$mean_grainSize*400)/1000000))
total_horizontal <- cbind(total_horizontal, mean_grainSize_mm2_hor)             # add new column to total-data set
names(total_horizontal)[names(total_horizontal)=="X..total_horizontal.mean_grainSize...400..1e.06."] <- "mean_grainArea_mm2" 


#EGRIP_2019 
total_vertical <- read_excel("~/Desktop/EGRIP /data_2019/EGRIP2019_data_raw2.xls") 

# import NEEM data

NEEM <- read.delim("~/Desktop/Msc_Arbeit/Disucssion/data_EGRIPcomparison/NEEM-eigenvalues++.txt")

EDML_GS <- read.delim("~/Desktop/Msc_Arbeit/Disucssion/data_EGRIPcomparison/EDM_grain_size.tab.tsv")
mean_grainarea_mm2 <- data.frame(EDML_GS$Radius..mm.*2*pi)
EDML_GS <- cbind(EDML_GS, mean_grainarea_mm2)             # add new column to total-data set
names(EDML_GS)[names(EDML_GS)=="EDML_GS.Radius..mm....2...pi"] <- "mean_grainArea_mm2"  # change name of new column -> area in mm^2


###### plot ########

ggplot() +
  # EGRIP vertical + horizontal
  geom_point(aes(total_vertical$mean_grainArea, total_vertical$Center_depth), colour = "#000000", shape =17, size= 1.5) +
  geom_point(data = total_horizontal, aes(total_horizontal$mean_grainArea, Center_depth), colour = "#000000", shape =17, size= 1.5) +

  
  # NEEM
  geom_point(aes(NEEM$X.NM.Grain_area__mm__2_., NEEM$X.NM.Depth_ice_snow__m_.), colour = "#9ad0f3", shape = 16, size = 1.5) + 

  #EDML
 # geom_point(aes(EDML_GS$mean_grainArea_mm2, EDML_GS$Depth.ice.snow..m.), colour = "#D55E00", shape = 15, size = 1.5) +

# beauty
scale_y_reverse(limits = c(2550, 0), breaks=seq(100, 2550, 200) ) +
  scale_x_continuous(limits = c(0.5, 50), breaks=seq(0, 50, 5)) +
  labs(x =  ~ "Mean grain area in mm"^2) + 
  labs( y = "Depth in m") +
 # scale_colour_discrete(element_blank()) + # no legend title
  theme_grey()   
