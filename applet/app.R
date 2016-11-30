
library(shiny)
library(ggplot2)
library(dplyr)

#setwd("~/stat159/project3/applet/")
college_data <- read.csv("../data/datasets/colleges.csv")
college_scaled <- read.csv("../data/datasets/scaled-colleges.csv")

ui <- fluidPage(
   titlePanel("College Admissions"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         selectInput("selState", "State:", unique(college_data$STABBR)),
         selectInput("selLocale", "Setting:", c("City"=1, "Suburb"=2,"Town"=3, "Rural"=4)),
         sliderInput("SizeRange", "Size", min = 0, max = max(college_data$UGDS),value = c(1,100)),
         sliderInput("ARRange", "Admissions Rate Range", min = 0, max = 1, value = c(0.25,0.75))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(
          tabPanel("Plot", plotOutput("statePlot")), 
          tabPanel("Summary", verbatimTextOutput("summary")), 
          tabPanel("Table", tableOutput("table"))
        )
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  data <- reactive({
    filter(college_data, STABBR == input$selState,
           ADM_RATE >= input$ARRange[1], 
           ADM_RATE <= input$ARRange[2],
           UGDS >= input$SizeRange[1],
           UGDS <= input$SizeRange[2])
  })
  
  output$statePlot <- renderPlot({
    ggplot(data()) + geom_bar(aes(x = OPEID, y = ADM_RATE), stat = "identity")
  })
  
  output$table <- renderTable({
    data.frame(data()[1:10,])
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

