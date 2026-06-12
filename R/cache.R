# R/cache.R

library(memoise)

cache_dir <- function() {
  rappdirs::user_cache_dir("conflict")
}

get_cache <- function() {
  dir.create(cache_dir(), showWarnings = FALSE, recursive = TRUE)

  memoise::cache_filesystem(cache_dir())
}
