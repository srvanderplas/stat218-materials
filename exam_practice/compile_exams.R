# Compile the exams

library(tidyverse)
# setwd(here::here("exams"))
# Set up each exam command separately because versions and parameters may be different.
# setwd(here::here("exams/exam1"))
# crossing(version = 1:4, key = c(T, F)) %>%
#   purrr::pwalk(., function(version, key) {
#     rmarkdown::render(
#       "exam1.Rmd",
#       output_file = sprintf("exam1%s_version-%d.pdf",
#                             ifelse(key, "_key", ""), version),
#       params = list(key = key, version = version))
#   })

# # Set up each exam command separately because versions and parameters may be different.
# setwd(here::here("exam2"))
# crossing(version = 1:4, key = c(T, F)) %>%
#   purrr::pwalk(., function(version, key) {
#     rmarkdown::render(
#       "exam2.Rmd",
#       output_file = sprintf("exam2%s_version-%d.pdf",
#                             ifelse(key, "_key", ""), version),
#       params = list(key = key, version = version))
#   })

# Compile the practice exams
setwd(here::here("exam_practice/"))
tibble(key = c(F, T)) %>%
  purrr::pwalk(., function(key) {
    rmarkdown::render(
      "exam1-practice.Rmd",
      output_file = sprintf("exam1-practice%s.pdf",
                            ifelse(key, "_key", "")),
      params = list(key = key))
  })

tibble(key = c(F, T)) %>%
  purrr::pwalk(., function(key) {
    rmarkdown::render(
      "exam2-practice.Rmd",
      output_file = sprintf("exam2-practice%s.pdf",
                            ifelse(key, "_key", "")),
      params = list(key = key))
  })

rmarkdown::render("index.Rmd") # Render exam-practice index

setwd(here::here())
rmarkdown::render("index.Rmd") # Render complete index

# Clean up extra files
file.remove(list.files(here::here("exam2"), ".log", full.names = T, recursive = T))
file.remove(list.files(here::here("exams/"), "tmp-pdfcrop", full.names = T, recursive = T))
file.remove(list.files(here::here("exam_practice/"), "tmp-pdfcrop", full.names = T, recursive = T))
