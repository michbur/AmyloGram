library(shiny)

shinyUI(fluidPage(tags$head(includeScript("ga.js")),
                  title = "AmyloGram",
                  includeCSS = "www/shiny_paper.css",

                  headerPanel(""),

                  sidebarLayout(
                    sidebarPanel(style = "background-color: #e0e0e0;",
                                 includeMarkdown("readme.md"),
                                 pre(includeText("prots.txt")),
                                 uiOutput("dynamic_ui")
                    ),

                    mainPanel(
                      uiOutput("dynamic_tabset")
                    )
                  )))
