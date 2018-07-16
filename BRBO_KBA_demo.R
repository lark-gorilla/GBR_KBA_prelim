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

# area of modelling 
p1<-SpatialPolygons(list(Polygons(list(Polygon(cbind(
  c(142,146,155, 155,152, 142),
  c(-9,-9, -21,-26,-26, -15)), hole=as.logical(NA))), ID=1)), 
  proj4string = CRS('+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs'))

## setup 1 km sampling grid using extent of polygon

rasgrid<-raster(extent(p1), res=0.00898)

rgrid<-as(rasgrid, 'SpatialPoints')
rgrid@proj4string<-CRS(projection(p1))

# clip to p1 extent
rgrid<-rgrid[p1]


bathy<-raster("/home/mark/grive/phd/sourced_data/env_data/ausbath_09_v4/w001001.adf")

reef<-readOGR( layer="GBR_DRY_REEF", dsn="/home/mark/grive/phd/sourced_data/env_data/GBRMPA_Data Export/GBR_DRY_REEF.shp", verbose=TRUE)

rera<-rasterize(reef, rasgrid, field=1,background=NA)
d_reef<-distance(rera)

boob_cols<-data.frame(col=c('Raine', 'Price Cay'),
                      x=c(144.0353,152.451),
                      y=c(-11.5907, -21.788))

cora<-rasterize(boob_cols[,2:3], rasgrid, field=1,background=NA)
d_col<-distance(cora)

## rerdapp

# get monthly data for SST CHLA and others for dec (Raine)
# and for July (Swains)

library(rerddap)
library(ncdf4)

#product code from here:
#https://coastwatch.pfeg.noaa.gov/erddap/griddap/index.html?page=1&itemsPerPage=1000

# chl use erdVH3chlamday or erdMH1chlamday 
# sst erdAGsstamday 
# ssh nrlHycomGLBu008e911S (daily) - DID NOT DO
# wind stress and upwelling erdQMstressmday
# sst anomaly erdAGtanmmday

## rerddap not working so doing downloads manually:

# chla

download.file(url='https://coastwatch.pfeg.noaa.gov/erddap/griddap/erdVH3chlamday.nc?chla[(2014-06-15T00:00:00Z):1:(2014-06-15T00:00:00Z)][(-9):1:(-26)][(142):1:(155)]',
              destfile='/home/mark/research/GBR_KBA/sourced_data/chla_jul14.nc')

download.file(url='https://coastwatch.pfeg.noaa.gov/erddap/griddap/erdVH3chlamday.nc?chla[(2014-12-15T00:00:00Z):1:(2014-12-15T00:00:00Z)][(-9):1:(-26)][(142):1:(155)]',
              destfile='/home/mark/research/GBR_KBA/sourced_data/chla_dec14.nc')

# sst

download.file(url='https://coastwatch.pfeg.noaa.gov/erddap/griddap/erdMH1sstdmday.nc?sst[(2014-06-16T00:00:00Z):1:(2014-06-16T00:00:00Z)][(-9):1:(-26)][(142):1:(155)]',
              destfile='/home/mark/research/GBR_KBA/sourced_data/sst_jul14.nc')

download.file(url='https://coastwatch.pfeg.noaa.gov/erddap/griddap/erdMH1sstdmday.nc?sst[(2014-12-16T00:00:00Z):1:(2014-12-16T00:00:00Z)][(-9):1:(-26)][(142):1:(155)]',
              destfile='/home/mark/research/GBR_KBA/sourced_data/sst_dec14.nc')

# eke and modW

download.file(url='https://coastwatch.pfeg.noaa.gov/erddap/griddap/erdQMstressmday.nc?modStress[(2014-06-16T00:00:00Z):1:(2014-06-16T00:00:00Z)][(0.0):1:(0.0)][(-26):1:(-9)][(142):1:(155)],upwelling[(2014-06-16T00:00:00Z):1:(2014-06-16T00:00:00Z)][(0.0):1:(0.0)][(-26):1:(-9)][(142):1:(155)]',
              destfile='/home/mark/research/GBR_KBA/sourced_data/ekemodw_jul14.nc')

download.file(url='https://coastwatch.pfeg.noaa.gov/erddap/griddap/erdQMstressmday.nc?modStress[(2014-12-16T00:00:00Z):1:(2014-12-16T00:00:00Z)][(0.0):1:(0.0)][(-26):1:(-9)][(142):1:(155)],upwelling[(2014-12-16T00:00:00Z):1:(2014-12-16T00:00:00Z)][(0.0):1:(0.0)][(-26):1:(-9)][(142):1:(155)]',
              destfile='/home/mark/research/GBR_KBA/sourced_data/ekemodw_dec14.nc')

# sstA

download.file(url='https://coastwatch.pfeg.noaa.gov/erddap/griddap/erdAGtanmmday.nc?sstAnomaly[(2014-06-16T00:00:00Z):1:(2014-06-16T00:00:00Z)][(0.0):1:(0.0)][(-26):1:(-9)][(142):1:(155)]',
              destfile='/home/mark/research/GBR_KBA/sourced_data/sstanom_jul14.nc')

download.file(url='https://coastwatch.pfeg.noaa.gov/erddap/griddap/erdAGtanmmday.nc?sstAnomaly[(2014-12-16T00:00:00Z):1:(2014-12-16T00:00:00Z)][(0.0):1:(0.0)][(-26):1:(-9)][(142):1:(155)]',
              destfile='/home/mark/research/GBR_KBA/sourced_data/sstanom_dec14.nc')



