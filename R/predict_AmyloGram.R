predict_AmyloGram <- function(model, seqs_list) {
  seqs_m <- tolower(t(sapply(seqs_list, function(i)
    c(i, rep(NA, max(lengths(seqs_list)) - length(i))))))

  gl <- do.call(rbind, lapply(1L:nrow(seqs_m), function(i) {
    res <- do.call(rbind, strsplit(decode_ngrams(seq2ngrams(seqs_m[i, ][!is.na(seqs_m[i, ])], 6, a()[-1])), ""))
    cbind(res, id = paste0("P", rep(i, nrow(res))))
  }))

  bitrigrams <- as.matrix(count_multigrams(ns = c(1, rep(2, 4), rep(3, 3)),
                                           ds = list(0, 0, 1, 2, 3, c(0, 0), c(0, 1), c(1, 0)),
                                           seq = degenerate(gl[, -7], model[["enc"]]),
                                           u = as.character(1L:length(model[["enc"]]))))

  test_ngrams <- bitrigrams > 0
  storage.mode(test_ngrams) <- "integer"

  test_lengths <- lengths(seqs_list) - 5

  preds <- data.frame(prob = predict(model[["rf"]], data.frame(test_ngrams[, model[["imp_features"]]]))[["predictions"]][, 2],
                      prot = unlist(lapply(1L:length(test_lengths), function(i) rep(i, test_lengths[i])))
  )

  data.frame(Name = names(seqs_list),
             Probability = vapply(unique(preds[["prot"]]), function(single_prot)
               max(preds[preds[["prot"]] == single_prot, "prob"]),
               0)
  )
}

