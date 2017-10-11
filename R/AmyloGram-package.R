#' Prediction of amyloids
#'
#' Amyloids are proteins associated with the number of clinical disorders (e.g.,
#' Alzheimer's, Creutzfeldt-Jakob's and Huntington's diseases). Despite their
#' diversity, all amyloid proteins can undergo aggregation initiated by 6- to
#' 15-residue segments called hot spots. Henceforth, amyloids form unique,
#' zipper-like beta-structures, which are often harmful. To find the patterns
#' defining the hot spots, we developed our novel predictor of amyloidogenicity
#' AmyloGram, based on random forests.
#'
#' AmyloGram is available as R function (\code{\link{predict.ag_model}}) or
#' shiny GUI (\code{\link{AmyloGram_gui}}).
#'
#' The package is enriched with the benchmark data set \code{\link{pep424}}.
#'
#' @name AmyloGram-package
#' @aliases AmyloGram-package AmyloGram
#' @docType package
#' @author
#' Maintainer: Michal Burdukiewicz <michalburdukiewicz@@gmail.com>
#' @references Burdukiewicz MJ, Sobczyk P, Roediger S, Duda-Madej A,
#' Mackiewicz P, Kotulska M. (2017) \emph{Amyloidogenic motifs revealed
#' by n-gram analysis}. Scientific Reports 7
#' \url{https://doi.org/10.1038/s41598-017-13210-9}
#' @keywords package
#' @importFrom biogram count_multigrams decode_ngrams degenerate seq2ngrams
#' test_features
#' @importFrom ranger ranger
#' @importFrom seqinr a read.fasta
#' @importFrom shiny runApp
#' @importFrom stats predict
#' @importFrom utils capture.output
NULL
