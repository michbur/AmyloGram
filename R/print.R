#' Print AmyloGram object
#'
#' Prints \code{ag_model} objects.
#' @param x \code{ag_model} object.
#' @param ... further arguments passed to or from other methods.
#' @export
#' @examples
#' data(AmyloGram_model)
#' print(AmyloGram_model)

print.ag_model <- function(x, ...) {
  rf_dat <- capture.output(print(x[["rf"]]))[7L:13]
  ngram_dat <- paste0("Number of informative n-grams:    ", length(x[["imp_features"]]))
  enc_dat <- data.frame(ID = 1L:length(x[["enc"]]),
                        Aminoacids = sapply(x[["enc"]], function(i) paste0(toupper(i), collapse = ","))
                        )

  cat("AmyloGram prediction model of amyloids",
      rf_dat,
      ngram_dat,
      "\nReduced amino acid alphabet:",
      sep = "\n"
      )
  print(enc_dat)
}
