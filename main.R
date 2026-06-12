usethis::create_package("conflict")
setwd("conflict")

usethis::use_package("openalexR")
usethis::use_package("dplyr")
usethis::use_package("purrr")
usethis::use_package("tidyr")
usethis::use_package("igraph")
usethis::use_package("stringr")
usethis::use_package("memoise")
usethis::use_package("rappdirs")

# check structure
devtools::check()

# NAMESPACE
usethis::use_roxygen_md()
devtools::document()
