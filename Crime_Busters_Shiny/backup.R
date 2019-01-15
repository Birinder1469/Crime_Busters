
library(shiny)
suppressPackageStartupMessages(library(tidyverse))
library(ggplot2)
crime_data <- read.csv('ucr_crime_1975_2015_Final_Clean.csv',stringsAsFactors = FALSE)

# Define UI for application that draws a histogram


if (interactive())
{
  ui <- fluidPage(
    # Application title
    titlePanel("CrimeBusters"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
      sidebarPanel(
        selectInput(inputId = 'Selected_State',label = 'Select the US State',choices = crime_data$US_State),
        #selectInput('variable','Variable : ', c('US'='US_State','Dep'='department_name'))
        
        selectInput(inputId = 'Selected_Department',label = 'Select the Department within the State',choices = crime_data$department_name)
        
        
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        plotOutput("lineplot"),
        tableOutput('State_Crime_Data')
        uiOutput('SecondSelection')
      )
    )
  )
  
  
  # Define server logic required to draw a histogram
  server <- function(input, output, session) {
    
    crime_data_latest <- reactive(
      crime_data %>% 
        filter(US_State==input$Selected_State) %>% 
        filter(department_name==input$Selected_Department) %>% 
        select(c('Department_Name'='department_name','US_State','violent_per_100k','homs_per_100k','rape_per_100k','rob_per_100k','agg_ass_per_100k')) %>% 
        head()
    )
    
    output$State_Crime_Data <- renderTable(crime_data_latest())
    #  output$SecondSelection <- renderUI({  selectInput('Selected_Department', choices = crime_data[input$Selected_State=='department_name'],'aa' )})
    
  }
  
  # Run the application 
  shinyApp(ui = ui, server = server)
  
}


#checkboxInput(inputId = 'Select_Rape',label = 'Rape',value = FALSE ),
#checkboxInput(inputId = 'Select_Assault',label = 'Assault',value = FALSE ),
#checkboxInput(inputId = 'Select_Robbery',label = 'Robbery',value = FALSE ),
#checkboxInput(inputId = 'Select_Homicide',label = 'Homicide',value = FALSE )
