library(rgdal)
library(cshapes)
library(raster)

# Read 

mcras <- readOGR("mcras.shp")

plot(mcras, col = "red")

world <-cshp(as.Date('2016-01-01'))

projection(mcras) <- projection(world)

mcras_base <- crop(world, extent(mcras))

plot(mcras_base)
plot(mcras, add=T, col="red")

polygons(mcras)
polygons(mcras_base)

mcras_i <- intersect(mcras, mcras_base)
mcras_i$area <- area(mcras_i)/1000000 
aggregate(area ~ CNTRY_NAME, data = mcras_i, sum)