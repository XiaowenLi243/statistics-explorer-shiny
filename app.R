#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

source("helpers.R")

# 1. User interface
ui <- fluidPage(
  
  titlePanel("Statistics Explorer V2"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      fileInput(
        "file",
        "Upload a CSV file:",
        accept = ".csv"
      ),
      
      selectInput(
        "chart_type",
        "Choose chart type:",
        choices = c("Histogram", "Scatter Plot")
      ),
      
      uiOutput("variable_selector"),
      uiOutput("y_variable_selector"),
      
      conditionalPanel(
        condition = "input.chart_type == 'Histogram'",
        
        sliderInput(
          "bins",
          "Number of bins:",
          min = 5,
          max = 50,
          value = 20
        )
      )
    ),
    
    mainPanel(
      h3("Data Visualisation"),
      plotOutput("histogram"),
      
      hr(),
      
      h3("Statistical Summary"),
      verbatimTextOutput("statistics"),
      
      hr(),
      
      h3("Data Preview"),
      tableOutput("preview")
    )
  )
)

# 2. Server
server <- function(input, output) {
  
  # Prepare data when a file is uploaded
  
  dataset <- reactive({
    
    if (is.null(input$file)) {
      return(iris)
    }
    
    data <- tryCatch(
      read.csv(input$file$datapath),
      error = function(e) NULL
    )
    
    validate(
      need(!is.null(data), "Unable to read CSV file.")
    )
    
    validate(
      need(nrow(data) > 0, "The CSV file is empty.")
    )
    
    numeric_columns <- vapply(
      data, is.numeric, logical(1)
    )
    
    validate(
      need(
        any(numeric_columns),
        "The CSV must contain a numeric column."
      )
    )
    
    data
  })
  
  
  # Create a variable selector
  output$variable_selector <- renderUI({
    
    data <- dataset()
    
    numeric_columns <- names(data)[
      sapply(data, is.numeric)
    ]
    
    validate(
      need(
        length(numeric_columns) > 0,
        "No numeric columns found."
      )
    )
    
    selectInput(
      "variable",
      "Choose a variable:",
      choices = numeric_columns
    )
  })
  
  output$y_variable_selector <- renderUI({
    
    req(input$chart_type == "Scatter Plot")
    
    data <- dataset()
    
    numeric_columns <- names(data)[
      sapply(data, is.numeric)
    ]
    
    selectInput(
      "y_variable",
      "Choose Y variable:",
      choices = numeric_columns,
      selected = tail(numeric_columns, 1)
    )
  })
  
  # Draw a histogram
  output$histogram <- renderPlot({
    
    data <- dataset()
    
    req(input$variable)
    req(input$variable %in% names(data))
    
    x <- data[[input$variable]]
    
    if (input$chart_type == "Histogram") {
      
      x <- finite_values(x)
      
      validate(
        need(length(x) > 0, "No valid data to plot.")
      )
      
      hist(
        x,
        breaks = input$bins,
        main = input$variable,
        xlab = input$variable
      )
      
    } else {
      
      req(input$y_variable)
      req(input$y_variable %in% names(data))
      
      y <- data[[input$y_variable]]
      
      valid <- valid_pairs(x, y)
      
      validate(
        need(any(valid), "No valid data pairs to plot.")
      )
      
      plot(
        x[valid],
        y[valid],
        main = "Scatter Plot",
        xlab = input$variable,
        ylab = input$y_variable,
        pch = 19
      )
    }
  })
  
  # Display descriptive statistics
  output$statistics <- renderPrint({
    
    data <- dataset()
    req(input$variable)
    req(input$variable %in% names(data))
    
    values <- data[[input$variable]]
    
    validate(
      need(is.numeric(values), "Select a numeric variable.")
    )
    
    print(summary(values))
    cat("\nMissing values:", sum(is.na(values)))
    cat("\nValid values:", sum(is.finite(values)))
    
    clean_values <- finite_values(values)
    
    cat(
      "\nStandard Deviation:",
      sd(clean_values, na.rm = TRUE)
    )
  })
  
  # Preview uploaded data
  output$preview <- renderTable({
    head(dataset(), 6)
  })
  
}

shinyApp(ui = ui, server = server)
