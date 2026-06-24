# R/get_author_works.R

#' Fetch works for an author from OpenAlex
#' @param author_id OpenAlex author ID (e.g. "A123456789")
#' @param verbose logical
#' @export
get_author_works <- function(author_id, verbose = FALSE) {

  res <- safe_oa_fetch(
    entity = "works",
    author.id = author_id,
    verbose = verbose
  )

  if (is.null(res)) return(tibble::tibble())

  dplyr::tibble(
    work_id = res$id,
    year = res$publication_year,
    authorships = res$authorships
  ) |>
    dplyr::mutate(
      query_author = purrr::map_chr(
        res$authorships,
        ~ {
          idx <- which(vapply(
            .x$id,
            identical,
            logical(1),
            author_id
          ))
          if (length(idx)) .x$display_name[idx] else NA_character_
        }
      )
    )
}
