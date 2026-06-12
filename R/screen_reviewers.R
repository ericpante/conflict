# R/screen_reviewers.R

#' Screen multiple reviewers for one author
#' @export
screen_reviewers <- function(author_id, reviewer_ids) {

  purrr::map_dfr(reviewer_ids, function(r) {
    detect_coi_pair(author_id, r)
  }) |>
    dplyr::arrange(desc(coi_score))
}
