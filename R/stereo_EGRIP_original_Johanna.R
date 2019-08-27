# plot stereographic projections per sample using stereo.txt generated from cAxes i.e. looking down the core axis
# some runs are approximately corrected for core azimuth according to estimates during logging for angle in hours (anticlockwise!)

setwd("~/Dokumente/Analysis/stereo_plots")

source("RockFab.R")
# library(RockFab)
# library(png)
# library(extrafont)
# library(svglite)

# for section plots
stat <- read.table("../profile_plots/egrip_vertical_data.dat", header=T, fill=T)

depth <- stat$topdepth_m
core_az <- stat$orient_deg

files <- list.files(path="cAxes_stereo_files")


for (f in files) {
  sample <- strsplit(f,"EGRIP")[[1]][2]
  bag <- strsplit(sample,"_")[[1]][1]
  section <- strsplit(sample,"_")[[1]][2]
  
  out <- paste("schmidt/png/EGRIP_", bag, "_", section, "_stereo", sep = "")
  png(file=paste(out,".png",sep=""), width=200, height=200, title = as.character(sample),family="cmr10")
#  out <- paste("schmidt/EGRIP_", bag, "_", section, "_stereo.pdf", sep = "")
#  pdf(file=out, width=3, height=3, title = as.character(sample),family="CM Roman")
  # fonts <- list(sans = "TeX Sans")
  # svglite(paste(out,".svg",sep=""), width=3, height=3, system_fonts=fonts)
  
  data <- read.table(paste("cAxes_stereo_files/", f, sep=""))
  trend <- data$V1
  plunge <- data$V2
  
#   azimuth correction
    trend_corr <- trend - core_az[which(stat$bag == bag & stat$sample == section)] # + (clockwise), - (anticlockwise)
    trend_corr[trend_corr > 360] <- trend_corr[trend_corr > 360] - 360 # if correction leads to az > 360 --> corr
    trend_corr[trend_corr < 0] <- trend_corr[trend_corr < 0] + 360 # if correction leads to az > 360 --> corr
    trend <- trend_corr


#   StereoPlot(paste("Sample ",i,"-",j," @ ", round(d/100,2), " m", ", ", length(trend), " grains", sep=""), new=F)
  StereoPlot("",new=F)  # for small version
  StereoWeb() # Schmidtnet/equal-area
  StereoCirc()
  StereoPoint(my.az=trend, my.inc=plunge, my.size=0.4, my.color="black")
  text(1,1,length(trend),cex=1.5)

  
  dev.off()
#   embed_fonts(out, outfile=out)  # needed if pdf!

}

# -----------------------------

# for file in *.png; do convert $file -trim "$file"; done

# -----------------------------
# show all stereoplots in matrix

path <- "schmidt/png/"
files <- list.files(path,pattern=".png")
files <- files[c(2:length(files),1)]

# png(file="Fabric_projections/schmidt_matrix.png", width=900, height=1200, family="cmr10")
# svg(file="Fabric_projections/schmidt_matrix.svg", width=9, height=12, family="cmr10")
# out <- "schmidt_matrix.pdf"
# out <- "schmidt_matrix_clockwise.pdf"
out <- "schmidt_matrix_anticlockwise.pdf"
pdf(file=out, width=9, height=12) #  family="CM Roman"

par(mfrow=c(7,8))   # 5,6 also works
par(xaxs="i",yaxs="i")
par(oma=c(0,0.2,0,0.2))
par(mar=c(0,0,0,0))

for (f in files){
  image <- readPNG(paste(path,f,sep=""))
  plot(0, type="n", axes = F, ann = F)
  lim <- par()
  rasterImage(image, lim$usr[1], lim$usr[3]+0.25, lim$usr[2], lim$usr[4]/2)
  bag <- strsplit(f,"_")[[1]][2]
  section <- strsplit(f,"_")[[1]][3]
  d <- depth[which(stat$bag == bag & stat$sample == section)]
  text(1,0.8,paste(bag,"_",section,sep=""),cex=1.5)
  text(1,0.6,paste(d,"m",sep=""),cex=1.5)
}

dev.off()
# embed_fonts(out, outfile=out) # siehe font.R
