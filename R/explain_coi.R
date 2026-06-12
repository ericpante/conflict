# R/explain_coi.R

#' Explain COI evidence
#' @export
explain_coi <- function(author_id, reviewer_id) {

  author <- get_author_works(author_id)
  reviewer <- get_author_works(reviewer_id)

  author_papers <- unlist(lapply(author$authorships, function(x) x$work$id))
  reviewer_papers <- unlist(lapply(reviewer$authorships, function(x) x$work$id))

  shared <- intersect(author_papers, reviewer_papers)

  list(
    shared_papers = shared,
    n_shared = length(shared)
  )
}
