# R/coi.R

#' Detect conflict of interest between author and reviewer
#'
#' @param author_id OpenAlex author ID
#' @param reviewer_id OpenAlex author ID
#' @param verbose logical
#' @export
detect_coi_pair <- function(author_id, reviewer_id, verbose = FALSE) {

  author_works <- get_author_works(author_id)
  reviewer_works <- get_author_works(reviewer_id)

  if (is.null(author_works) || is.null(reviewer_works)) {
    return(data.frame(
      author = author_id,
      reviewer = reviewer_id,
      shared_papers = 0,
      coi_score = 0,
      flag = "UNKNOWN"
    ))
  }

  author_papers <- unlist(lapply(author_works$authorships, function(x) x$work$id))
  reviewer_papers <- unlist(lapply(reviewer_works$authorships, function(x) x$work$id))

  shared <- intersect(author_papers, reviewer_papers)

  n_shared <- length(shared)

  coi_score <- n_shared

  flag <- dplyr::case_when(
    n_shared > 0 ~ "HARD_CONFLICT",
    coi_score >= 3 ~ "HIGH",
    coi_score >= 1 ~ "MEDIUM",
    TRUE ~ "NONE"
  )

  data.frame(
    author = author_id,
    reviewer = reviewer_id,
    shared_papers = n_shared,
    coi_score = coi_score,
    flag = flag
  )
}
