## 15/07/2018
## Preliminary analyses to demonstrate concept of
## habitat niche modelling of BGR seabird tracking data
## to identify and inform KBA designation

## Demo using BRBO data from Raine Island and 
## prediction to Swains population

## 1) Setup environmental data for GBR region

library(maps)
library(raster)
library(rgdal)

r1<-raster("/home/mark/grive/phd/sourced_data/env_data/ausbath_09_v4/w001001.adf")

# area of modelling 
p1<-SpatialPolygons(list(Polygons(list(Polygon(cbind(
  c(142,146,155, 155,152, 142),
  c(-9,-9, -21,-26,-26, -15)), hole=as.logical(NA))), ID=1)), 
  proj4string = CRS(projection(r1)))

# clip bathymetry
# function form. Note slow
#https://stat.ethz.ch/pipermail/r-sig-geo/2013-July/018912.html
######################################
clip<-function(raster,shape) {
  a1_crop<-crop(raster,shape)
  step1<-rasterize(shape,a1_crop)
  a1_crop*step1}
######################################

r1<-clip(r1, p1)

plot(r1);map('world', add=T)

reef<-readOGR( layer="GBR_DRY_REEF", dsn="/home/mark/grive/phd/sourced_data/env_data/GBRMPA_Data Export/GBR_DRY_REEF.shp", verbose=TRUE)
plot(r1)
plot(reef, add=TRUE)

rera<-rasterize(reef, r1, field=1,background=NA)
d_reef<-distance(rera)

cora<-rasterize(data.frame(x=144.0353, y=-11.5907), r1, field=1,background=NA)
d_col<-distance(cora)