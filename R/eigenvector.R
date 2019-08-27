##### eigenvector
# process and plot general statistics e.g.  mean_grainsize and several other parameters
library(dplyr); library(stringi); library(tidyverse); library(ggplot2)

eigenvectors_processed <- read.delim("~/Desktop/Msc_Arbeit/_Results/Eigenvektoren/eigenvectors_processed.txt", row.names=1)  # load eigenvector file

Center_depth <- data.frame(eigenvectors_processed$bag*0.55)  ## calculate depth
eigenvectors_processed <- cbind(eigenvectors_processed, Center_depth)             # add new column to total-data set
names(eigenvectors_processed)[names(eigenvectors_processed)=="eigenvectors_processed.bag...0.55"] <- "Center_depth" # add calculated depth

# plot eigenvectors
eigenvectors_processed %>%
#  filter (Plunge_V1 != 73.4) %>%
  ggplot()+
  geom_point(aes(Plunge_V1, Center_depth)) +
  scale_y_reverse(breaks=seq(100, 1750, 200)) +
  labs(x = "Plunge of Eigenvector in ??",
       y = "Depth in m") +
#  labs(title = "Eigenvector vs Depth") +
  theme_gray()
  
