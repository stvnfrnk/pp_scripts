# process and plot general statistics e.g.  mean_grainsize and several other parameters
library(readxl); library(dplyr); library(stringi); library(tidyverse); library(ggplot2)

total <- read_excel("~/Desktop/Msc_Arbeit/_Results/_statistics_total/total.xls", 
                    col_types = c("numeric", "numeric", "text", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", "numeric", 
                                  "numeric"))

mean_grainSize_um <- data.frame(total$mean_grainSize*20)
total <- cbind(total, mean_grainSize_um)             # add new column to total-data set
names(total)[names(total)=="total.mean_grainSize...20"] <- "mean_grainSize_um"  # change name of new column

##### plot####

## events plot
## define events
brittle_zone <- data.frame(ymin=500, ymax=1100, xmin=-Inf, xmax=Inf) # define brittle zone
LGP <- data.frame(ymin = 1300, ymax = Inf, xmin= -Inf, xmax = Inf)           # define LGM
Hol_Opt_1 <- data.frame(ymin=708, ymax=936.8, xmin=-Inf, xmax=Inf) # define Holocene Climate Opimum 1
Hol_Opt_2 <- data.frame(ymin=456.5, ymax=593.5, xmin=-Inf, xmax=Inf) # define Holocene Climate Opimum 1
Roman_warm_period <- data.frame(ymin=279.2, ymax=204.81, xmin=-Inf, xmax=Inf) # define roman warm period
IronAge_Cold <- data.frame(ymin=285, ymax=353.3, xmin=-Inf, xmax=Inf) # define iron age cold
BronzeAge_Cold <- data.frame(ymin=422, ymax=456.5, xmin=-Inf, xmax=Inf) # bronze age cold
cold_8.2 <- data.frame(y=960, xmin=-Inf, xmax=Inf) # cold 8.2
cold_5.9 <- data.frame(yintercept=731, xmin=-Inf, xmax=Inf) # 



total %>%
  # filter( Center_depth > 600 & Center_depth < 900) %>%
  ggplot() +
  theme(legend.title=element_blank()) +   # get rid of legend completely
  
  geom_rect(data=Roman_warm_period, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for LGP
            color="grey20",
            alpha=0.2,
            inherit.aes = FALSE) +
  annotate("text", x = 0.065, y = 150, label = "Roman Warm \nPeriod", colour = "black", size = 3.5)  +     # implement text for LGP
  
  geom_rect(data=brittle_zone, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for brittle zone
            color="salmon2",
            alpha=0.1,
            inherit.aes = FALSE) +
  annotate("text", x = 0.15, y = 1060, label = "Brittle Zone", colour = "salmon2", size = 3.5,fontface = "bold")  +   # implement text for brittole zone
  
  geom_hline(yintercept = 731, linetype="dashed", color = "red") +   # cold 5.9     add vertical line
  annotate("text", x = 0.15, y = 685, label = "5.9k event", colour = "firebrick2", size = 3.5)  +    # implement text
  
  geom_hline(yintercept = 960, linetype="dashed", color = "red") +   # cold 8.2k    add vertical line
  annotate("text", x = 0.15, y = 985, label = "8.2k event", colour = "firebrick2", size = 3.5)  +     # implement text
  
  labs(x = "Eigenvalue",     # define axes
       y = "Depth in m"
  ) +
  
  geom_rect(data=Hol_Opt_1, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for holocene optimum 1
            color="grey20",
            alpha=0.2,
            inherit.aes = FALSE) +
  
  geom_rect(data=Hol_Opt_2, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for holocene optimum 2
            color="grey20",
            alpha=0.2,
            inherit.aes = FALSE) +
  annotate("text", x = 0.165, y = 545, label = "Holocene Climate \nOptimum ", colour = "black", size = 3.5) +  # implement text
  annotate("text", x = 0.165, y = 840, label = "Holocene Climate \nOptimum ", colour = "black", size = 3.5)  +  # implement text
  
  geom_rect(data=LGP, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax),  # implement rectangle for LGM
            color="grey20",
            alpha=0.2,
            inherit.aes = FALSE) +
  
  annotate("text", x = 0.15, y = 1550, label = "Last Glacial", colour = "black", size = 3.5, fontface = "bold")  +  # implement text for LGP
  
  #  theme(legend.title=element_blank(), legend.position ="bottom",legend.direction="horizontal") +     # change style of legend
  geom_point(aes(e1, Center_depth, colour ="e1")) +   # add egenvalues 
  geom_point(aes(e2, Center_depth, colour = "e2")) +
  geom_point(aes(e3, Center_depth, colour = "e3")) +
  scale_y_reverse(breaks=seq(0, 1750, 100))   # change scale, reverse and set tick marks + labels