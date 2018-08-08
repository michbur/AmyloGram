library(shiny)
library(ggplot2)
library(AmyloGram)
library(dplyr)
library(DT)
library(shinythemes)
library(markdown)

data(AmyloGram_model)
data(spec_sens)

options(shiny.maxRequestSize=10*1024^2)

options(DT.options = list(dom = "Brtip",
                          buttons = c("copy", "csv", "excel", "print"),
                          pageLength = 50
))

my_DT <- function(x, ...)
  datatable(x, ..., escape = FALSE, extensions = 'Buttons', filter = "top", rownames = FALSE,
            style = "bootstrap")


shinyServer(function(input, output) {
  
  
  
  prediction <- reactive({
    
    if (!is.null(input[["seq_file"]]))
      input_sequences <- read_txt(input[["seq_file"]][["datapath"]])
    input[["use_area"]]
    isolate({
      if (!is.null(input[["text_area"]]))
        if(input[["text_area"]] != "")
          input_sequences <- read_txt(textConnection(input[["text_area"]]))
    })
    
    if(exists("input_sequences")) {
      if(length(input_sequences) > 50) {
        #dummy error, just to stop further processing
        stop("Too many sequences.")
      } else {
        if(any(lengths(input_sequences) < 6)) {
          #dummy error, just to stop further processing
          stop("The minimum length of the sequence is 6 amino acids.")
        } else {
          predict(AmyloGram_model, input_sequences)
        }
      }
    } else {
      NULL
    }
  })
  
  decision <- reactive({
    if(!is.null(prediction())) {
      res <- AmyloGram:::make_decision(prediction()[["overview"]], input[["cutoff"]])
      colnames(res) <- c("Input name", "Amyloid probability", "Is amyloid?")
      res
    }
  })
  
  
  output[["dynamic_ui"]] <- renderUI({
    if (!is.null(input[["seq_file"]]))
      input_sequences <- read_txt(input[["seq_file"]][["datapath"]])
    input[["use_area"]]
    isolate({
      if (!is.null(input[["text_area"]]))
        if(input[["text_area"]] != "")
          input_sequences <- read_txt(textConnection(input[["text_area"]]))
    })
    
    if(exists("input_sequences")) {
      fluidRow(
        h4("Cut-off adjustment"),
        HTML("Adjust a cut-off (a probability threshold) to obtain required specificity and sensitivity. <br>
                    The cut-off value affects decisions made by AmyloGram ('Is amyloid?' field in the table and amyloid residues)."),
        br(),
        br(),
        fluidRow(
          column(3, numericInput("cutoff", value = 0.5,
                                 label = "Cutoff", min = 0.01, max = 0.95, step = 0.01)),
          column(3, htmlOutput("sensitivity"))
        ),
        tags$p(HTML("<h3><A HREF=\"javascript:history.go(0)\">Start a new query</A></h3>"))
      )
    } else {
      fluidRow(
        h4("Exemplary sequences"),
        pre(includeText("prots.txt"))
      )
    }
  })
  
  output[["pred_table"]] <- renderDataTable({
    #formatRound(my_DT(decision()), 2, 4)
    decision() %>% 
      my_DT() %>% 
      formatRound(2, 4)
  })
  
  output[["ar_table"]] <- renderDataTable({
    #formatRound(my_DT(decision()), 2, 4)
    group_by(prediction()[["detailed"]], Protein) %>% 
      summarise(ar = mean(Probability > input[["cutoff"]])) %>% 
      rename('Fraction of amyloid residues' = ar) %>% 
      my_DT() %>% 
      formatRound(2, 4)
  })
  
  
  output[["pred_plots"]] <- renderPlot({
    prediction()[["detailed"]] %>% 
      group_by(Protein) %>% 
      mutate(Position = 1L:length(Protein)) %>% 
      ggplot(aes(x = Position, y = Probability)) +
      geom_line() +
      geom_hline(yintercept = input[["cutoff"]], color = "blue", linetype = "dashed") +
      scale_y_continuous("Probability of self-assembly", limits = c(0, 1)) +
      scale_x_continuous(expand = c(0, 0)) +
      facet_wrap(~ Protein, ncol = 1) +
      theme_bw()
  })
  
  output[["sensitivity"]] <- renderUI({
    dat <- spec_sens[spec_sens[["Cutoff"]] == input[["cutoff"]], ]
    HTML(paste0("Sensitivity: ", round(dat[["Sensitivity"]], 4), "<br>",
                "Specificity: ", round(dat[["Specificity"]], 4), "<br>",
                "MCC: ", round(dat[["MCC"]], 4)
    ))
  })
  
  output[["dynamic_tabset"]] <- renderUI({
    if(is.null(prediction())) {
      
      tabPanel(title = "Sequence input",
               tags$textarea(id = "text_area", style = "width:90%",
                             placeholder="Paste sequences (FASTA format required) here...", rows = 22, cols = 60, ""),
               p(""),
               actionButton("use_area", "Submit data from field above"),
               p(""),
               fileInput('seq_file', 'Submit .fasta or .txt file:'))
      
      
    } else {
      tabsetPanel(
        tabPanel("Results (tabular)",
                 dataTableOutput("pred_table")
                 #downloadButton('downloadData', 'Download results (.csv)'),
        ),
        tabPanel("Detailed results",
                 h4("Amyloid residues"),
                 p("Residues are defined as belonging to the amyloid part of a protein, if their amyloid 
                   probability is higher than the cut-off"),
                 dataTableOutput("ar_table"),
                 h4("Amyloid regions"),
                 plotOutput("pred_plots", height = paste0(150 + nrow(decision()) * 100, "px"))
        )
      )
    }
  })
  
  
})
