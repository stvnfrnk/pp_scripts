# Functions defined in RockFab package which has problems to be installed in newer R versions
# Joker, Sept 2017


StereoCirc <-
  function(n.seg = 360){
    cir.x <- cos(seq(from = 0, to  = 2 * pi, length = n.seg))
    cir.y <- sin(seq(from = 0, to  = 2 * pi, length = n.seg))
    lines(cir.x, cir.y)
    lines(c(-0.025, 0.025), c(0, 0), lwd = .5)
    lines(c(0, 0), c(-0.025, 0.025), lwd = .5)
  }


StereoPoint <-
  function(my.az = 90, my.inc = 45, my.color = 'white', my.bg = "black", my.pch = 21, my.size = .25, my.label){
    my.az <-  my.az * (pi / 180) + pi
    my.inc <- my.inc * (pi / 180) - pi / 2
    my.tq <- sqrt(2) * sin(my.inc / 2)
    my.x <- my.tq * sin(my.az)
    my.y <- my.tq * cos(my.az)
    
    if(!missing(my.label)){
      i <- 0
      par(ps = 8)
      while(i < length(my.label)){
        i <- 1 + i
        text(my.x[i] + .025, my.y[i] + .025, my.label[i], cex = .9, adj = c(0, 0))
      }
    }
    points(my.x, my.y, pch = my.pch, col = my.color, cex = my.size, bg = my.bg)
  }


StereoWeb <-
  function(){
    my.lambda.sc = seq(from = 0, to = pi, by = pi / 36) - pi / 2
    for (j in seq(from = -1 * pi / 2 + pi / 18, to = pi / 2 - pi / 18, by = pi / 18)) {
      #phi = j
      x = (sqrt(2) / 2) * sqrt(2/(1 + cos(j) * cos(my.lambda.sc))) * cos(j) * sin(my.lambda.sc)
      y = (sqrt(2) / 2) * sqrt(2/(1 + cos(j) * cos(my.lambda.sc))) * sin(j)
      lines(x, y, lwd = .5, col = '#dddddd')
    }
    my.phi <- seq(from = -1 * pi / 2, to = pi / 2, by = pi / 36)
    for (j in seq(from = pi / 18, to = pi - pi / 18, by = pi / 18)) {
      x = (sqrt(2) / 2) * sqrt(2/(1 + cos(my.phi) * cos(j - pi / 2))) * cos(my.phi) * sin(j - pi / 2)
      y = (sqrt(2) / 2) * sqrt(2/(1 + cos(my.phi) * cos(j - pi / 2))) * sin(my.phi)
      lines(x, y, lwd = .5, col = '#dddddd')
    }
    lines(c(-0.025, 0.025), c(0, 0), lwd = .5)
    lines(c(0, 0), c(-0.025, 0.025), lwd = .5)
  }


StereoPlot <-
  function(my.title = "Stereonet", new = TRUE, pdf.file){
    if(new == TRUE & missing(pdf.file)){
      dev.new(width = 3, height = 3.75, family = 'serif')
    }
    if(missing(pdf.file) == FALSE){
      pdf(file = pdf.file, width = 3, height = 3.75, family = 'serif', useDingbats = FALSE)
    }
    par(mai = c(0, 0, 0, 0), omi = c(0, 0, .5, 0))
    plot(0, 0, pch = '', asp = 1, ann = FALSE, xlim = c(-1, 1), ylim = c(-1, 1), axes = FALSE)
    lines(c(0, 0), c(1, 1.02), lwd = .5)
    # text(0, 1.025, "N", adj = c(.5, 0), cex = .75)
    mtext(my.title, cex = 1.25)
  }

