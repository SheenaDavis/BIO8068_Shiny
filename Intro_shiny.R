##Intro to Shiny 

install.packages("shiny")
library(shiny)


#Laying out the user-interface: basics
#basic_layout.R

# Define UI ----
ui <- fluidPage(titlePanel("title panel"),
                
                sidebarLayout(
                  sidebarPanel("sidebar panel"),
                  mainPanel(
                    h1("This is the main heading for my app"),
                    h2("here is a subheading"),
                    p("This website will be to help planners assess potential windfarm
           development areas in Cumbria, and achieve a ",strong("balance"),
           "between different", em("interest groups"),"and other users."
                  ))))

# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
