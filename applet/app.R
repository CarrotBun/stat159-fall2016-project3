

library(shiny)
library(ggplot2)
library(dplyr)
library(glmnet)
library(tidyr)

#setwd("~/stat159/project3/applet/")

## Load Data files
load("../data/RData-files/scaled-colleges.RData")
load("../data/RData-files/colleges.RData")
college_data <- data
college_scaled <- scaled_colleges
source("../code/functions/cleaning-helpers.R")

college_data <- factor_this(college_data)

## Variables for selection menu
varlist <- list(
  "Admission Rate" = 23,
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
  "Race - Nonresident Alien" = 14
)
varnames <- list(
  "Admission Rate" = "avgAdmRate",
  "Size" = "avgSize",
  "Age at entry" = "avgAgeEntry",
  "Gender - % Women" = "avgWomen",
  "Marrital Status" = "avgMarried",
  "First Generation" = "avgFirstGen",
  "Family Income" = "avgFamilyInc",
  "SAT Reading" = c("avgSATVR25", "avgSATVR75"),
  "SAT Math" = c("avgSATMT25", "avgSATMT75"),
  "SAT Writing" = c("avgSATWR25", "avgSATWR75"),
  "Completion Rate" = "avgCompletion",
  "Transfer Rate" = "avgTransfer",
  "Race - White" = "avgWhite",
  "Race - Black" = "avgBlack",
  "Race - Hispanic" = "avgHisp",
  "Race - Asian" = "avgAsian",
  "Race - American Native/Alaska Native" = "avgAIAN",
  "Race - Native Hawaiian/Pacific Islander" = "avgNHPI",
  "Race - 2 or more races" = "avg2MOR",
  "Race - Nonresident Alien" = "avgForeign"
)

varnames_original <- list(
  "Admission Rate" = "avgAdmRate",
  "Size" = "avgSize",
  "Age at entry" = "avgAgeEntry",
  "Gender - % Women" = "avgWomen",
  "Marrital Status" = "avgMarried",
  "First Generation" = "avgFirstGen",
  "Family Income" = "avgFamilyInc",
  "SAT Reading" = "avgSATVR75",
  "SAT Math" = "avgSATMT75",
  "SAT Writing" = "avgSATWR75",
  "Completion Rate" = "avgCompletion",
  "Transfer Rate" = "avgTransfer",
  "Race - White" = "avgWhite",
  "Race - Black" = "avgBlack",
  "Race - Hispanic" = "avgHisp",
  "Race - Asian" = "avgAsian",
  "Race - American Native/Alaska Native" = "avgAIAN",
  "Race - Native Hawaiian/Pacific Islander" = "avgNHPI",
  "Race - 2 or more races" = "avg2MOR",
  "Race - Nonresident Alien" = "avgForeign",
  "State" = "ST_FIPS",
  "SAT Reading" = "SATVR25",
  "SAT Math" = "SATMT25",
  "SAT Writing" = "SATWR25",
  "Setting" = "LOCALE",
  "College Classification" = "CCUGPROF"
)


## Summarize variables grouping by year, taking mean
avgAllVars <- function(table) {
  summarize(
    group_by(table,
             OPEID, INSTNM, CITY, STABBR, ZIP, LOCALE, CCUGPROF),
    avgSize = mean(UGDS, na.rm = TRUE),
    avgWhite = mean(UGDS_WHITE, na.rm = TRUE),
    avgBlack = mean(UGDS_BLACK, na.rm = TRUE),
    avgHisp = mean(UGDS_HISP, na.rm = TRUE),
    avgAsian = mean(UGDS_ASIAN, na.rm = TRUE),
    avgAIAN = mean(UGDS_AIAN, na.rm = TRUE),
    avgNHPI = mean(UGDS_ASIAN, na.rm = TRUE),
    avg2MOR = mean(UGDS_2MOR, na.rm = TRUE),
    avgForeign = mean(UGDS_NRA, na.rm = TRUE),
    avgAgeEntry = mean(AGE_ENTRY, na.rm = TRUE),
    avgWomen = mean(UGDS_WOMEN, na.rm = TRUE),
    avgMarried = mean(MARRIED, na.rm = TRUE),
    avgFirstGen = mean(FIRST_GEN, na.rm = TRUE),
    avgAdmRate = mean(ADM_RATE, na.rm = TRUE),
    avgSATVR25 = mean(SATVR25, na.rm = TRUE),
    avgSATVR75 = mean(SATVR75, na.rm = TRUE),
    avgSATMT25 = mean(SATMT25, na.rm = TRUE),
    avgSATMT75 = mean(SATMT75, na.rm = TRUE),
    avgSATWR25 = mean(SATWR25, na.rm = TRUE),
    avgSATWR75 = mean(SATWR75, na.rm = TRUE),
    avgFamilyInc = mean(FAMINC, na.rm = TRUE),
    avgCompletion = mean(UGDS_WOMEN, na.rm = TRUE),
    avgTransfer = mean(MARRIED, na.rm = TRUE)
  )
}

ui <- fluidPage(
  titlePanel("College Admissions"),
  
  ## Main Display
  tabsetPanel(
    tabPanel("Plot", plotOutput("statePlot")),
    tabPanel("Summary", verbatimTextOutput("summary")),
    tabPanel("Table", tableOutput("table")),
    tabPanel("Suggestions", verbatimTextOutput("suggestions")),
    tabPanel("Comparisons Table", tableOutput("comparisons")),
    tabPanel("Comparison Plots",plotOutput("compPlot"))
  ),
  
  h3("Simple School Lookup"),
  
  fluidRow(
    column(
      3,
      # Basic filter menu
      h4("Attribute Filter"),
      selectInput("selState", "State:", unique(college_data$STABBR)),
      sliderInput(
        "SizeRange",
        "Size",
        min = 0,
        max = max(college_data$UGDS),
        value = c(1, 1000)
      ),
      sliderInput(
        "ARRange",
        "Admissions Rate Range",
        min = 0,
        max = 1,
        value = c(0.25, 0.75)
      )
    ),
    column(
      4,
      offset = 1,
      # Table variable selection
      selectInput(
        "selTvar",
        multiple = TRUE,
        label = "Table Output - variable selection",
        choices = varnames
      )
    ),
    column(
      4,
      h4("Plot Components"),
      selectInput("selGeomX",
                  label = "X variable",
                  choices = varnames),
      selectInput("selGeomY",
                  label = "Y variable",
                  choices = varnames)
    )
  ),
  br(),
  h3("School Improvement Suggestion"),
  br(),
  fluidRow(
    column(
      3,
      selectInput(
        "selTschool",
        label = "Pick Target School",
        choices = unique(college_data$OPEID)
      )
    ),
    column(
      4,
      offset = 1,
      h4("Prediction Criteria"),
      #numericInput("SizeRange",
      #              label ="Size Range",
      #             value = 1000),
      selectInput(
        "selCvar",
        multiple = TRUE,
        label = "Select Factors for Table/Prediction (choose at least 2)",
        choices = varnames[-1],
        selected = c("avgSize", "avgAgeEntry")
      )
      
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  ## Data used for basic plot and table
  collegeData <- reactive({
    avgAllVars(
      filter(
        college_data,
        STABBR == input$selState,
        ADM_RATE >= input$ARRange[1],
        ADM_RATE <= input$ARRange[2],
        UGDS >= input$SizeRange[1],
        UGDS <= input$SizeRange[2]
      )
    )
    
  })
  
  # Find the target school's information
  target_school <- reactive({
    filter(avgAllVars(college_data), OPEID == input$selTschool)
    
  })
  
  # Filter schools according to admission rates
  suggest_data <- reactive({
    #avgAllVars(college_data)
    filter(avgAllVars(college_data),
           avgAdmRate <= target_school()[, "avgAdmRate"])[, c("OPEID",
                                                              "INSTNM",
                                                              "CITY",
                                                              "STABBR",
                                                              "ZIP",
                                                              input$selCvar,
                                                              "avgAdmRate")]
  })
  
  # Sample 20 schools 
  school_sample  <- function() {
    set.seed(987654321)
    sample_vec <- sample(1:nrow(suggest_data()), 20, replace = TRUE)
    samp <- suggest_data()[sample_vec, ]
    rbind(target_school()[, c("OPEID",
                              "INSTNM",
                              "CITY",
                              "STABBR",
                              "ZIP",
                              input$selCvar,
                              "avgAdmRate")],
          samp)
  }
  
  
  # Regression using Lasso
  regress <- function(data) {
    nona = complete.cases(data)
    print(paste("Numeber of variables selected:" , ncol(data)-1))
    x_train = as.matrix(data[nona,-ncol(data)])
    y_train = as.vector(data[nona, ncol(data)])
    grid = 10 ^ seq(10,-2, length = 100)
    lasso_train = cv.glmnet(
      x = x_train,
      y = y_train,
      intercept = FALSE,
      standardize = FALSE,
      lambda = grid
    )
    best_lam = lasso_train$lambda.min
    
    predict(lasso_train, as.matrix(data[1,-c(ncol(data))]), s = best_lam)
    
  }
  
  # Select regular column based on avgColumns selection choices
  select_cols <- function(cols) {
    columns <- c()
    original_names <-
      c(
        "UGDS","UGDS_WHITE","UGDS_BLACK","UGDS_HISP","UGDS_ASIAN",
        "UGDS_AIAN","UGDS_NHPI","UGDS_2MOR","UGDS_NRA","UGDS_UNKN",
        "AGE_ENTRY","UGDS_WOMEN","MARRIED","FIRST_GEN","FAMINC"
      )
    # Avg column names
    quantcols <-
      c("avgSize","avgWhite","avgBlack","avgHisp",
        "avgAsian","avgAIAN","avgNHPI","avg2MOR",
        "avgForeign","unknown","avgAgeEntry","avgWomen",
        "avgMarried","avgFirstGen","avgFamilyInc"
      )
    avgCTrate <- c("avgCompletion", "avgTransfer")
    
    for (name in cols) {
      if (name %in% quantcols) {
        columns = c(columns, original_names[name == quantcols])
      }
      # State selection
      if (name == "ST_FIPS") {
        columns = c(
          columns,
          "ST_FIPS2", "ST_FIPS4","ST_FIPS5","ST_FIPS6",
          "ST_FIPS8","ST_FIPS9","ST_FIPS10","ST_FIPS11",
          "ST_FIPS12","ST_FIPS13", "ST_FIPS15","ST_FIPS16",
          "ST_FIPS17", "ST_FIPS18", "ST_FIPS19","ST_FIPS20",
          "ST_FIPS21","ST_FIPS22","ST_FIPS23", "ST_FIPS24",
          "ST_FIPS25","ST_FIPS26","ST_FIPS27","ST_FIPS28",
          "ST_FIPS29","ST_FIPS30","ST_FIPS31","ST_FIPS32",
          "ST_FIPS33","ST_FIPS34", "ST_FIPS35","ST_FIPS36",
          "ST_FIPS37","ST_FIPS38","ST_FIPS39","ST_FIPS40",
          "ST_FIPS41","ST_FIPS42", "ST_FIPS44","ST_FIPS45",
          "ST_FIPS46","ST_FIPS47","ST_FIPS48","ST_FIPS49",
          "ST_FIPS50","ST_FIPS51","ST_FIPS53", "ST_FIPS54",
          "ST_FIPS55","ST_FIPS56","ST_FIPS64","ST_FIPS66",
          "ST_FIPS68","ST_FIPS72","ST_FIPS78"
        )
        # SAT Reading variables
      } else if (name == "avgSATVR75") {
        columns = c(columns, "SATVR25", "SATVR75")
        
        # SAT Math variables
      } else if (name == "avgSATMT75") {
        columns = c(columns, "SATMT25", "SATMT75")
        
        # SAT Writing variables
      } else if (name == "avgSATWR75") {
        columns = c(columns, "SATWR25", "SATWR75")
        
        # Completion and transfer rate
      } else if (name %in% avgCTrate) {
        compInfo = c("completion", "transfer")
        columns = c(columns, compInfo[name == c("avgCompletion", "avgTransfer")])
        
        #Setting
      } else if (name == "LOCALE") {
        columns = c(
          columns,"LOCALE11","LOCALE12","LOCALE13","LOCALE21",
          "LOCALE22","LOCALE23","LOCALE31","LOCALE32","LOCALE33",
          "LOCALE41","LOCALE42","LOCALE43"
        )
        
        #College Classification
      } else if (name == "CCUGPROF") {
        colums = c(
          columns,
          "CCUGPROF0","CCUGPROF1","CCUGPROF2","CCUGPROF3",
          "CCUGPROF4","CCUGPROF5","CCUGPROF6","CCUGPROF7",
          "CCUGPROF8","CCUGPROF9","CCUGPROF10","CCUGPROF11",
          "CCUGPROF12","CCUGPROF13","CCUGPROF14","CCUGPROF15"
        )
      }
    }
    
    columns
    
  }
  
  # Basic Plot
  output$statePlot <- renderPlot({
    pData<- data.frame(sapply(collegeData()[, c(input$selGeomX, input$selGeomY)],as.numeric))
    #pData <- data.frame(sapply(pData, as.numeric))
    
    plotSimple <-
      ggplot(pData, aes(x = pData[,1], y = pData[,2])) +
      geom_point()+
      stat_smooth(method = "lm", col = "#D55E00") + 
      labs(x = input$selGeomX, y = input$selGeomY) 
    
    plotSimple
  })
  
  # Summary ouput of all the schools that fit the basic filter
  output$summary <- renderPrint({
    summary(collegeData()[, -(1:7)], na.rm = TRUE)
  })
  
  # Table of all the schools that fit the basic filter
  output$table <- renderTable({
    collegeData()[, c("OPEID", "INSTNM", "CITY", "STABBR", "ZIP", input$selTvar)]
  }, hover = TRUE)
  
  # Suggestion of impovement
  output$suggestions <- renderPrint({
    print(paste("Focus/Target school ID is",input$selTschool))
    print(paste("Variables considered:", input$selCvar))

    ids <- unique(school_sample()$OPEID)
    sampRows <-
      filter(college_shiny, OPEID %in% ids)[, -c(1:6)][, c(select_cols(input$selCvar), "ADM_RATE")]
    print("Using similar's schools' statistics, our prediction model yields:")
    
    unscale(regress(sampRows), college_scaled)[-c(1:113)]

    
  })
  
  output$comparisons <- renderTable({
    school_sample()
  }, hover = TRUE)
  
  output$compPlot <- renderPlot({
    school_df = school_sample()
    school_df$Target = c(1, rep(0,20))
    tb = gather(school_df, key = Type, value = Value, -OPEID,  -INSTNM, -CITY, -STABBR, -ZIP, -Target)
    tb$Type = as.factor(tb$Type)
    
    ggplot() +
      geom_bar(data= tb, aes(x = OPEID, y = Value,col = OPEID, fill = OPEID), stat= "identity") +
      facet_grid(Type~Target, scales = "free") +
      labs(x = "OPEID", y = input$selPvar) + 
      theme(axis.text.x = element_blank())
    
  })

}

# Run the application
shinyApp(ui = ui, server = server)
