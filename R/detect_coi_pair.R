# R/detect_coi_pair.R

#' Detects conflict of interest between author and reviewer
#'
#' @param author_id OpenAlex author ID
#' @param reviewer_id OpenAlex reviewer ID
#' @param coi_yr years since author & reviewer have published together
#' @param verbose logical
#' @export

detect_coi_pair <- function(author_id, reviewer_id, coi_yr, verbose = TRUE) {

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

  n_shared <- sum(
    purrr::map_lgl(
      author_works$authorships,
      ~ reviewer_id %in% .x$display_name
    )
  )

  shared <- author_works |>
    dplyr::mutate(
      reviewer = purrr::map_int(
        !!author_works$authorships,
        ~ as.integer(reviewer_id %in% .x$id)
      )
    )

  # shared_table <- shared |>
  #   dplyr::group_by(year) |>
  #       dplyr::summarise(
  #     n_shared = sum(reviewer),
  #     .groups = "drop"
  #   )


  shared_table <- aggregate(
    reviewer ~ year,  # group by year, summarize reviewer
    data = shared,
    FUN = sum,
    na.rm = TRUE
  )

  # Rename the output column to 'n_shared'
  names(shared_table)[2] <- "n_shared"

  n_shared <- sum(shared_table$n_shared)
  n_shared_coi <- sum(dplyr::filter(shared_table, year>=max(year)-coi_yr)$n_shared)

  col_nm = paste0("shared_in_past_",coi_yr,"yrs")
  tibble::tibble(
    author = author_works$query_author[1],
    author_id = sub("https://openalex.org/","", author_id),
    reviewer = reviewer_works$query_author[1],
    reviewer_id = sub("https://openalex.org/","", reviewer_id),
    shared_papers = n_shared,
    !!col_nm := n_shared_coi
  )
}
