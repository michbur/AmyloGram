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
#' Mackiewicz P, Kotulska M. (2016) \emph{Prediction of amyloidogenicity
#' based on the n-gram analysis}. PeerJ Preprints 4:e2390v1
#' \url{https://doi.org/10.7287/peerj.preprints.2390v1}
#' @keywords package
#' @importFrom biogram count_multigrams decode_ngrams degenerate seq2ngrams
#' test_features
#' @importFrom ranger ranger
#' @importFrom seqinr a
#' @importFrom shiny runApp
#' @importFrom signalHsmm is_protein
#' @importFrom stats predict
#' @importFrom utils capture.output
NULL
