#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(leaflet)
library(leafem)
library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Nafferton Farm"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            #sliderInput("bins",
                       # "Number of bins:",
                        #min = 1,
                        #max = 50,
                        #value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            leafletOutput(outputId = "nafferton_map")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output)
    output$nafferton_map <- renderLeaflet({
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
        
    })
observeEvent(input$nafferton_map_click, {
    click<-input$nafferton_map_click
    text<-paste("Lattitude ", click$lat, "Longtitude ", click$lng)
    print(text)
})



   # output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
       # x    <- faithful[, 2]
       # bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
       # hist(x, breaks = bins, col = 'darkgray', border = 'white')
   # })
#}

# Run the application 
shinyApp(ui = ui, server = server)
