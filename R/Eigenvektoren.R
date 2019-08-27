# process Statistics

Statistics <- read.delim("~/Desktop/Msc_Arbeit/_Results/statistics_20180912.txt", header=FALSE)
# correct names
names(Statistics) [1] <- "directory"; names(Statistics) [2] <-"grain_number"; names(Statistics) [3] <-"mean_size"; 
names(Statistics) [4] <-"sum_vektor_norm"; names(Statistics) [5] <-"regelungsgrad";names(Statistics) [6] <-"regelungsgrad_g_weighted";
names(Statistics) [7] <-"concetration_parameter"; names(Statistics) [8] <-"concentration_parameter_g_weighted" ;names(Statistics) [9] <-"spherical_aperture";
names(Statistics) [10] <-"spherical_aperture_g_weighted"; names(Statistics); names(Statistics)[11] <-"e1"; names(Statistics) [12] <-"e1_g_weighted" ;
names(Statistics) [13] <-"e2"; names(Statistics) [14] <-"e2_g_weighted"; names(Statistics) [15] <-"e3"; names(Statistics) [16] <-"e3_g_weighted"; 
names(Statistics) [17] <-"woodcock"; names(Statistics) [18] <-"woodcock_g_weighted"

bag_number <- strsplit(Statistics[1], "/")
bag_name <-bag_no[[1]][6]    


Eigenvektoren <- Statistics[c(1, 2, 3, 11, 12, 13, 14, 15,16, 17, 18)]
names(Eigenvektoren) [1] <- "directory" 
names(Eigenvektoren) [2] <-"grain_number"
names(Eigenvektoren) [3] <-"mean_size"
names(Eigenvektoren) [4] <-"e1"
names(Eigenvektoren) [5] <-"e1_weighted"
names(Eigenvektoren) [6] <-"e2"
names(Eigenvektoren) [7] <- "e2_weighted" 
names(Eigenvektoren) [8] <-"e3"
names(Eigenvektoren) [9] <-"e3_weighted"
names(Eigenvektoren) [10] <-"woodcock"
names(Eigenvektoren) [11] <-"woodcock_weighted"

#### plot ##### 
Eigenvektoren %>% 
  ggplot() +
  #geom_smooth(mapping = aes(x = e1, y = directory)) 
  geom_point(mapping = aes(x = e1, y = e2, alpha = e3) ) 



