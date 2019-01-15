
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
      selectInput(inputId = 'Selected_State',label = 'Select the US State',choices = c('All',crime_data$US_State)),
 
      selectInput(inputId = 'Selected_Department',label = 'Select the Department within the State',choices = c('All',crime_data$department_name)),
      
      
      checkboxGroupInput('Select_Crime', label = h3('Crime Type :'), choices = list('Rape','Assault','Robbery','Homicide'))
      
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("lineplot"),
      tableOutput('State_Crime_Data'),
      tableOutput('check_mark')
      
    )
  )
)


# Define server logic required to draw a histogram
server <- function(input, output, session) {
 
  

  crime_data_latest <- reactive(
    crime_data %>% 
      filter(US_State==input$Selected_State) %>% 
      filter(department_name==input$Selected_Department) %>%
      select(c('Department_Name'='department_name','US_State','rape_per_100k')) %>% 
      head()
  )


  

  
  output$State_Crime_Data <- renderTable(crime_data_latest())

 
  
  
    
}

# Run the application 
shinyApp(ui = ui, server = server)

}

