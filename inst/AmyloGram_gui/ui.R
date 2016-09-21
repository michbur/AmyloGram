library(shiny)

shinyUI(fluidPage(title = "AmyloGram",
                  includeCSS = "www/shiny_paper.css",
                  
                  headerPanel("AmyloGram"),
                  
                  sidebarLayout(
                    sidebarPanel(style = "background-color: #cccccc;",
                                 includeMarkdown("readme.md"),
                                 pre(includeText("prots.txt")),
                                 uiOutput("dynamic_ui")
                    ),
                    
                    mainPanel(
                      uiOutput("dynamic_tabset")    
                    )
                  )))
