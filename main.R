usethis::create_package("conflict")
setwd("~/Documents/GitHub/conflict")

usethis::use_package("openalexR")
usethis::use_package("dplyr")
usethis::use_package("purrr")
usethis::use_package("tidyr")
usethis::use_package("tibble")
usethis::use_package("igraph")
usethis::use_package("stringr")
usethis::use_package("memoise")
usethis::use_package("rappdirs")
usethis::use_package("rvest")
usethis::use_package("httr2")
usethis::use_package("cli")

# check structure
devtools::check()

# NAMESPACE
usethis::use_roxygen_md()
devtools::document()
