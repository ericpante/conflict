# R/utils.R

safe_oa <- function(expr) {
  tryCatch(expr, error = function(e) NULL)
}
