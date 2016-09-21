make_decision <- function(x, cutoff)
  data.frame(x, Amyloidogenic = factor(ifelse(x[["Probability"]] > cutoff, "yes", "no")))
