# R/fetch.R

#' Fetch works for an author from OpenAlex
#' @param author_id OpenAlex author ID (e.g. "A123456789")
#' @param verbose logical
#' @export
get_author_works <- function(author_id, verbose = FALSE) {

  res <- openalexR::oa_fetch(
    entity = "works",
    filter = paste0("author.id:", author_id),
    verbose = verbose
  )

  if (is.null(res)) return(NULL)

  res |>
    dplyr::select(
      id,
      publication_year,
      authorships
    )
}
