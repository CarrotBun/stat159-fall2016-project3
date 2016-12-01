
library(shiny)
library(ggplot2)
library(dplyr)
library(glmnet)

#setwd("~/stat159/project3/applet/")
college_data <- read.csv("../data/datasets/colleges.csv")
college_scaled <- read.csv("../data/datasets/scaled-colleges.csv")
varlist <- list("Admission Rate" = 23, 
                "Size" = 6, 
                "Age at entry" = 16, 
                "Gender - % Women" = 17, 
                "Marrital Status" = 18,
                "First Generation" = 19,
                "Family Income" = 20, 
                "SAT Scores" = 24, 
                "Completion Rate" = 30,
                "Transfer Rate" = 31,
                "Race - White" = 7,
                "Race - Black" = 8,
                "Race - Hispanic" = 9, 
                "Race - Asian" = 10, 
                "Race - American Native/Alaska Native" = 11,
                "Race - Native Hawaiian/Pacific Islander" = 12,
                "Race - 2 or more races" = 12,
                "Race - Nonresident Alien" = 14)
varnames <- list("Admission Rate" = "avgAdmRate", 
                "Size" = "avgSize", 
                "Age at entry" = "avgAgeEntry",
                "Gender - % Women" = "avgWomen", 
                "Marrital Status" = "avgMarried",
                "First Generation" = "avgFirstGen",
                "Family Income" = "avgFamilyInc", 
                "SAT Scores" = "avgSATVR25", 
                "Completion Rate" = "avgCompletion",
                "Transfer Rate" = "avgTransfer",
                "Race - White" = "avgWhite",
                "Race - Black" = "avgBlack",
                "Race - Hispanic" = "avgHisp", 
                "Race - Asian" = "avgAsian", 
                "Race - American Native/Alaska Native" = "avgAIAN",
                "Race - Native Hawaiian/Pacific Islander" = "avgNHPI",
                "Race - 2 or more races" = "avg2MOR",
                "Race - Nonresident Alien" = "avgForeign")

avgAllVars <- function(table){
  summarize(
    group_by(
      table,
      OPEID, INSTNM, CITY, STABBR, ZIP
    ),
    avgSize = mean(UGDS, na.rm = TRUE),
    avgWhite = mean(UGDS_WHITE, na.rm = TRUE),
    avgBlack = mean(UGDS_BLACK, na.rm = TRUE),
    avgHisp = mean(UGDS_HISP, na.rm=TRUE),
    avgAsian = mean(UGDS_ASIAN, na.rm=TRUE),
    avgAIAN = mean(UGDS_AIAN, na.rm=TRUE),
    avgNHPI = mean(UGDS_ASIAN, na.rm=TRUE),
    avg2MOR = mean(UGDS_2MOR, na.rm=TRUE),
    avgForeign = mean(UGDS_NRA, na.rm=TRUE),
    avgAgeEntry = mean(AGE_ENTRY, na.rm =TRUE),
    avgWomen = mean(UGDS_WOMEN, na.rm = TRUE),
    avgMarried = mean(MARRIED, na.rm =TRUE),
    avgFirstGen = mean(FIRST_GEN, na.rm = TRUE),
    avgAdmRate = mean(ADM_RATE, na.rm = TRUE),
    avgSATVR25 = mean(SATVR25, na.rm=TRUE),
    avgSATVR75 = mean(SATVR75, na.rm=TRUE),
    avgSATMT25 = mean(SATMT25, na.rm=TRUE),
    avgSATMT75 = mean(SATMT75, na.rm=TRUE),
    avgSATWR25 = mean(SATWR25, na.rm=TRUE),
    avgSATWR75 = mean(SATWR75, na.rm =TRUE),
    avgFamilyInc = mean(FAMINC, na.rm = TRUE),
    avgCompletion = mean(UGDS_WOMEN, na.rm = TRUE),
    avgTransfer = mean(MARRIED, na.rm =TRUE)
  )
}
ui <- fluidPage(
   titlePanel("College Admissions"),
   
   tabsetPanel(
     tabPanel("Plot", plotOutput("statePlot")), 
     tabPanel("Summary", verbatimTextOutput("summary")), 
     tabPanel("Table", tableOutput("table")),
     tabPanel("Suggestions", verbatimTextOutput("suggestions")),
     tabPanel("Comparisons", tableOutput("comparisons"))
   ),
   
   h3("Simple School Lookup"),
   
   fluidRow(
     column(3,
            h4("Attribute Filter"),
            selectInput("selState", "State:", unique(college_data$STABBR)),
            selectInput("selLocale", "Setting:", c("City"=1, "Suburb"=2,"Town"=3, "Rural"=4)),
            sliderInput("SizeRange", "Size", min = 0, max = max(college_data$UGDS),value = c(1,1000)),
            sliderInput("ARRange", "Admissions Rate Range", min = 0, max = 1, value = c(0.25,0.75))
            ),
     column(4, offset = 1,
            selectInput("selTvar", multiple = TRUE,
                               label = "Table Output - variable selection", 
                               choices = varnames)
     ),
     column(4,
            h4("Plot Components"),
            selectInput("selGeomX",
                        label = "X variable", 
                        choices = varnames),
            selectInput("selGeomY",
                        label = "Y variable", 
                        choices = varnames),
            selectInput("selGeomLine",
                        label = "Include linear regression line?",
                        choices = c("Yes" = TRUE,  "No" = FALSE), selected = FALSE)
     )
   ),
   br(),
   h3("School Improvement Suggestion"),
   br(),
   fluidRow(
     column(3,
            selectInput("selTschool",
                        label = "Pick Target School", 
                        choices = unique(college_data$OPEID))
     ),
     column(4, offset = 1,
            selectInput("selCvar", multiple = TRUE,
                        label = "Select Focus Factors", 
                        choices = varnames)
     ),
     column(4,
            numericInput("SizeRange", 
                         label ="Size Range", 
                         value = 1000)
     )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  data <- reactive({
    avgAllVars(filter(college_data, STABBR == input$selState,
                      ADM_RATE >= input$ARRange[1], 
                      ADM_RATE <= input$ARRange[2],
                      UGDS >= input$SizeRange[1],
                      UGDS <= input$SizeRange[2]))
    
  })
  
  target_school <- reactive({
    avgAllVars(
        filter(college_data, OPEID == input$selTschool))
  })
  
  suggest_data <- reactive({
      avgAllVars(filter(college_data, ADM_RATE >= target_school()$avgAdmRate,
             UGDS >= target_school()$avgSize-input$SizeRange,
             UGDS <= target_school()$avgSize+input$SizeRange))[,c("OPEID","INSTNM", "CITY","STABBR","ZIP", input$selCvar)]
  })
  
  
  output$statePlot <- renderPlot({
    plotSimple <- ggplot(data()) + geom_point(aes(x = data()[,input$selGeomX], 
                                    y = data()[,input$selGeomY])) +
      labs(x=input$selGeomX, y= input$selGeomY )
    if (input$selGeomLine){
      plotSimple <- plotSimple + stat_smooth(method = "lm", col = "navy")
    }
    
    plotSimple
  })
  
  output$summary <- renderPrint({
    summary(data()[,-(1:5)], na.rm =TRUE)
  })
  
  output$table <- renderTable({
    data()[,c("OPEID","INSTNM", "CITY","STABBR","ZIP", input$selTvar)]
  }, hover = TRUE)
  
  output$suggestions <- renderPrint({
    
  })
  
  output$comparisons <- renderTable({
    sample_vec <- sample(1:nrow(suggest_data()),10, replace= TRUE)
    suggest_data()[sample_vec,]
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

