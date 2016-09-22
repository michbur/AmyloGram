#' @name AmyloGram_model
#' @title Random forest model of amyloid proteins
#' @description Random forest grown using the \code{ranger} package with additional
#' information.
#' @docType data
#' @seealso \code{\link[ranger]{ranger}}
#' @format A list of length three: random forest, a vector of important n-grams
#' and the best-performing encoding.
#' @keywords datasets
NULL

#' @name spec_sens
#' @title Specificity/sensitivity balance
#' @description Sensitivity, specificity and Matthew's Correlation Coefficient
#' of AmyloGram for different cutoffs computed on \code{pep424} dataset.
#' @docType data
#' @usage spec_sens
#' @source Walsh, I., Seno, F., Tosatto, S.C.E., and Trovato, A. (2014).
#' \emph{PASTA 2.0: an improved server for protein aggregation prediction}.
#' Nucleic Acids Research gku399.
#' @format a data frame with four columns and 99 rows.
#' @keywords datasets
NULL

#' @name pep424
#' @title pep424 data set
#' @description Benchmark dataset for PASTA 2.0. 5 sequences shorter than 6 amino acids
#' (1\% of the original dataset) were removed.
#' @docType data
#' @usage pep424
#' @source Walsh, I., Seno, F., Tosatto, S.C.E., and Trovato, A. (2014).
#' \emph{PASTA 2.0: an improved server for protein aggregation prediction}.
#' Nucleic Acids Research gku399.
#' @format a list of 424 peptides (class \code{\link[seqinr]{SeqFastaAA}}).
#' @keywords datasets
NULL
