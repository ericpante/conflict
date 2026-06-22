# R/detect_coi.R

#' Detects conflicts of interest between authors and reviewers. `detect_coi_pair()` does the heavy lifting.
#'
#' @param author_id OpenAlex author ID
#' @param reviewer_id OpenAlex reviewer ID
#' @param coi_yr years since author & reviewer have published together
#' @param verbose logical
#' @export
