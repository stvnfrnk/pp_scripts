# process and plot general statistics e.g.  mean_grainsize and several other parameters
library(readxl); library(dplyr); library(stringi); library(tidyverse); library(ggplot2); library(readODS)

 total_horizontal <- read_excel("/Users/nicolasstoll/Desktop/Msc_Arbeit/_Results/_statistics_total/total_horizontal.xlsx")

total_horizontal_bag <- aggregate(total_horizontal[, 4:24], 
                       list(Bag = total_horizontal$bag), mean)

###  eigenvalues only###
# depth -> sections
total_horizontal %>%
  # filter( Center_depth > 600 & Center_depth < 900) %>%
  ggplot( legend = TRUE) +
  geom_point(aes(e1, Center_depth, colour = "e1")) +
  geom_point(aes(e2, Center_depth, colour = "e2")) +
  geom_point(aes(e3, Center_depth, colour = "e3")) +
  scale_y_reverse(breaks=seq(100,1900,200) ) +
  labs(x = "Eigenvalue",
       y = "Depth in m"
  ) +
  labs(title = "Eigenvalues vs Depth") 

# depth -> bag
total_horizontal_bag %>%
  # filter( Center_depth > 600 & Center_depth < 900) %>%
  ggplot( legend = TRUE) +
  geom_point(aes(e1, Center_depth, colour = "e1"), size =1) +
  geom_point(aes(e2, Center_depth, colour = "e2"), size =1) +
  geom_point(aes(e3, Center_depth, colour = "e3"), size =1) +
  geom_path(aes(e1, Center_depth, colour = "e1"), size =1.5) +
  geom_path(aes(e2, Center_depth, colour = "e2"), size =1.5) +
  geom_path(aes(e3, Center_depth, colour = "e3"), size =1.5) +
  scale_y_reverse(breaks=seq(100,1900,200) ) +
  labs(x = "Eigenvalue mean per bag",
       y = "Depth in m"
  ) +
  labs(title = "Eigenvalues vs Depth")

###  approx age b2k only###
brittle_zone <- data.frame(ymin=4400, ymax=9500, xmin=-Inf, xmax=Inf) # define brittle zone
LGP <- data.frame(ymin = 12000, ymax = Inf, xmin= -Inf, xmax = Inf)           # define LGM
Hol_Opt_1 <- data.frame(ymin=6000, ymax=8000, xmin=-Inf, xmax=Inf) # define Holocene Climate Opimum 1
Hol_Opt_2 <- data.frame(ymin=3800, ymax=5000, xmin=-Inf, xmax=Inf) # define Holocene Climate Opimum 1

total_horizontal %>%
  # filter( Center_depth > 600 & Center_depth < 900) %>%
  ggplot( legend = TRUE) +
  geom_point(aes(e1, Age_b2k, colour = "e1")) +
  geom_point(aes(e2, Age_b2k, colour = "e2")) +
  geom_point(aes(e3, Age_b2k, colour = "e3")) +
  scale_y_reverse(breaks=seq(0,20000, 1000)) +
  geom_rect(data=brittle_zone, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for brittle zone
            color="grey20",
            alpha=0.3,
            inherit.aes = FALSE) +
  annotate("text", x = 0.15, y = 8500, label = "Brittle Zone", colour = "white", size = 5)  +
  geom_rect(data=LGP, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for LGM
            color="grey20",
            alpha=0.3,
            inherit.aes = FALSE) +
  annotate("text", x = 0.15, y = 13000, label = "Start of LGP", colour = "white", size = 5)  +
  labs(x = "Eigenvalue",
       y = "Age b2k"
  ) +
  labs(title = "Eigenvalues vs Age")  
# holocene optima
# geom_rect(data=Hol_Opt_1, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for LGM
#           color="red4", fill = "red4",
#           alpha=0.1,
#           inherit.aes = FALSE) + 
# 
# # geom_rect(data=Hol_Opt_2, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for LGM
#           color="red4",fill = "red4",
#           alpha=0.1,
#           inherit.aes = FALSE) +  
# annotate("text", x = 0.7, y = 4000, label = "Holocene Climate Optimum", colour = "black", size = 3)  +
# annotate("text", x = 0.7, y = 6500, label = "Holocene Climate Optimum", colour = "black", size = 3) 



########### woodcock parameter ################
total_horizontal %>%
  filter( woodcock_parameter < 10) %>%
  ggplot() +
  scale_y_reverse( ) +
  # scale_x_continuous(breaks=c(0 , .5, 1, 3))  #  scale_x_continous( limits=c("0.0", "10")) +
  labs( y = "Depth in m") +
  labs(x = "Woodcock Parameter") +
  theme_minimal() +
  geom_point(mapping = aes(woodcock_parameter, Center_depth )) 

######### grain_size only ############### 
total_horizontal %>%
  filter( Center_depth != 701.3 ) %>%  # filter out invalid sample 1276_1, only half of the thin section
  filter( Center_depth != 645.38 ) %>%   # filter out invalid sample 1174_1, only half of the thin section
  filter( Center_depth > 600 & Center_depth < 900) %>%
  ggplot(aes(mean_grainSize, Center_depth)) +
  geom_point(mapping = aes(colour = section)) +
  scale_y_reverse( ) +
  # geom_smooth(mapping = aes(x = mean_grainSize, y = Center_depth)) + 
  labs(x = "Mean Grain-size") +
  labs(y = "Depth") +
  labs(title = "Mean Grain-size vs Depth") +
  theme_gray()

total_horizontal %>%
  filter( Center_depth > 1400 & Center_depth < 1800) %>%
  ggplot() +
  #    geom_point(aes(mean_grainSize, Center_depth)) +
  geom_point(aes(e2, Center_depth)) +
  scale_y_reverse( ) +
  # geom_smooth(mapping = aes(x = mean_grainSize, y = Center_depth)) + 
  labs(x = "Mean Grain-size") +
  labs(y = "Depth") +
  labs(title = "Mean Grain-size vs Depth") +
  theme_gray()


### box plot

total_horizontal %>%
  ggplot() + 
  scale_y_reverse(breaks=seq(100, 1900, 100) ) +
  labs( y = "Depth in m") +
  labs( x = "Mean Grain-Size Ratio") +  
  theme_linedraw() +
  geom_boxplot(aes(mean_grainSize, Center_depth, group=cut_width(Center_depth, 100)), 
               notch = FALSE, varwidth = TRUE, 
               outlier.colour = "red", outlier.shape = 1 ) 

### relationshio e2-e3
total_horizontal %>%
  ggplot() +
  geom_point(aes(relation_e2_e3, Center_depth)) +
  scale_y_reverse () +
  labs(x = "Relation e3/e2") +
  labs(y = "Depth in m") +
  labs(title = "Mean Grain-size vs Depth") +
  theme_gray()


