library(tidyverse);   library(hexbin); library(scatterplot3d); library(viridis); library(ggplot2)   # activate libraries
Results <- read.delim("~/Documents/R/EGRIP2018/data/Results.txt")     # load in data
Results_large <- read.delim("~/Documents/R/EGRIP2018/data/Results_large.txt") # load in data
Results_small <- read.delim("~/Documents/R/EGRIP2018/data/Results_small.txt") # load in data


# plot several statistics 

# filter for individual bags
## code for plotting all data points of each section indicidually, bag divided into its 6 sections
  Results  %>%          # pipe for data "Results"
  filter(bag_number== "2486") %>%         # filter for specific bag
  ggplot() +            # start ggplot with ggplot(), "+" adds another layer.   data can be defined here or beforehand with pipe operator
    geom_point(mapping = aes(x = azimuth, y = colatitude, alpha = grain_size)) +   # add layer of data points, variables defined (x and y). third variable is displayed by alpha, also possible by "colour" or "shape"
    geom_smooth(mapping = aes(x = azimuth, y = colatitude)) +   # add smoothing line, smoothing method can be changed
    facet_wrap(~ bag_section, nrow = 6)   # creates multiplot of 6 small plots
  
  
## code for plotting all data points of sample + smoothed mean line
  Results %>% 
    filter(bag_number== "2997") %>%
    filter( grain_size < 100 | grain_size > 3000) %>% 
    ggplot() +
    geom_smooth(mapping = aes(x = azimuth, y = colatitude)) + 
    geom_point(mapping = aes(x = azimuth, y = colatitude, alpha = grain_size) ) 
   # ggsave("/Users/nicolasstoll/Documents/R/EGRIP2018/plots/AOI/2997.png")    # save output
  
  ####### try and error plots

  # hexagonal

  Results  %>% 
    filter(bag_number== "2997") %>%
    ggplot() +
    geom_hex(mapping = aes(x = azimuth, y = colatitude), bins= 28)    # hexagonal desnity plot, change width and size of bins if needed
  # ggsave("/Users/nicolasstoll/Documents/R/EGRIP2018/plots/counter/2997.png") 
  
  # filled contours     contour plot
  Results  %>% 
  filter(bag_number== "P646") %>%
  ggplot(aes(azimuth, colatitude)) +
   stat_density_2d(aes(fill = stat(level)), geom = "polygon") +
    scale_fill_viridis()

  

  