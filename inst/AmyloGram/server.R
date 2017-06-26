library(shiny)
library(DT)
library(AmyloGram)

data(AmyloGram_model)
data(spec_sens)

options(shiny.maxRequestSize=10*1024^2)

options(DT.options = list(dom = "Brtip",
                          buttons = c("copy", "csv", "excel", "print")
))

my_DT <- function(x)
  datatable(x, escape = FALSE, extensions = 'Buttons',
            filter = "none", rownames = FALSE)


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
      if(length(input_sequences) > 100) {
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
      res <- AmyloGram:::make_decision(prediction(), input[["cutoff"]])
      colnames(res) <- c("Input name", "Amyloid probability", "Is amyloid?")
      res
    }
  })


  output$dynamic_ui <- renderUI({
    if (!is.null(input[["seq_file"]]))
      input_sequences <- read_txt(input[["seq_file"]][["datapath"]])
    input[["use_area"]]
    isolate({
      if (!is.null(input[["text_area"]]))
        if(input[["text_area"]] != "")
          input_sequences <- read_txt(textConnection(input[["text_area"]]))
    })

    if(exists("input_sequences")) {
      tags$p(HTML("<h3><A HREF=\"javascript:history.go(0)\">Start a new query</A></h3>"))
    }
  })

  output$pred_table <- DT::renderDataTable({
    formatRound(my_DT(decision()), 2, 4)
  })

  output$sensitivity <- renderUI({
    dat <- spec_sens[spec_sens[["Cutoff"]] == input[["cutoff"]], ]
    HTML(paste0("Sensitivity: ", round(dat[["Sensitivity"]], 4), "<br>",
    "Specificity: ", round(dat[["Specificity"]], 4), "<br>",
    "MCC: ", round(dat[["MCC"]], 4)
    ))
  })


  output$dynamic_tabset <- renderUI({
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
        tabPanel("Results",
               DT::dataTableOutput("pred_table"),
               h4("Cut-off adjustment"),
               HTML("Adjust a cut-off (a probability threshold) to obtain required specificity and sensitivity. <br>
                    The cut-off value affects decisions made by AmyloGram ('Is amyloid?' field in the table)."),
               br(),
               br(),
               fluidRow(
                 column(3, numericInput("cutoff", value = 0.5,
                                        label = "Cutoff", min = 0.01, max = 0.95, step = 0.01)),
                 column(3, htmlOutput("sensitivity"))
               )
      ),
      tabPanel("Output format",
               includeMarkdown("output_format.md")
               )
      )
    }
  })


})
