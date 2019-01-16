
library(shiny)
suppressPackageStartupMessages(library(tidyverse))
library(ggplot2)
crime_data <- read.csv('..//data//ucr_crime_1975_2015_Final_Clean.csv',stringsAsFactors = FALSE)

View(crime_data)
# Define UI for application that draws a histogram

ui <- fluidPage(
  # Application title
  titlePanel("CrimeBusters"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = 'yearInput', label = 'Select year range',
                  min = 1975, max = 2014, value = c(1975,1980), sep = ""),
      
      selectInput(inputId = 'Selected_State',
                  label = 'Select the US State',
                  choices = crime_data$US_State),
      
      
      
      selectInput(inputId = 'Selected_Department',
                  label = 'Select the Department within the State',
                  choices = crime_data$department_name),
      
      selectInput(inputId = "countMeasure", 
                  label = "Count Measurements",
                  choices = c("Total Counts", "Counts per 100k")),
      
      checkboxGroupInput(inputId = "crimeTypeInput",
                         label = "Select Crime Type(s)",
                         choices = unique(crime_data$crime_type),selected = 'rape')
    
      
      
      ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("occurance_lineplot"),
      plotOutput('ratio_plot'),
      tableOutput('State_Crime_Data'),
      tableOutput('State_Crime_Data_New'),
      textOutput('value')
      
    )
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  
  
  
  
  crime_data_selected <- reactive(
    crime_data %>% 
      filter(US_State==input$Selected_State) %>% 
      filter(year >= input$yearInput[1] & year <= input$yearInput[2]) %>% 
      filter(department_name==input$Selected_Department) %>% 
      filter(crime_type%in%input$crimeTypeInput) %>% 
      { if(input$countMeasure == "Total Counts") select(.,c('year',
                                                            'US_State',
                                                            'department_name',
                                                            'total_crime_count',
                                                            'crime_type',
                                                            'counts'))
        else select(., c('year',
                        'US_State',
                        'department_name',
                         total_crime_count='total_crime_per_100k',
                        'crime_type',
                        counts = 'counts_per_100k'))
        
      })
  
  crime_data_ratio <- reactive(
                              crime_data %>% 
                                filter(US_State==input$Selected_State) %>% 
                                filter(year>=input$yearInput[1] & year<=input$yearInput[2]) %>% 
                                filter(department_name==input$Selected_Department) %>% 
                                filter(crime_type%in%input$crimeTypeInput) %>% 
                                mutate(total_ratio=counts/total_crime_count, per_100_ratio = counts_per_100k/total_crime_per_100k ) %>% 
                                { if(input$countMeasure == "Total Counts") select(.,c('year',
                                                                                      'US_State',
                                                                                      'department_name',
                                                                                      'total_crime_count',
                                                                                      'crime_type',
                                                                                      'counts',
                                                                                      count_ratio='total_ratio'))
                                  else select(., c('year',
                                                   'US_State',
                                                   'department_name',
                                                   total_crime_count='total_crime_per_100k',
                                                   'crime_type',
                                                   counts = 'counts_per_100k',
                                                   count_ratio='per_100_ratio'
                                                   ))
                                  
                                })
  
  
 
  output$occurance_lineplot <- renderPlot(
    crime_data_selected () %>% 
      ggplot(aes(year,counts))+
      geom_line(aes(color = crime_type))+
      labs(x = "Year",
           y = "#Crimes",
           title = "Number of crimes overtime")+
      theme_minimal())
  
  output$ratio_plot <- renderPlot(
    crime_data_ratio () %>% 
      ggplot(aes(as.factor(year),count_ratio,fill=crime_type))+
      geom_bar(stat = 'identity')+
      labs(x = "Year",
           y = "Proportion Of Total Crimes",
           title = "Number of crimes overtime")+
      theme_minimal())
  
  
  output$State_Crime_Data <- renderTable(crime_data_selected())
  #output$State_Crime_Data_New <- renderTable(crime_data_ratio())
  
}

# Run the application 
shinyApp(ui = ui, server = server)



