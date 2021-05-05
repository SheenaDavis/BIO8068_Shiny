###Shiny ex 2 
##Spatial data in shiny 

library(leaflet)
library(leafem)
library(mapview)

# Create the map
my_map <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=-1.6178, lat=54.9783, popup="World's most important city!")

my_map  # Display the map in Viewer window

#multiple backdrop maps

leaflet() %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>% 
  addProviderTiles(providers$Stamen.TonerLines,
                   options = providerTileOptions(opacity = 0.5)) %>%
  addProviderTiles(providers$Stamen.TonerLabels) %>% 
  addMarkers(lng=-1.6178, lat=54.9783, popup="World's most important city!")

##changing marker symbols
leaflet() %>%
  addTiles() %>%  
  addCircleMarkers(lng=-1.6178, lat=54.9783,
                   popup="The world's most important city!",
                   radius = 5, color = "red")

#marker popups and labels 
leaflet() %>%
  addTiles() %>%  
  addCircleMarkers(lng=-1.6178, lat=54.9783,
                   popup="Newcastle population 270k",
                   labelOptions = labelOptions(textsize = "15px"))

##Vector maps and leaflet
#intro 
library(sf)

nafferton_fields <- st_read("www/naff_fields.shp")
st_crs(nafferton_fields)


# First reset nafferton fields to OS 27700. Depending on the source of your data
# you may not always need this first step
nafferton_fields <- nafferton_fields %>% 
  st_set_crs(27700) %>% 
  st_transform(27700)

# Transform to latitude longitude
nafferton_fields_ll <- st_transform(nafferton_fields, 4326) # Lat-Lon

plot(nafferton_fields)
plot(nafferton_fields_ll)

nafferton_fields_ll$Farm_Meth
#displaying the map using leaflet

leaflet() %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>% 
  addFeatures(nafferton_fields_ll)


#Sub-setting by farming method and differentiating using colour 

leaflet() %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>% 
  addFeatures(nafferton_fields_ll[nafferton_fields_ll$Farm_Meth=="Organic",], color="red")%>%
  addFeatures(nafferton_fields_ll[nafferton_fields_ll$Farm_Meth=="Conventional",], color="yellow")
#remember further options to come after ], 
  
#Continuous color options  

# Set the bins to divide up your areas
bins <- c(0, 25000, 50000, 75000, 100000, 125000, 150000, 175000, 200000, 225000)

# Decide on the colour palatte
pal <- colorBin(palette = "Greens", domain = bins)

# Create the map
leaflet() %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>% 
  addFeatures(nafferton_fields_ll,
              fillColor = ~pal(nafferton_fields_ll$Area_m),
              fillOpacity = 1)


#To save repeated calls to nafferton_fields_ll in the code it is easier to
#include the sf object as an “argument” to the leaflet() function. 
#Here we show the results using our pre-defined bins with colorBin, 
#but you could also use colorQuantile:

pal <- colorNumeric(palette = "Greens", domain = bins)

# Now leaflet is called with nafferton_fields_ll
leaflet(nafferton_fields_ll) %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>% 
  addFeatures(fillColor = ~pal(Area_m),
              fillOpacity = 1) %>% 
  addLegend("bottomright",
            pal = pal,
            values = ~Area_m,
            title = "Field area",
            labFormat = labelFormat(suffix = " m^2"),
            opacity = 1)

#Highlights and popups
#create variable to hold popup info:

field_info <- paste("Method: ", nafferton_fields_ll$Farm_Meth,
                    "<br>",
                    "Crop: ", nafferton_fields_ll$Crop_2010)

#add highlights and popups into addFeatures()

leaflet(nafferton_fields_ll) %>% 
  addProviderTiles(providers$Esri.WorldImagery) %>% 
  addFeatures(fillColor = ~pal(Area_m),
              fillOpacity = 1, 
              highlightOptions = highlightOptions(color = "yellow",
                                                  weight = 5,
                                                  bringToFront = TRUE),
              popup = field_info) %>%
 
  addLegend("bottomright",
            pal = pal,
            values = ~Area_m,
            title = "Field area",
            labFormat = labelFormat(suffix = " m^2"),
            opacity = 1)

#Interactive control of foreground and background maps

leaflet() %>% 
  addTiles(group = "OSM (default)") %>% 
  addProviderTiles(providers$Esri.WorldImagery,
                   group = "Satellite") %>% 
  addLayersControl(
    baseGroups = c("OSM (default)", "Satellite")
  )

#basegroups and overlays 

leaflet() %>% 
  addTiles(group = "OSM (default)") %>% 
  addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
  addFeatures(nafferton_fields_ll, group = "Nafferton Farm") %>% 
  addLayersControl(
    baseGroups = c("OSM (default)", "Satellite"), 
    overlayGroups = "Nafferton Farm",
    options = layersControlOptions(collapsed = FALSE)
  )

#Organic or Conventional
leaflet() %>%
  addTiles(group = "OSM (default)") %>% 
  addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
  addFeatures(nafferton_fields_ll[nafferton_fields_ll$Farm_Meth=="Organic",],
              fillColor="green",
              color="white",
              opacity =0.7,
              fillOpacity=1,
              group = "Organic") %>% 
  addFeatures(nafferton_fields_ll[nafferton_fields_ll$Farm_Meth=="Conventional",],
              fillColor="red",
              color="yellow", 
              fillOpacity=1,
              group = "Conventional") %>% 
  addLayersControl(
    baseGroups = c("OSM (default)", "Satellite"), 
    overlayGroups = c("Organic", "Conventional"),
    options = layersControlOptions(collapsed = FALSE)
  )
