make_decision <- function(x, cutoff)
  data.frame(x, Amyloid = factor(ifelse(x[["Probability"]] > cutoff, "yes", "no")))
