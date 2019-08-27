# process and plot general statistics e.g.  mean_grainsize and several other parameters
library(readxl); library(dplyr); library(stringi); library(tidyverse); library(ggplot2); library(readODS)       # load libraries


cbbPalette <- c("#000000", "#009E73", "#e79f00", "#9ad0f3", "#0072B2", "#D55E00", 
                "#CC79A7", "#F0E442")         # colour-blind friendly


# import EGRIP data
total <- read_excel("/Users/nicolasstoll/Desktop/Msc_Arbeit/_Results/_statistics_total/total.xls")

mean_grainSize_mm2 <- data.frame((total$mean_grainSize*400)/1000000)
total <- cbind(total, mean_grainSize_mm2)             # add new column to total-data set
names(total)[names(total)=="X.total.mean_grainSize...400..1e.06"] <- "mean_grainArea_mm2"  # change name of new column -> area in mm^2

total_horizontal <- read_excel("/Users/nicolasstoll/Desktop/Msc_Arbeit/_Results/_statistics_total/total_horizontal.xlsx")

mean_grainSize_mm2_hor <- data.frame(((total_horizontal$mean_grainSize*400)/1000000))
total_horizontal <- cbind(total_horizontal, mean_grainSize_mm2_hor)             # add new column to total-data set
names(total_horizontal)[names(total_horizontal)=="X..total_horizontal.mean_grainSize...400..1e.06."] <- "mean_grainArea_mm2" 
# import NEEM data

#EGRIP_2019 
total_vertical <- read_excel("~/Desktop/EGRIP /data_2019/EGRIP2019_data_raw2.xls") 
NEEM <- read.delim("~/Desktop/Msc_Arbeit/Disucssion/data_EGRIPcomparison/NEEM-eigenvalues++.txt")

# import GRIP data

GRIP<- read.delim("~/Desktop/Msc_Arbeit/Disucssion/data_EGRIPcomparison/GRIP-eigenvlues-gepicktAusPub.txt")
# import EDML data

EDML <- read.delim("~/Desktop/Msc_Arbeit/Disucssion/data_EGRIPcomparison/EDML-eigenvalues.txt")


###### plot ########

  
ggplot() +
  
  # EGRIP vertical + horizontal
  geom_point(aes(total_vertical$e1, total_vertical$Center_depth), colour = "#000000", shape =17, size= 1.5) +
  geom_point(aes(total_vertical$e2, total_vertical$Center_depth), colour = "#000000", shape =15, size= 1.5) +
  geom_point(aes(total_vertical$e3, total_vertical$Center_depth), colour = "#000000", shape =16, size= 1.5) +
  geom_point(data = total_horizontal, aes(e1, Center_depth), colour = "#000000", shape =17, size= 1.5) +
  geom_point(data = total_horizontal, aes(e2, Center_depth), colour = "#000000", shape =15, size= 1.5) +
  geom_point(data = total_horizontal, aes(e3, Center_depth), colour = "#000000", shape =16, size= 1.5) +
  
 # NEEM
  geom_point(aes(NEEM$X.NM.EVA1., NEEM$X.NM.Depth_ice_snow__m_.), colour = "#9ad0f3", shape =17, size= 1.5) +
  geom_point(aes(NEEM$X.NM.EVA2., NEEM$X.NM.Depth_ice_snow__m_.), colour = "#9ad0f3", shape =15, size= 1.5) +
  geom_point(aes(NEEM$X.NM.EVA3., NEEM$X.NM.Depth_ice_snow__m_.), colour = "#9ad0f3", shape =16, size= 1.5) +
  
  #EDML
  geom_point(aes(EDML$X.EDML.e1_ver., EDML$X.EDML.depth_m_ver.), colour = "#D55E00", shape =17, size= 1.5) +
  geom_point(aes(EDML$X.EDML.e2_ver., EDML$X.EDML.depth_m_ver.), colour = "#D55E00", shape =15, size= 1.5) +
  geom_point(aes(EDML$X.EDML.e3_ver., EDML$X.EDML.depth_m_ver.), colour = "#D55E00", shape =16, size= 1.5) +
  
  # EDML horizontal
  geom_point(aes(EDML$X.EDML.e1_hor., EDML$X.EDML.depth_m_hor.), colour = "#D55E00", shape =17, size= 1.5) +
  geom_point(aes(EDML$X.EDML.e1_hor., EDML$X.EDML.depth_m_hor.), colour = "#D55E00", shape =15, size= 1.5) +
  geom_point(aes(EDML$X.EDML.e1_hor., EDML$X.EDML.depth_m_hor.), colour = "#D55E00", shape =16, size= 1.5) +
  
  # GRIP
  geom_point(aes(GRIP$X.GRIP.e1., GRIP$X.depth.e1.GRIP.), colour = "#009E73", shape =17, size= 1.5) +
  geom_point(aes(GRIP$X.GRIP.e2., GRIP$X.depth.e2.GRIP.), colour = "#009E73", shape =15, size= 1.5) +
  geom_point(aes(GRIP$X.GRIP.e3., GRIP$X.depth.e3.GRIP.), colour = "#009E73", shape =16, size= 1.5) +
  
  # define axes and look of plot
  scale_y_reverse(limits = c(2150, 100), breaks=seq(0, 2150, 100) ) +      # 
  scale_x_continuous(limits =c(0, 1)) +
  labs(x = "Eigenvalue",
       y = "Depth in m") +
  theme_grey() 
