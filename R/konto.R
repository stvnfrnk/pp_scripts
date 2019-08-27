library(readxl); library(dplyr); library(stringi); library(tidyverse); library(ggplot2); library(readODS) # load libaries 

konto <- read.csv("~/Downloads/20190318-6017252249-umsatz.CSV", sep=";")
ausgaben <- konto$Betrag

  ggplot()+
  geom_histogram(aes(ausgaben))

  geom_point(aes(Buchungstag, Betrag), colour = "#D55E00", shape =17)  


# Basic histogram
