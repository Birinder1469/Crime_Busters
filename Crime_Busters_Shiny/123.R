#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
suppressPackageStartupMessages(library(tidyverse))
library(ggplot2)
crime_data <- read.csv('ucr_crime_1975_2015_Final_Clean.csv',stringsAsFactors = FALSE)

# Define UI for application that draws a histogram
ui <-  fluidPage(
  titlePanel("CrimeBusters"),
  
  sidebarLayout(
    
    sidebarPanel (
      # Create a new Row in the UI for selectInputs
      
      
      selectInput("Selected_state",
                  "Selected the State",
                  c("All",
                    unique(as.character(crime_data$US_State)))),
      
      
      selectInput("Selected_department",
                  "Selected the Department",
                  c("All",
                    unique(as.character(crime_data$department_name)))),
      
      
      
      conditionalPanel(
        checkboxGroupInput('Select_Crime', 
                           label = h3('Crime Type :'),
                           choices = c('Rape','Assault','Robbery','Homicide'))
      )
      
    ),
    
    mainPanel (
      # Create a new row for the table.
      DT::dataTableOutput("table"),
      DT::dataTableOutput("table1")
      
      
    )
  )
  
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- crime_data
    if (input$Selected_state != "All") {
      data <- data[data$US_State == input$Selected_state,]
    }
    if (input$Selected_department != "All") {
      data <- data[data$department_name == input$Selected_department,]
    }
    
    data
    
  }))
  
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

