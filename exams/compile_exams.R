# Compile the exams

library(tidyverse)
setwd("exams")
# Set up each exam command separately because versions and parameters may be different.
crossing(version = 1:4, key = c(T, F)) %>%
  purrr::pwalk(., function(version, key) {
    rmarkdown::render(
      "exam1.Rmd",
      output_file = sprintf("exam1%s_version-%d.pdf",
                            ifelse(key, "_key", ""), version),
      params = list(key = key, version = version))
  })

# Compile the practice exams
setwd("exam-practice/")
tibble(key = c(F, T)) %>%
  purrr::pwalk(., function(key) {
    rmarkdown::render(
      "exam1-practice.Rmd",
      output_file = sprintf("exam1-practice%s.pdf",
                            ifelse(key, "_key", "")),
      params = list(key = key))
  })

setwd(here::here())
rmarkdown::render("index.Rmd")
