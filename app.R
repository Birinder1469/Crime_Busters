# Load packages
library(shiny)
suppressPackageStartupMessages(library(tidyverse))
library(ggplot2)
library(RColorBrewer)
library(gridExtra)
library(forcats)
library(shinyhelper)

# Load Data
crime_data <- read.csv('data//ucr_crime_1975_2015_Final_Clean.csv',stringsAsFactors = FALSE)

# Define UI for application that draws a histogram

ui <- fluidPage(
  # Application title
  titlePanel("CrimeBusters"),
  tags$p("Simple filtering application focusing on USA crime statistics in local regions"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(width = 3,
      sliderInput(inputId = 'yearInput', label = 'Select year range',
                  min = 1975, max = 2014, value = c(1975,1995), sep = ""),

      uiOutput('state'),

      uiOutput('department'),

      selectInput(inputId = "countMeasure",
                  label = "Count Metric",
                  choices = c("Total Counts", "Counts per 100k")),

      checkboxGroupInput(inputId = "crimeTypeInput",
                         label = "Select Crime Type(s)",
                         choiceNames = c("Assault", 'Homicide', 'Rape', 'Robbery'),
                         choiceValues = sort(unique(crime_data$crime_type)),
                         selected = unique(crime_data$crime_type)[1])),




    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("graphs"),
      tableOutput('State_Crime_Data'))

  )
)


# Define server logic
server <- function(input, output) {

  observe_helpers()

  # Reactive data selection
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

      } %>%
      mutate(count_ratio=counts/total_crime_count) %>%
      mutate(crime_type = case_when(crime_type == "aggressive_assault" ~ "Assault",
                                    crime_type == "homicide" ~ "Homicide",
                                    crime_type == "rape" ~ "Rape",
                                    crime_type == "robbery" ~ "Robbery")) %>%
      mutate(crime_type = fct_reorder(crime_type, counts, .desc = TRUE)))

  color_map = c("Assault" = "#F8766D", "Homicide" = "#7CAE00", "Rape" = "#00BFC4", "Robbery" = "#C77CFF")

  # Create plots
  occurance_lineplot <- reactive({
    crime_data_selected () %>%
      ggplot(aes(year,counts, group = interaction(department_name, crime_type), color = crime_type))+
      geom_line(size = 1.25)+
      geom_point(size = 2)+
      labs(x = "Year",
           y = "#Crimes",
           title = "Number of crimes")+
      scale_color_manual(values = color_map)+
      theme_minimal()+
      theme(legend.position = "none",plot.title = element_text(size=20))
  })


  ratio_plot <- reactive({
    crime_data_selected () %>%
      ggplot(aes(as.factor(year),count_ratio, fill=crime_type))+
      geom_bar(stat = 'identity')+
      labs(x = "Year",
           y = "Proportion Of Crimes",
           title = "Proportion of crimes",
           fill = "Crime Type")+
      scale_fill_manual(values = color_map)+
      theme_minimal()+
      theme(axis.text.x = element_text(angle = 70, vjust = 0.5),
            legend.position = "bottom", plot.title = element_text(size=20))
  })

  # Calculate summary stats
  summary_table <- reactive({
    crime_data_selected() %>%
      filter(year == max(year) | year == min(year)) %>%
      group_by(crime_type) %>%
      mutate(net_diff = counts - lag(counts),
             perc_diff = (count_ratio - lag(count_ratio))*100,
             time_diff = year-lag(year)) %>%
      mutate(avg_annual_diff = net_diff/time_diff,
             avg_annual_perc_diff = perc_diff/time_diff) %>%
      select(crime_type, net_diff, perc_diff, avg_annual_diff, avg_annual_perc_diff) %>%
      filter(!is.na(net_diff)) %>%
      rename("Crime Type" = crime_type,
             "Net change in time interval" = net_diff,
             "Net percent change in time intervel (%)" = perc_diff,
             "Average annual change" = avg_annual_diff,
             "Average percent annual change (%)" = avg_annual_perc_diff)
  })

  # Output componenets
  output$state <- renderUI(
    selectInput(inputId = 'Selected_State',
                label = 'Select the US State',
                choices = sort(unique(crime_data$US_State))))

  output$department <- renderUI(
    if (is.null(input$Selected_State) || input$Selected_State == ""){return()}
    else selectInput(inputId = 'Selected_Department',
                     label = 'Select Police Department',
                     choices = unique(c(crime_data$department_name[which(crime_data$US_State == input$Selected_State)])))
  )

  output$graphs <- renderPlot(grid.arrange(occurance_lineplot(), ratio_plot(), ncol = 2))

  output$State_Crime_Data <- renderTable(summary_table())

}

# Run the application
shinyApp(ui = ui, server = server)
