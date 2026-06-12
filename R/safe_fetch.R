# R/safe_fetch.R

safe_oa_fetch <- memoise::memoise(function(...) {
  tryCatch(
    openalexR::oa_fetch(...),
    error = function(e) {
      warning("OpenAlex API failed: ", e$message)
      return(NULL)
    }
  )
}, cache = get_cache())
