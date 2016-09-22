#' Predict amyloids
#'
#' Recognizes amyloids using AmyloGram algorithm.
#' @param object \code{ag_model} object.
#' @param newdata \code{list} of sequences (for example as given by
#' \code{\link[seqinr]{read.fasta}}).
#' @param ... further arguments passed to or from other methods.
#' @export
#' @examples
#' data(AmyloGram_model)
#' data(pep424)
#' predict(AmyloGram_model, pep424[17])

predict.ag_model <- function(object, newdata, ...) {
  if(any(!sapply(newdata, is_protein)))
    stop("Atypical aminoacid detected in input data.")

  seqs_m <- tolower(t(sapply(newdata, function(i)
    c(i, rep(NA, max(lengths(newdata)) - length(i))))))

  gl <- do.call(rbind, lapply(1L:nrow(seqs_m), function(i) {
    res <- do.call(rbind, strsplit(decode_ngrams(seq2ngrams(seqs_m[i, ][!is.na(seqs_m[i, ])], 6, a()[-1])), ""))
    cbind(res, id = paste0("P", rep(i, nrow(res))))
  }))

  bitrigrams <- as.matrix(count_multigrams(ns = c(1, rep(2, 4), rep(3, 3)),
                                           ds = list(0, 0, 1, 2, 3, c(0, 0), c(0, 1), c(1, 0)),
                                           seq = degenerate(gl[, -7], object[["enc"]]),
                                           u = as.character(1L:length(object[["enc"]]))))

  test_ngrams <- bitrigrams > 0
  storage.mode(test_ngrams) <- "integer"

  test_lengths <- lengths(newdata) - 5


  raw_preds <- predict(object[["rf"]],
                     data.frame(test_ngrams[, object[["imp_features"]],
                                            drop = FALSE]))[["predictions"]]
  preds <- data.frame(prob = if(is.matrix(raw_preds)) {
    raw_preds[, 2]
  } else {
    raw_preds[2]
  },
                      prot = unlist(lapply(1L:length(test_lengths), function(i) rep(i, test_lengths[i])))
  )

  data.frame(Name = names(newdata),
             Probability = vapply(unique(preds[["prot"]]), function(single_prot)
               max(preds[preds[["prot"]] == single_prot, "prob"]),
               0)
  )
}
