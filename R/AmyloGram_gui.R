#' AmyloGram Graphical User Interface
#'
#' Launches graphical user interface that predicts presence of amyloids.
#'
#' @section Warning : Any ad-blocking software may cause malfunctions.
#' @export AmyloGram_gui
AmyloGram_gui <- function()
  runApp(system.file("AmyloGram", package = "AmyloGram"))
