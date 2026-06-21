# R/get_author_intitutions.R

#' Fetch institutions for an author from OpenAlex
#' @param author_id OpenAlex author ID (e.g. "A123456789")
#' @param verbose logical
#' @export
get_author_institution <- function(author_id, verbose = TRUE) {

  author <- safe_oa_fetch(
  entity = "authors",
  id = author_id,
  verbose = verbose
  )
}
