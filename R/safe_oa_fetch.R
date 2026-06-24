# R/safe_oa_fetch.R

safe_oa_fetch <- function(...) {
  tryCatch(
    openalexR::oa_fetch(...),
    error = function(e) {
      warning("OpenAlex API failed: ", e$message)
      return(NULL)
    }
  )
}

