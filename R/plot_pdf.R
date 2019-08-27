# plot stereographic projections in a pdf file


setwd("~/Dokumente/Analysis/stereo_plots")

# source("RockFab.R")
# library(RockFab)
library(png)
# library(extrafont)
# library(svglite)


# -----------------------------
# show all stereoplots in matrix

path <- "schmidt/png_sorted/"
files <- list.files(path,pattern=".png")
#files <- files[c(2:length(files),1)]

# png(file="Fabric_projections/schmidt_matrix.png", width=900, height=1200, family="cmr10")
# svg(file="Fabric_projections/schmidt_matrix.svg", width=9, height=12, family="cmr10")
out <- "schmidt_matrix_sorted.pdf"
# out <- "schmidt_matrix_clockwise.pdf"
# out <- "schmidt_matrix_anticlockwise.pdf"
pdf(file=out, width=9, height=12) #  family="CM Roman"

#par(mfrow=c(7,8))   # 5,6 also works
par(mfrow=c(5,6))   # 7,8 also works
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
##  d <- depth[which(stat$bag == bag & stat$sample == section)]
  d <- (as.numeric(bag)-1)*0.55 + as.numeric(section)*0.55/6
  text(1,0.8,paste(bag,"_",section,sep=""),cex=1.5)
  text(1,0.6,paste(round(d,2),"m",sep=""),cex=1.5)
}

dev.off()
# embed_fonts(out, outfile=out) # siehe font.R

