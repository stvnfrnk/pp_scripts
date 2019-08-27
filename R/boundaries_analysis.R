# activate needed packages
library(utils); library(stringi); library(stats); library(stringr); library(plyr); library(tidyverse);library(stringi);
library(plotly); library(graphics); library(ggplot2); library(plyr); library(dplyr); library(ggplot2); library(plot3D)
# library(Boundariessets); library(grDevices); library(methods);

setwd("/Users/nicolasstoll/Documents/R/EGRIP2018/plots/_Boundaries")
#auslesen aller txt-files in "" inkl. Dateipfade

 Boundaries <- read.delim("~/Desktop/Msc_Arbeit/_Results/Boundaries.txt")
 Boundaries$Center_depth =   ((((Boundaries$bag_only-1)*0.55+(Boundaries$bag_section-1)*(0.55/6))+((Boundaries$bag_only-1)*0.55+(Boundaries$bag_section)*(0.55/6))))/2
 
 Boundaries_bag <- aggregate(Boundaries[, 1:14], 
                                 list( Bag = Boundaries$bag_only), na.action = na.omit, FUN = mean)
 
Boundaries_section <- aggregate(Boundaries[, 1:14], 
                                  list(Section = Boundaries$bag_section,
                                    Bag = Boundaries$bag_only), 
                                   na.action = na.omit, FUN = mean)

######### plot###
## Boundaries total
Boundaries %>%
  filter(Center_depth < 800) %>% 
  ggplot() +
 stat_density_2d(aes(misorientation_angle, Center_depth, fill = stat(level)), geom = "polygon") +
 # geom_point(aes(misorientation_angle, Center_depth)) +
  scale_y_reverse( ) +
  labs( y = "Depth in m") +
  labs( x = "Misorientation angle") +
  theme_linedraw() +
  theme(legend.title=element_blank())

# a) mean of bags
Boundaries_bag %>%
 # filter(misorientation_angle > 33) %>%  
  ggplot() +
  scale_y_reverse(breaks=seq(100,1900,100) ) +
  labs(x = "Misorientation angle", y = "Depth in m") +
  theme_linedraw() +
  theme(legend.title=element_blank()) +
  geom_point(aes(misorientation_angle, Center_depth)) 
# geom_smooth(aes(Roundness, Center_depth))

# b) mean of sections 
Boundaries_section %>%
   # filter(Center_depth !=722.7458) %>%  
  filter (misorientation_angle > 33)  %>%  
  filter(Center_depth < 1000) %>% 
  ggplot() +
  geom_point(aes(misorientation_angle, Center_depth)) +
  scale_y_reverse(breaks=seq(100,1900,50) ) +
  labs(x = "Misorientation angle", y = "Depth in m") +
  theme_linedraw() +
  theme(legend.title=element_blank()) 
  # ggtitle("")
  

## histogram plot
Boundaries %>%
  filter(Center_depth < 800) %>% 
  ggplot() +
geom_histogram(aes(x= misorientation_angle), binwidth = 5)+  
  # geom_point(aes(misorientation_angle, Center_depth)) +
  labs( x = "Misorientation angle", y = "Depth in m") +
  theme_linedraw() +
  theme(legend.title=element_blank())


theme_classic()
g <- ggplot(Boundaries, aes(misorientation_angle)) + scale_fill_brewer(palette ="Spectral")
g+
  geom_histogram(aes())


# 3d histogram
mis_c <- cut(Boundaries$misorientation_angle, 10)
depth_c <- cut(Boundaries$Center_depth, 250)
z <-table(mis_c, depth_c)

hist3D(z=z, border ="black")
image2D(z=z, border ="black")
labs( x = "Misorientation angle", y = "Depth in m")