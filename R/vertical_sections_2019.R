# script by N. Stoll to process and plot data derived from Fabric Analyser measurements (eigenvalues, mean grainsize, etc.) 
# updated: 14.03.19

library(readxl); library(dplyr); library(stringi); library(tidyverse); library(ggplot2); library(readODS) # load libaries 

cbbPalette <- c("#000000", "#009E73", "#e79f00", "#9ad0f3", "#0072B2", "#D55E00", "#CC79A7", "#F0E442")   # load colour-blindly colours

#### data. must be loaded first to plot##
# total <- read_excel("/Users/nicolasstoll/Desktop/EGRIP/data_2019/total_EGRIP_2019.xls")        # import main data file. change the file path/name of file to the used one. 
total_vertical <- read_excel("~/Desktop/EGRIP /data_2019/EGRIP2019_data_raw2.xls")     # read_excel was used to load in an .xls file, a different import method has to be used for a different file format
total_vertical <- read_excel("~/Desktop/Msc_Arbeit/_Results/_statistics_total/total_EGRIP.xls")

total_horizontal <- read_excel("/Users/nicolasstoll/Desktop/Msc_Arbeit/_Results/_statistics_total/total_horizontal.xlsx") # import main horizontal data file. change the file path/name of file to the used one.

total_bag <- aggregate(total_vertical[, 3:25], 
                       list(Bag = total_vertical$bag), mean)         # define new data frame, lists mean values for each bag. only works for numeric columns


################# PLOT ###############

###  eigenvalues ###
# plot of section means. vertical measurements are plotted  first and horizontal one can be added later

total_vertical %>%                                                              # activate total_vertical,   %>% = pipe operator and indicates that variables are all from this file 
  #  filter( Center_depth  < 600 ) %>%                                           # activate filter to e.g. specify data ranges
  ggplot( legend = TRUE) +                                                        # activate GGPLOT to start plotting 
  #   theme(legend.title=element_blank()) +                                        # get rid of legend title
  scale_colour_discrete(name="Vertical \nsections") +                           # name for legend = vertical sections
  geom_point(aes(e1, Center_depth), colour = "#D55E00", shape =17) +            # geom_point plots e1-e3 as points, can be changed to different typs of visualisation
  geom_point(aes(e2, Center_depth), colour = "#009E73", shape =15) +          # change colour and shape for different colours and shapes
  geom_point(aes(e3, Center_depth), colour = "#0072B2", shape =16) +
  #geom_polygon(aes(e1, Center_depth), colour ="#D55E00", fill= "olivedrab2") +         # uncomment for polygon plot
  #geom_polygon(aes(e2, Center_depth), colour ="#009E73", fill= "olivedrab2") +
  #geom_polygon(aes(e3, Center_depth), colour ="#0072B2", fill= "olivedrab2") +
  scale_y_reverse(limits = c(2090, 100), breaks=seq(100, 2100, 100) ) +         # define y axis -> y-axis direction is reversed. change numbers for different spacings and ticks
  labs(x = "Eigenvalue",                                                        # name for x- and y-axis
       y = "Depth in m") + 
  # labs(title = "Eigenvalues vs Depth") +                                       # activate for header
  # add horizontal values in black, shapes are the same as for vertical values
  theme(legend.title=element_blank(), legend.position ="right",legend.direction="vertical") +
  geom_point(data = total_horizontal, aes(e1, Center_depth, shape = "horizontal \nsections"), colour = "black", shape = 17) +   
  geom_point(data = total_horizontal, aes(e2, Center_depth), colour = "black", shape = 15) +  
  geom_point(data = total_horizontal, aes(e3, Center_depth), colour = "black", shape = 16)  





##  PLOT
## eigenvalues ploted to age
## y-scale = depth in m
#### age model by Sune O. Rasmussen, only valid to 900m-> interpolated until 1714m


# define events and their age/depth. load in before ploting
brittle_zone <- data.frame(ymin=500, ymax=1100, xmin=-Inf, xmax=Inf)         # define brittle zone
LGP <- data.frame(ymin = 1360, ymax = Inf, xmin= -Inf, xmax = Inf)            # define LGM
Hol_Opt_1 <- data.frame(ymin=708, ymax=936.8, xmin=-Inf, xmax=Inf)              # define Holocene Climate Opimum 1
Hol_Opt_2 <- data.frame(ymin=456.5, ymax=593.5, xmin=-Inf, xmax=Inf)            # define Holocene Climate Opimum 1
Roman_warm_period <- data.frame(ymin=279.2, ymax=204.81, xmin=-Inf, xmax=Inf)   # define roman warm period
IronAge_Cold <- data.frame(ymin=285, ymax=353.3, xmin=-Inf, xmax=Inf)           # define iron age cold
BronzeAge_Cold <- data.frame(ymin=422, ymax=456.5, xmin=-Inf, xmax=Inf)         # bronze age cold

########### plot #####

total_vertical %>%
  # filter( Center_depth > 600 & Center_depth < 900) %>%
  ggplot() +
  theme(legend.title=element_blank()) +           # get rid of legend completely
  
  geom_rect(data=Roman_warm_period, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for LGM. change colour
            colour="grey20", fill="grey20",
            alpha=0.2,
            inherit.aes = FALSE) +
  annotate("text", x = 0.077, y = 150, label = "Roman Warm \nPeriod", colour = "black", size = 3.5)  +
  
  # geom_rect(data=brittle_zone, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for brittle zone
  #           color="salmon2",
  #           alpha=0.1,
  #           inherit.aes = FALSE) +
  # annotate("text", x = 0.15, y = 1060, label = "Brittle Zone", colour = "salmon2", size = 3.5,fontface = "bold")  +
  # 
  geom_hline(yintercept = 697, linetype="dashed", color = "red") +                    #  display 5.9k event
  annotate("text", x = 0.15, y = 670, label = "5.9k event", colour = "firebrick2", size = 3.5)  +
  
  geom_hline(yintercept = 960, linetype="dashed", color = "red") +                    #  display 8.2k event
  annotate("text", x = 0.15, y = 985, label = "8.2k event", colour = "firebrick2", size = 3.5)  +
  
  labs(x = "Eigenvalue",
       y = "Depth in m"
  ) +
  
  geom_rect(data=Hol_Opt_1, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for Holocen Optimum 1
            color="grey20", fill="grey20",
            alpha=0.2,
            inherit.aes = FALSE) +
  
  geom_rect(data=Hol_Opt_2, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for Holocen Optimum 2
            color="grey20", fill="grey20",
            alpha=0.2,
            inherit.aes = FALSE) +
  annotate("text", x = 0.165, y = 522, label = "Holocene Climate \nOptimum ", colour = "black", size = 3.5) +
  annotate("text", x = 0.165, y = 820, label = "Holocene Climate \nOptimum ", colour = "black", size = 3.5)  +
  
  geom_rect(data=LGP, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for LGM
            color="grey20", fill="grey20",
            alpha=0.2,
            inherit.aes = FALSE) +
  
  annotate("text", x = 0.15, y = 1400, label = "Last Glacial", colour = "black", size = 3.5, fontface = "bold")  +  # text for LGM
  
  # theme(legend.title=element_blank(), legend.position ="bottom",legend.direction="horizontal") +
  geom_point(aes(e1, Center_depth), colour = "#D55E00", shape =17) +   # add horizontal values
  geom_point(aes(e2, Center_depth), colour = "#009E73", shape =15) +
  geom_point(aes(e3, Center_depth), colour = "#0072B2", shape =16) +
  scale_y_reverse(limits = c(1715, 110), breaks=seq(0, 1715, 100) ) +
  theme_gray() +
  
  # add horizontal values
  geom_point(data = total_horizontal, aes(e1, Center_depth, shape = "horizontal \nsections"), colour = "black", shape = 17) +   # add horizontal values
  geom_point(data = total_horizontal, aes(e2, Center_depth), colour = "black", shape = 15) +   # add horizontal values
  geom_point(data = total_horizontal, aes(e3, Center_depth), colour = "black", shape = 16)  




##  PLOT
## eigenvalues ploted to age
## y-scale = age b2k
#### age model by Sune O. Rasmussen, only valid to 900m-> interpolated until 1714m

# define events. activate before plotting 
brittle_zone <- data.frame(ymin=4400, ymax=9500, xmin=-Inf, xmax=Inf)         # define brittle zone
LGP <- data.frame(ymin = 11700, ymax = Inf, xmin= -Inf, xmax = Inf)           # define LGM
Hol_Opt_1 <- data.frame(ymin=6000, ymax=8000, xmin=-Inf, xmax=Inf)            # define Holocene Climate Opimum 1
Hol_Opt_2 <- data.frame(ymin=3800, ymax=5000, xmin=-Inf, xmax=Inf)            # define Holocene Climate Opimum 1
Roman_warm_period <- data.frame(ymin=2250, ymax=1600, xmin=-Inf, xmax=Inf)    # define roman warm period
IronAge_Cold <- data.frame(ymin=2300, ymax=2900, xmin=-Inf, xmax=Inf)         # define iron age cold
BronzeAge_Cold <- data.frame(ymin=3500, ymax=3800, xmin=-Inf, xmax=Inf)       # bronze age cold
Boreal <- data.frame(ymin=6900, ymax=8500, xmin=-Inf, xmax=Inf)               # boreal

# plot

total_vertical %>%
  # filter( Center_depth > 600 & Center_depth < 900) %>%
  ggplot() +
  theme(legend.title=element_blank()) +   # get rid of legend completely
  geom_rect(data=LGP, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for LGM
            color="grey20",
            alpha=0.2,
            inherit.aes = FALSE) +
  
  annotate("text", x = 0.15, y = 13500, label = "Last Glacial", colour = "black", size = 3.5)  +
  
  geom_rect(data=Roman_warm_period, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for LGM
            color="grey20",
            alpha=0.2,
            inherit.aes = FALSE) +
  annotate("text", x = 0.065, y = 1190, label = "Roman Warm \nPeriod", colour = "black", size = 3.5)  +
  
  
  # geom_rect(data=IronAge_Cold, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for Iron Age cold
  #            color="grey20",
  #            alpha=0.2,
  #            inherit.aes = FALSE) +
  #  annotate("text", x = 0.15, y = 2400, label = "Iron Age \nCold Epoch", colour = "black", size = 3.5)  +
  #  
  
  # geom_rect(data=BronzeAge_Cold, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for Bronze Age Cold
  # color="grey20",
# alpha=0.2,
# inherit.aes = FALSE) +
#  annotate("text", x = 0.7, y = 3500, label = "Bronze Age \nCold Period", colour = "black", size = 3.5)  +


geom_hline(yintercept = 5950, linetype="dashed", color = "red") +                 # cold 5.9
  annotate("text", x = 0.15, y = 5700, label = "5.9k event", colour = "firebrick2", size = 3.5)  +
  
  geom_hline(yintercept = 8200, linetype="dashed", color = "red") +                 # cold 8.2
  annotate("text", x = 0.15, y = 8380, label = "8.2k event", colour = "firebrick2", size = 3.5)  +
  
  labs(x = "Eigenvalue",
       y = "Age b2k") +
  # labs(title = "Eigenvalues vs Age")  +
  
  # holocene optima
  geom_rect(data=Hol_Opt_1, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for Holocen Optimum 1
            color="grey20",
            alpha=0.2,
            inherit.aes = FALSE) +
  
  geom_rect(data=Hol_Opt_2, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for Holocen Optimum 2
            color="grey20",
            alpha=0.2,
            inherit.aes = FALSE) +
  annotate("text", x = 0.165, y = 4400, label = "Holocene Climate \nOptimum ", colour = "black", size = 3.5)  +
  annotate("text", x = 0.165, y = 7100, label = "Holocene Climate \nOptimum ", colour = "black", size = 3.5) +
  
  geom_point(aes(e1, Age_b2k), colour = "red") +                              # plot egeinvalues as points
  geom_point(aes(e2, Age_b2k), colour = "green") +
  geom_point(aes(e3, Age_b2k), colour = "blue") +
  scale_y_reverse(breaks=seq(0, 15000, 1000)) 




#### plotting of parameters from c-axis data

########### woodcock parameter ################

total_vertical %>%
  filter( woodcock_parameter < 1) %>%     # deactivate to plot all sections including outliers
  #   filter( Center_depth > 250) %>%
  ggplot() +
  scale_y_reverse(breaks=seq(100, 2100, 100) ) +
  # scale_y_continuous(breaks=seq(100,1900,200))  #  scale_x_continous( limits=c("0.0", "10")) +       # activate to edit x- and y-axis
  labs( y = "Depth in m") +
  labs(x = "Woodcock Parameter") +
  theme_gray() +
  geom_point(mapping = aes(woodcock_parameter, Center_depth )) 




######### grain size only ############### 
# a) section means
total_vertical %>%
  # filter ( Center_depth > 1300 & Center_depth < 1500) %>%
  filter( Center_depth != 701.3 ) %>%                  # filter out invalid sample 1276_1, only half of the thin section
  filter( Center_depth != 645.38 ) %>%                  # filter out invalid sample 1174_1, only half of the thin section
  # filter(  Center_depth > 900 & Center_depth < 1400) %>%
  ggplot(aes(mean_grainArea, Center_depth)) +
  theme_grey()+                                       # design theme, change for different backgrounds
  geom_point() +
  scale_y_reverse(breaks=seq(100, 2100, 100), limits=c(2100, 100)) +      # preferences for y-scale, change breaks for y-ticks and limits for start and end of axis
  scale_x_continuous(breaks=seq(0, 14.5, 2.5), limits= c(0, 13)) +              # preferences for x-scale, change breaks for x-ticks and limits for start and end of axis
  labs(x =  ~ "Mean grain area in mm"^2) +
  labs(y = "Depth in m") 
#   labs(title = "Mean Grain-size vs Depth") 

##### raw
total_vertical %>%
  # filter ( Center_depth > 1300 & Center_depth < 1500) %>%
  filter( Center_depth != 701.3 ) %>%                  # filter out invalid sample 1276_1, only half of the thin section
  filter( Center_depth != 645.38 ) %>%                  # filter out invalid sample 1174_1, only half of the thin section
  # filter(  Center_depth > 900 & Center_depth < 1400) %>%
  ggplot(aes(mean_grainSize, Center_depth)) +
  theme_grey()+                                       # design theme, change for different backgrounds
  geom_point() +
  scale_y_reverse(breaks=seq(100, 2100, 100), limits=c(2100, 100)) +      # preferences for y-scale, change breaks for y-ticks and limits for start and end of axis
  # scale_x_continuous(breaks=seq(0, 14.5, 2.5), limits= c(0, 13)) +              # preferences for x-scale, change breaks for x-ticks and limits for start and end of axis
  labs(x =  ~ "Mean grain area in mm"^2) +
  labs(y = "Depth in m") 
#   labs(title = "Mean Grain-size vs Depth") 


# b) plot bag means

total_bag %>%
  # filter( Center_depth > 600 & Center_depth < 900) %>%
  ggplot( legend = TRUE) +
  geom_point(aes(e1, Center_depth), colour = "red", size =1) +
  geom_point(aes(e2, Center_depth), colour = "green", size =1) +
  geom_point(aes(e3, Center_depth), colour = "blue", size =1) +
  geom_path(aes(e1, Center_depth), colour = "red", size =1.5) +
  geom_path(aes(e2, Center_depth), colour = "green", size =1.5) +
  geom_path(aes(e3, Center_depth), colour = "blue", size =1.5) +
  scale_y_reverse(breaks=seq(100, 1855, 100) ) +
  labs(x = "Eigenvalue mean per bag",
       y = "Depth in m"
  ) +
  labs(title = "Eigenvalues vs Depth")



### box plot of grain size

total_vertical %>%
  ggplot() + 
  scale_y_reverse(breaks=seq(100, 1900, 100) ) +
  labs( y = "Depth in m") +
  labs( x = "Mean grain diameter in mm") +  
  theme_linedraw() +
  geom_boxplot(aes(mean_grainArea, Center_depth, group=cut_width(Center_depth, 100)), 
               notch = FALSE, varwidth = TRUE, 
               outlier.colour = "red", outlier.shape = 1 ) 



