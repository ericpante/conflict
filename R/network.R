# R/network.R

#' Build coauthorship edge list
#' @param works data.frame from OpenAlex
#' @export
build_coauthor_edges <- function(works) {

  edges <- purrr::map_dfr(works$authorships, function(a) {

    authors <- a$author$id

    if (length(authors) < 2) return(NULL)

    pairs <- t(combn(authors, 2))

    dplyr::tibble(
      from = pairs[,1],
      to   = pairs[,2],
      weight = 1 / (length(authors) - 1)
    )
  })

  edges |>
    dplyr::group_by(from, to) |>
    dplyr::summarise(weight = sum(weight), .groups = "drop")
}
