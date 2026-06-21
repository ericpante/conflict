# R/match_names.R
#' format JANE names to match OpenAlex
#' @param jane the name in the JANE db
#' @param alex the name in the OpenAlex db
#' @export

parse_jane <- function(x) {
  parts <- strsplit(x, ",\\s*")[[1]]
  list(
    last = tolower(parts[1]),
    first_initial = tolower(substr(parts[2], 1, 1))
  )
}

parse_openalex <- function(x) {
  parts <- strsplit(x, "\\s+")[[1]]
  list(
    first = tolower(parts[1]),
    last = tolower(parts[length(parts)]),
    first_initial = tolower(substr(parts[1], 1, 1))
  )
}

match_names <- function(jane, openalex_vec) {

  j <- parse_jane(jane)

  sapply(openalex_vec, function(x) {

    o <- parse_openalex(x)

    last_match <- j$last == o$last
    first_initial_match <- j$first_initial == o$first_initial

    last_match && first_initial_match
  })
}
