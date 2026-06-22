# R/screen_reviewers.R

#' Screen multiple reviewers for one author
#' @export

# screen_reviewers <- function(author_id, reviewer_ids, yr) {
#
#   purrr::map_dfr(reviewer_ids, function(r) {
#     detect_coi_pair(author_id, r, yr)
#   })
# }

screen_reviewers <- function(author_ids, reviewer_ids, yr) {

  tidyr::crossing(
    author_id = author_ids,
    reviewer_id = reviewer_ids
  ) |>
    purrr::pmap_dfr(
      ~ detect_coi_pair(..1, ..2, yr)
    ) |>
    dplyr::arrange(dplyr::desc(shared_papers))
}
