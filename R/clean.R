# R/clean.R
#' removes preprint authors from tibble of potential reviewers
#' @param authors the preprint authors
#' @param candidates the candidate preprint reviewers
#' @export

clean <- function(authors, candidates) {
  candidates |>
    dplyr::anti_join(
      authors[[1]] |>
        dplyr::filter(!is.na(orcid)) |>
        dplyr::distinct(orcid),
      by = "orcid"
    )
}
