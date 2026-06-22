# R/get_preprint.R
#' simple wrapper around openalexR to retrieve a preprint based on DOI.
#' @param doi the preprint doi
#' @export

get_preprint <- function(doi){
  pp<- openalexR::oa_fetch(
    entity = "works",
    doi = doi,
    verbose = TRUE
  )

  pp$authorships[[1]]$id <- sub("https://openalex.org/", "", pp$authorships[[1]]$id)
  pp$authorships[[1]]$orcid <- sub("https://orcid.org/", "", pp$authorships[[1]]$orcid)

  preprint <- tibble::tibble(
    doi = sub("https://doi.org/","",pp$doi),
    openalex_id = sub("https://openalex.org/","",pp$id),
    title = pp$title,
    authors = pp$authorships,
    date = pp$publication_date,
    abstract = pp$abstract,
    concepts = pp$concepts,
    topics = pp$topics,
    keywords = pp$keywords
  )
}


