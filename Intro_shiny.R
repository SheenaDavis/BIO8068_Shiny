##Intro to Shiny 

library(shiny)


#Laying out the user-interface: basics
#basic_layout.R

wfarm <- base64enc::dataURI(file="www/UKwindfarm.png", mime="image/png")
habitats<-read.csv(file = "www/habitats.csv")


# Define UI ----
ui <- fluidPage(titlePanel("Windfarm development"),
         sidebarLayout(
           sidebarPanel("My Sidebar",
                        h3("a button"),
                        #actionButton(inputId = "my_submitstatus", label = "Submit"),
                        radioButtons(inputId = "my_checkgroup",
                                           h3("Select a habitat"),
                                           choices = list("Woodland" = 1,
                                                          "Grassland" = 2,
                                                          "Urban"= 3),
                                           selected = 1), # close radioButtons
                        sliderInput(inputId = "bins",
                                    label = "Number of bins:",
                                    min = 1,
                                    max = 50,
                                    value = 30) # close slideInput
           
                        ), # close sidebarPanel
         mainPanel(
           h1("This is the main heading for my app"),
           h2("here is a subheading"),
           p("This website will be to help planners assess potential windfarm
             development areas in Cumbria, and achieve a ",strong("balance"),
             "between different", em("interest groups"),"and other users."),
             img(src=wfarm),
             plotOutput( outputId = "habitats_plot")
                ) # close mainPanel
      ) # close sidebarLayour
) # close fluidPage

# Define server logic ----
server <- function(input, output) {
  
  output$habitats_plot <- renderPlot({
    
    #hist(habitats[,as.numeric(input$my_checkgroup)])
    
    # generate bins based on input$bins from ui.R
    x    <- habitats[,as.numeric(input$my_checkgroup)]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x,
         main = "Histogram of Habitats",
         xlab = "Habitat", 
         breaks = bins,
         col = 'grey',
         border = 'black')
  })
}
    
  

# Run the app ----
shinyApp(ui = ui, server = server)
