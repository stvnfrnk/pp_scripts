# area investigation
# process and plot general statistics e.g.  mean_grainsize and several other parameters
library(readxl); library(dplyr); library(stringi); library(tidyverse); library(ggplot2)

Area_total <- read.delim("~/Documents/R/EGRIP2018/data/Area_total.txt") # read in summary


total <- read_excel("~/Desktop/Msc_Arbeit/_Results/_statistics_total/total.xls", 
                    col_types = c("numeric", "numeric", "text", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", "numeric", 
                                  "numeric", "numeric", "numeric", "numeric", 
                                  "numeric"))

## define areas
area_1 <- total[c(1:145), c(1:24)]
area_2 <- total[c(146:336), c(1:24)]
area_3 <- total[c(337:415), c(1:24)]
area_4 <- total[c(416:476), c(1:24)]
area_5 <- total[c(477:605), c(1:24)]
area_6 <- total[c(606:744), c(1:24)]

# calculate statistics

# change number for different areas
area_5_sum <- area_5 %>%
 summarise(average_GS = mean(mean_grainSize), med_GS = median(mean_grainSize), std_GS = sd(mean_grainSize), 
                             max_GS = max(mean_grainSize),min_GS = min(mean_grainSize), IQR_GS = IQR(mean_grainSize),n_GS = n(), 
            average_RG = mean(regelungsgrad), med_RG = median(regelungsgrad), std_RG = sd(regelungsgrad),
                            max_RG = max(regelungsgrad),min_RG = min(regelungsgrad), IQR_RG = IQR(regelungsgrad), 
            average_SA = mean(spherical_aperture), med_SA = median(spherical_aperture), std_SA = sd(spherical_aperture), 
                            max_SA = max(spherical_aperture),min_SA = min(spherical_aperture), IQR_SA = IQR(spherical_aperture), 
            average_WP = mean(woodcock_parameter), med_WP = median(woodcock_parameter), std_WP = sd(woodcock_parameter), 
                    max_WP = max(woodcock_parameter),min_WP = min(woodcock_parameter), IQR_WP = IQR(woodcock_parameter)
            )
area_total <- rbind(area_1_sum, area_2_sum, area_3_sum, area_4_sum, area_5_sum, area_6_sum)
  area= seq(1,6,1)
  area_total = cbind(area_total,area)
  
  lower <-(area_total$average_GS-area_total$std_GS)
  upper <- (area_total$average_GS+area_total$std_GS)

  write.table(area_total, "/Users/nicolasstoll/Documents/R/EGRIP2018/data/Area_total.txt", sep="\t")   # write output file
  
  
  
#### plot## 
  Area_total %>%
    ggplot() +
    geom_errorbar(aes(x = area, ymin= lower, ymax= upper, colour ="Standard Deviation"), width=0.1, size=.3) +
    geom_point(aes(area, average_GS, colour = "Mean"), size = 2.5) +   # mean grain size
    geom_point(aes(area, med_GS, colour = "Median"), size = 2.5, shape = 3) +                 # median grain-size
    geom_point(aes(area, max_GS, colour ="Max-Min"), size = 2, shape = 8) +              # maximum value
    geom_point(aes(area, min_GS), size = 2, shape = 8) +              # minimum value
    scale_x_continuous(breaks=seq(1, 6, 1)) +
    scale_colour_manual("",
                        breaks = c("Standard Deviation", "Mean", "Median", "Max-Min"),
                        values = c("sienna","cornflowerblue", "red2", "black")) +
  labs(x = "Section of the core",
       y = "Grain-size in pixel") 

    # ggplot(data = datos, aes(x = fecha)) +
    # geom_line(aes(y = TempMax, colour = "TempMax")) +
    # geom_line(aes(y = TempMedia, colour = "TempMedia")) +
    # geom_line(aes(y = TempMin, colour = "TempMin")) +
    # scale_colour_manual("", 
    #                     breaks = c("TempMax", "TempMedia", "TempMin"),
    #                     values = c("red", "green", "blue")) +
    # xlab(" ") +
    # scale_y_continuous("Temperatura (C)", limits = c(-10,40)) + 
    # labs(title="TITULO")
    # 
    # 
    # 
    
  

   
   # geom_point(aes(std_GS, area), colour ="peru") +
   # geom_errorbarh(aes(xmax = (average_GS+std_GS), xmin = average_GS - std_GS))
  
  
  
  
  
  
  
## area_1
area_1  %>%
  ggplot( legend = TRUE) +
  #   theme(legend.title=element_blank()) +   # get rid of legend completely
  scale_colour_discrete(name="Vertical \nsections") +
  geom_point(aes(e1, Center_depth, colour = "e1")) +
  geom_point(aes(e2, Center_depth, colour = "e2")) +
  geom_point(aes(e3, Center_depth, colour = "e3")) +
  #  geom_polygon(aes(e2, Center_depth), colour ="linen", fill= "olivedrab2") +
  scale_y_reverse(breaks=seq( 110, 260, 20 )) +
  labs(x = "Eigenvalue",
       y = "Depth in m") +
  labs(title = "section 1") 

## area_2
area_2  %>%
  ggplot( legend = TRUE) +
  #   theme(legend.title=element_blank()) +   # get rid of legend completely
  scale_colour_discrete(name="Vertical \nsections") +
  geom_point(aes(e1, Center_depth, colour = "e1")) +
  geom_point(aes(e2, Center_depth, colour = "e2")) +
  geom_point(aes(e3, Center_depth, colour = "e3")) +
  #  geom_polygon(aes(e2, Center_depth), colour ="linen", fill= "olivedrab2") +
  scale_y_reverse(breaks=seq(261, 540, 20) ) +
  labs(x = "Eigenvalue",
       y = "Depth in m") +
  labs(title = "section 2") 

## area_3 546,7-740,3 
area_3  %>%
  ggplot( legend = TRUE) +
  #   theme(legend.title=element_blank()) +   # get rid of legend completely
  scale_colour_discrete(name="Vertical \nsections") +
  geom_point(aes(e1, Center_depth, colour = "e1")) +
  geom_point(aes(e2, Center_depth, colour = "e2")) +
  geom_point(aes(e3, Center_depth, colour = "e3")) +
  #  geom_polygon(aes(e2, Center_depth), colour ="linen", fill= "olivedrab2") +
  scale_y_reverse(breaks=seq(545, 760, 15) ) +
  labs(x = "Eigenvalue",
       y = "Depth in m") +
  labs(title = "section 3") 

## area_4 756,8 - 900,35
area_4  %>%
  ggplot( legend = TRUE) +
  #   theme(legend.title=element_blank()) +   # get rid of legend completely
  scale_colour_discrete(name="Vertical \nsections") +
  geom_point(aes(e1, Center_depth, colour = "e1")) +
  geom_point(aes(e2, Center_depth, colour = "e2")) +
  geom_point(aes(e3, Center_depth, colour = "e3")) +
  #  geom_polygon(aes(e2, Center_depth), colour ="linen", fill= "olivedrab2") +
  scale_y_reverse(breaks=seq(750, 910, 15) ) +
  labs(x = "Eigenvalue",
       y = "Depth in m") +
  labs(title = "section 4") 

## area_5 1062.6 - 1361.25 
area_5  %>%
  ggplot( legend = TRUE) +
  #   theme(legend.title=element_blank()) +   # get rid of legend completely
  scale_colour_discrete(name="Vertical \nsections") +
  geom_point(aes(e1, Center_depth, colour = "e1")) +
  geom_point(aes(e2, Center_depth, colour = "e2")) +
  geom_point(aes(e3, Center_depth, colour = "e3")) +
  #  geom_polygon(aes(e2, Center_depth), colour ="linen", fill= "olivedrab2") +
  scale_y_reverse(breaks=seq(1060, 1370, 20) ) +
  labs(x = "Eigenvalue",
       y = "Depth in m") +
  labs(title = "section 5") 

## area_6 1366,75 - 1714.35
area_6  %>%
  ggplot( legend = TRUE) +
  scale_colour_discrete(name="Vertical \nsections") +
  geom_point(aes(e1, Center_depth, colour = "e1")) +
  geom_point(aes(e2, Center_depth, colour = "e2")) +
  geom_point(aes(e3, Center_depth, colour = "e3")) +
  #  geom_polygon(aes(e2, Center_depth), colour ="linen", fill= "olivedrab2") +
  scale_y_reverse(breaks=seq( 1360, 1715, 25 )) +
  labs(x = "Eigenvalue",
       y = "Depth in m") +
  labs(title = "section 6") 

########################
