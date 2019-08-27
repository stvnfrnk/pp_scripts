library(readxl) ; library(dplyr); library(stringi); library(tidyverse); library(ggplot2); library(plyr);
library(easyGgplot2) ; library(viridis)  ; library(Hmisc)                                                                   # activate libraries

perimeter <- read_excel("/Users/nicolasstoll/Desktop/Msc_Arbeit/_Results/Perimeter_Analysis/Perimeter_Analysis.xlsx")       # load in parameter data, change path to location of data sheet
  
## aggregate for mean and stdv
## caluclates mean and standard deviations for each bag or each section
perimeter_bag <- aggregate(perimeter[, 3:11], 
                              list(Bag = perimeter$bag), mean)    
perimeter_bag_sd <- aggregate(perimeter[, 3:11], 
                           list(Bag = perimeter$bag), sd)
perimeter_bag_sd$Center_depth <- perimeter_bag$Center_depth   # replace wrong depth with right one

perimeter_section <- aggregate(perimeter[, 3:11],
                               list(Section = perimeter$section,
                                    Bag = perimeter$bag), mean)
perimeter_section_sd <- aggregate(perimeter[, 3:11], 
                              list(Section = perimeter$section,
                                Bag = perimeter$bag), sd)
perimeter_section_sd$Center_depth <- perimeter_section$Center_depth  # replace wrong depth with right one

  
##### calculate means etc ###
# max and min for sections
Results <- max(perimeter_section$Perimeter_Ratio, na.rm = TRUE)
min(perimeter_section$Perimeter_Ratio, na.rm = TRUE)
max(perimeter_section$Radii_mean, na.rm = TRUE)
min(perimeter_section$Radii_mean, na.rm = TRUE)
max(perimeter_section$Roundness, na.rm = TRUE)s
min(perimeter_section$Roundness, na.rm = TRUE)
max(perimeter_section$Aspect_Ratio, na.rm = TRUE)
min(perimeter_section$Aspect_Ratio, na.rm = TRUE)

write.table(Results, "/Users/nicolasstoll/Documents/R/EGRIP2018/Results/Perimeter_Results.txt", sep="\t") # write output file


######### plot###

## perimeter total. plots every single value -> better to use means (further down)
## takes a long time to load and is normally to miuch data to show anything
perimeter %>%                         # pipe for data "perimeter"
   # filter(Roundness < 12) %>%       # filter out outliers for better visibility 
  # filter(Center_depth < 200) %>%
  ggplot(aes(Perimeter_Ratio, Center_depth)) +       # start ggplot with ggplot(), define variables to plot (etc. Perimeter_Ratio, Roundness,). + to add another layer
  stat_density_2d(aes(fill = stat(level)), geom = "polygon") +      # caluclate density
    geom_point() +                                  # add another layer geom_point = data points. data still defines in ggplot(x,y)
  scale_y_reverse( ) +            # reverse y-axis
  labs( y = "Depth in m") +       # naming of axis
  labs( x = "Perimeter Ratio") +  # naming of axis
  theme_linedraw() +              # define theme
  theme(legend.title=element_blank())      # no legend title
  

  stat_density_2d(aes(fill = stat(level)), geom = "polygon") +
 # scale_fill_distiller(palette = 'RdYlBu')  # red-yellow-blue filling contours
  # scale_fill_viridis()

## calculate different parameters, means of sections and bags
# 1) Roundness
# a) mean over entire bags
  
perimeter_bag %>%                 # use calculated bag means
  filter(Bag < 1314 | Bag >1316) %>%  # filter out bag 1314, which is characterised by a large outlier
   ggplot(aes(Roundness, Center_depth)) +
  geom_errorbarh(data = perimeter_bag_sd, aes( xmin = Roundness, xmax = Roundness)) +   # add error bar
  scale_y_reverse(breaks=seq(100,1900,100) ) +
  labs( y = "Depth in m") +
  theme_linedraw() +
  theme(legend.title=element_blank()) +
    geom_point(aes(alpha = Radii_mean)) 
  # geom_smooth(aes(Roundness, Center_depth))

# b) mean over sections of each bag
  
perimeter_section %>%
 filter(Roundness < 10) %>%         # filter out outliers with roundness < 10
  # filter(Center_depth > 0 & Center_depth < 500) %>%
  ggplot(aes(Roundness, Center_depth)) +
  scale_y_reverse(breaks=seq(100, 1750, 100) ) +
  labs( y = "Depth in m") +
  theme_linedraw() +
  theme(legend.title=element_blank()) +
  geom_point() 


## 2) Perimeter Ratio

# a) mean over entire bags
perimeter_bag %>%
 # filter(Center_depth > 1000) %>% 
  ggplot(aes(Perimeter_Ratio, Center_depth)) +
  scale_y_reverse(breaks=seq(100,1750,100) ) +
  labs( y = "Depth in m") +
  labs( x = "Perimeter Ratio") +  
  theme_linedraw() +
  theme(legend.title=element_blank()) +
  geom_point(aes(alpha = Radii_mean)) +
  geom_path()


# b) mean over sections of each section = individual dephts
perimeter_section %>%
  #filter(Center_depth > 400 & Center_depth < 930)  %>%
  #filter(Bag < 1314 | Bag >1316) %>% 
  # filter (Center_depth > 1000) %>% 
  ggplot(aes(Perimeter_Ratio, Center_depth)) +
  scale_y_reverse(breaks=seq(100, 1750, 100) ) +
  labs( y = "Depth in m") +
  labs( x = " Perimeter Ratio") +
  theme_linedraw() +
  theme(legend.title=element_blank()) +
  geom_point(aes()) 

# c) boxplots
perimeter %>%
  ggplot((aes(Roundness, Center_depth))) + 
  scale_y_reverse(breaks=seq(100,1900,100) ) +
  labs( y = "Depth in m") +
  labs( x = "Perimeter Ratio") +  
  theme_linedraw() +
  geom_boxplot(aes(group=cut_width(Center_depth, 400)), notch = TRUE, varwidth = FALSE, 
               outlier.colour = "red", outlier.shape = 1 ) 

  

# 3)  Radii
# a) mean over entire bags
perimeter_bag %>%
 # filter(Center_depth < 800) %>% 
  ggplot(aes(Radii_mean, Center_depth)) +
  scale_y_reverse(breaks=seq(250, 1500, 100) ) +
  labs( y = "Depth in m") +
  labs( x = " Mean Radii") +
  theme_linedraw() +
  theme(legend.title=element_blank()) +
  geom_point() 
# geom_smooth(aes(Roundness, Center_depth))

# b) mean over sections of each bag = individual dephts
perimeter_section %>%
   filter(Center_depth > 1000) %>% 
  ggplot(aes(Radii_mean, Center_depth)) +
  scale_y_reverse(breaks=seq(100,1800,100) ) +
  labs( y = "Depth in m") +
  labs( x = " Mean Radii") +
  theme_linedraw() +
  theme(legend.title=element_blank()) +
  geom_point()

# 4) Aspect Ratio
# a) mean over entire bags
perimeter_bag %>%
  # filter(Center_depth > 600) %>% 
  ggplot(aes(Aspect_Ratio, Center_depth)) +
  scale_y_reverse(breaks=seq(100, 1900, 100) ) +
  labs( y = "Depth in m") +
  labs( x = "Aspect Ratio") +  
  theme_linedraw() +
  theme(legend.title=element_blank()) +
  geom_point(aes(alpha = Radii_mean))  # aes(alpha =) plots another perimeter)
# geom_smooth(aes(Roundness, Center_depth))


# b) mean over sections of each section = individual dephts
perimeter_section %>%
 # filter(Bag < 1314 | Bag >1316) %>% 
  filter (Center_depth > 1000 & Center_depth < 1400) %>% 
  ggplot(aes(Aspect_Ratio, Center_depth)) +
  scale_y_reverse(breaks=seq(100,1900,50) ) +
  labs( y = "Depth in m") +
  labs( x = " Aspect Ratio") +
  theme_linedraw() +
  theme(legend.title=element_blank()) +
  geom_point(aes( alpha= Radii_mean)) 


## 5) plot multiple graphs
# define p1, p2, p3 and p4 -> used to plot in multiplot
# Roundness
p1 <-perimeter_section %>%
  filter(Bag < 1314 | Bag >1316) %>%  
  ggplot(aes(Roundness, Center_depth)) +
  scale_y_reverse(breaks=seq(100,1900,200) ) +
  labs( y = "Depth in m") +
  theme_linedraw() +
  theme(legend.title=element_blank()) +
  geom_point() 
#  ggtitle("bag 2626-2696")

  # perimeter Ratio
  p2 <-perimeter_section %>%
     filter(Bag < 1314 | Bag >1316) %>% 
    ggplot(aes(Perimeter_Ratio, Center_depth)) +
    scale_y_reverse(breaks=seq(100,1900,200) ) +
    labs( x = " Perimeter Ratio") +
    labs( y = "Depth in m") +
    theme_linedraw() +
    theme(legend.title=element_blank()) +
    geom_point() 
   # ggtitle("Perimeter Ratio")
  
  # Radii
  p3 <- perimeter_section %>%
    filter(Bag < 1314 | Bag >1316) %>% 
    ggplot(aes(Radii_mean, Center_depth)) +
    scale_y_reverse(breaks=seq(100,1900,200) ) +
    labs( x = " Mean Radii") +
    labs( y = "Depth in m") +
    theme_linedraw() +
    theme(legend.title=element_blank()) +
    geom_point() 
   # ggtitle("Mean Radii")
  
  p4 <- perimeter_section %>%
    #  filter(Bag < 637 & Bag >615) %>% 
    ggplot(aes(Aspect_Ratio, Center_depth)) +
    scale_y_reverse(breaks=seq(100,1900,200) ) +
    labs( x = " Aspect Ratio") +
    labs( y = "Depth in m") +
    theme_linedraw() +
    theme(legend.title=element_blank()) +
    geom_point() 
  # ggtitle("Mean Radii")
  
  ggplot2.multiplot(p1, p2, p3, p4, cols=2)       # use to plot all four perimeters in one figure. cols = number of columns
  #######################
  
  
  ## approach to merge mean + sd in one data frame
  ## 1) section
  sd_section <- perimeter_section_sd$Perimeter_Ratio
  
 ggplot(perimeter_section, aes(x=Center_depth, y=Perimeter_Ratio)) + 
   geom_errorbar(aes(ymin=perimeter_section$Perimeter_Ratio-sd_section, ymax=perimeter_section$Perimeter_Ratio+sd_section), colour= "red",
                 position=position_dodge(0.05)) +
    geom_step() +
    geom_point() +
    
   scale_x_continuous(limits = c(105, 910), breaks = seq(100, 1720, 100)) +
   theme_gray() +
   labs( x = " Depth in m") +
   labs( y = "Perimeter Ratio") 
  
#  2) bag
 sd_bag <- perimeter_bag_sd$Perimeter_Ratio

 ggplot(perimeter_bag, aes(x=Center_depth, y=Perimeter_Ratio)) + 
   geom_errorbar(aes(ymin=perimeter_bag$Perimeter_Ratio-sd_bag, ymax=perimeter_bag$Perimeter_Ratio+sd_bag), colour= "red",
                 width=.2, position=position_dodge(0.05)) +
  # geom_step() +
   geom_point(aes(colour = Roundness)) +
   # scale_y_continuous(limits = c(0, 1)) +
   scale_x_continuous(limits = c(110, 920), breaks = seq(100, 1720, 100)) +
  # scale_y_continuous(limits=c(0.53, 1.02)) +
   theme_gray() +
   labs( x = " Depth in m") +
   labs( y = "Perimeter Ratio") 
  # annotate("text", x = 1350, y = .57, label = "Mean Perimeter Ratio = 0.837 ± 0.152", colour = "black", size = 4) 