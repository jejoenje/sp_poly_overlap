# From https://gis.stackexchange.com/questions/140504/extracting-intersection-areas-in-r

library(sp)
library(raster)
library(rgdal)
library(rgeos)
library(maptools)

# Example data from raster package
p1 <- shapefile(system.file("external/lux.shp", package="raster"))
# Remove attribute data
p1 <- as(p1, 'SpatialPolygons')
# Add in some fake soil type data
soil <- SpatialPolygonsDataFrame(p1, data.frame(soil=LETTERS[1:12]), match.ID=F)

# Field polygons
p2 <- union(as(extent(6, 6.4, 49.75, 50), 'SpatialPolygons'),
            as(extent(5.8, 6.2, 49.5, 49.7), 'SpatialPolygons'))
field <- SpatialPolygonsDataFrame(p2, data.frame(field=c('x','y')), match.ID=F)
projection(field) <- projection(soil)

# intersect from raster package
pi <- intersect(soil, field)
plot(soil, axes=T); plot(field, add=T); plot(pi, add=T, col='red')

# Extract areas from polygon objects then attach as attribute
pi$area <- area(pi) / 1000000

# For each field, get area per soil type
aggregate(area~field + soil, data=pi, FUN=sum)