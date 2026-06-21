# R/tarzan.R
#' tarzan queries JANE's APÏ
#' @param abstract the text to submit to JANE; for PCI, it is the abstract
#' @export

tarzan = function(abstract){
  janeAPI="http://jane.biosemantics.org/suggestions.php?findAuthors&text="
  url <- URLencode(paste0(janeAPI, abstract))

  res <- tryCatch(
    request(url) |> req_perform(),
    error = function(e) return(NULL)
    )

  html <- res |> httr2::resp_body_html()

  authors <- html |>
    rvest::html_elements("td:nth-child(2)") |>
    rvest::html_text2()

  conf <- html |>
    rvest::html_elements("#bluebar") |>
    rvest::html_attr("title")

  tibble::tibble(author=authors[authors!=""], confidence=conf[grep(pattern="Confidence", conf)])
}
