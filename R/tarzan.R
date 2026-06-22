# R/tarzan.R
#' tarzan queries JANE's API to retrieve the results of a JANE search. It then queries OpenAlex's API to retrieve the ORCID and affiliation for authors, based on the first PubMed paper detected by JANE.
#' @param abstract the text to submit to JANE; for PCI, it is the abstract
#' @param n is the number of authors returned from JANE that you want to keep (default=10, max=100)
#' @export

tarzan = function(abstract, n){
  janeAPI="http://jane.biosemantics.org/suggestions.php?findAuthors&text="
  url <- URLencode(paste0(janeAPI, abstract))

  res <- tryCatch(
    httr2::request(url) |>
      httr2::req_perform(),
    error = function(e) return(NULL)
    )

  html <- res |> httr2::resp_body_html()

  auth <- html |>
    rvest::html_elements("td:nth-child(2)") |>
    rvest::html_text2()
  auth <- auth[auth!=""]
  authors <- auth[1:n]

  conf <- html |>
    rvest::html_elements("#bluebar") |>
    rvest::html_attr("title")
  conf <- conf[grep(pattern="Confidence", conf)]
  conf_auth <- conf[1:n]

  pubmed <- html |>
    rvest::html_elements('input[name^="authorPMIDs"]') |>
    rvest::html_attr("value")
  pubmed <- pubmed[1:n]
  first_pubmed <- sub(";.*", "", pubmed)

  email <- html |>
    rvest::html_elements('input[name^="authorPMIDs"]') |>
    rvest::html_attr("value")
  email <- email[1:n]


  orcid <- rep(NA_character_, length(first_pubmed))
  aff <- rep(NA_character_, length(first_pubmed))
  oa_id <- rep(NA_character_, length(first_pubmed))

  pb <- cli::cli_progress_bar(
    format = "Processing PubMed {cli::pb_current}/{cli::pb_total} [{cli::pb_bar}] {cli::pb_percent}",
    total = length(first_pubmed)
  )

  for(i in 1:length(first_pubmed)){
    work <- openalexR::oa_fetch(
      entity = "works",
      ids.pmid = first_pubmed[i])
    openalex_names <- work$authorships[[1]]$display_name
    jane_name <- authors[i]
    match <- match_names(jane_name, openalex_names)

    idx <- which(match)

    if (length(idx) > 0) {
      orcid[i] <- sub("https://orcid.org/", "", work$authorships[[1]]$orcid[idx[1]])
      aff[i] <- work$authorships[[1]]$affiliation_raw[idx[1]]
      oa_id[i] <- sub("https://openalex.org/", "", work$authorships[[1]]$id[idx[1]])
    } else {
      orcid[i] <- NA_character_
      aff[i] <- NA_character_
      oa_id[i] <- NA_character_
    }
    cli::cli_progress_update(id = pb)
  }
  cli::cli_progress_done(id = pb)

  tibble::tibble(author=authors,
                 confidence=conf_auth,
                 pmdi=first_pubmed,
                 orcid=orcid,
                 id=oa_id,
                 affiliation=aff
                 )
}


