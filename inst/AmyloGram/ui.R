library(shiny)
library(shinythemes)

shinyUI(fluidPage(tags$head(includeScript("ga.js")),
                  title = "AmyloGram",
                  theme = shinytheme("united"),

                  headerPanel(""),

                  sidebarLayout(
                    sidebarPanel(style = "background-color: #e0e0e0;border-color: #E95420;border-width: .25rem",
                                 includeMarkdown("readme.md"),
                                 uiOutput("dynamic_ui")
                    ),

                    mainPanel(
                      uiOutput("dynamic_tabset")
                    )
                  )))
