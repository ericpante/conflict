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

  n_shared <-  sum(
    purrr::map_lgl(
      author_works$authorships,
      ~ "Amélia Viricel" %in% .x$display_name
    )
  )

  shared_table <- author_works |>
    dplyr::mutate(
      reviewer = purrr::map_int(
        authorships,
        ~ as.integer(reviewer_id %in% .x$id)
      )
    ) |>
    dplyr::group_by(year) |>
    dplyr::summarise(
      n_shared = sum(reviewer),
      .groups = "drop"
    )

  n_shared <- sum(shared_table$n_shared)
  n_shared_coi <- sum(dplyr::filter(shared_table, year>=max(year)-coi_yr)$n_shared)

  # flag <- dplyr::case_when(
  #   n_shared > 0 ~ "HARD_CONFLICT",
  #   coi_score >= 3 ~ "HIGH",
  #   coi_score >= 1 ~ "MEDIUM",
  #   TRUE ~ "NONE"
  # )

  col_nm = paste0("shared_in_past_",coi_yr,"yrs")
  tibble::tibble(
    author = sub("https://openalex.org/","", author_id),
    reviewer = sub("https://openalex.org/","", reviewer_id),
    shared_papers = n_shared,
    !!col_nm := n_shared_coi
  )
}
