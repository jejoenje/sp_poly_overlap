library(rgdal)
library(cshapes)
library(raster)

# Read the spatial distribution data. In this example, the distribution of Indian Pangolin (Manis crassicaudata).
# This is taken from a collection of Shapefiles of species distributions.
# This file is in the Github repo https://github.com/jejoenje/sp_poly_overlap 

mcras <- readOGR("mcras.shp")

# Plot the distribution:
plot(mcras, col = "red")

# Get basic country outlines from the cshapes package:
world <-cshp(as.Date('2016-01-01'))

# Make sure the projections match:
projection(mcras) <- projection(world)

# Crop the world country map to the extent of the species distribution (I think intersect() as used below does this
# automatically anyway, but for the sake of plotting)
mcras_base <- crop(world, extent(mcras))

# Plot distribution on top of base map.
plot(mcras_base)
plot(mcras, add=T, col="red")
# Note the occurrence across India, Bangladesh and Pakistan, but particularly in Sri Lanka.
# The latter is obviously a second, separate polygon (there are two separate entries in the data):
polygons(mcras)
mcras@data
# The base map has an entry for each country in the extent:
polygons(mcras_base)
mcras_base@data

# Now following the example on https://gis.stackexchange.com/questions/140504/extracting-intersection-areas-in-r
# use intersect() to intersect the polygons in mcras with those in mcras_base:
mcras_i <- intersect(mcras, mcras_base)
plot(mcras_i)
# We can now calculate the area in each country (arbitrary scalar for the sake of argument) :
mcras_i$area <- area(mcras_i)/1000000 
aggregate(area ~ CNTRY_NAME, data = mcras_i, sum)

# So this gives areas of the species distribution in each country, but it is obviously missing Sri Lanka entirely.
# Note how the resulting data only seems to have the intersects with the SECOND polygon in mcras, 
# i.e. only the contiguous area in India, Pakistan and Bangladesh. This tallies with the summary above.
mcras@data
mcras_i@data

# How do I make sure the same intersection is calculated for BOTH the polygon parts in mcras?
# I can plot them separately:

plot(mcras_base)
plot(mcras[1,], col="red", add=T)  # First line in mcras represents the distribution in Sri Lanka
plot(mcras[2,], col="blue", add=T) # Second line is the main distribution in India, Bangladesh and Pakistan.

# However, if I try to intersect the two species polygon parts separately, this works for the contiguous block:
mcras_i2 <- intersect(mcras[2,], mcras_base)
plot(mcras_i2)
# ... but NOT for the first block (Sri Lanka):
mcras_i1 <- intersect(mcras[1,], mcras_base)
plot(mcras_i1)
mcras_i1@data
mcras_i1@polygons
