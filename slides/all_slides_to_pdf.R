setwd("slides/")
html_files <- list.files(".", "html")

html_to_pdf <- function(x) {
  xpdf <- stringr::str_replace(x, "html", "pdf")
  # webshot(x, file = xpdf, delay = 2)
  pagedown::chrome_print(x, xpdf)
  system(paste0("pdfnup --nup 2x2 --frame true --noautoscale false --scale 0.95 --suffix 4 ", xpdf))
  system(paste0("pdfnup --nup 1x2 --frame true --noautoscale false --scale 0.95 --no-landscape --suffix 2 ", xpdf))
  system(paste0("pdfjam-slides3up --suffix 3 ", xpdf))
}

purrr::map(html_files, html_to_pdf)
rmarkdown::render("index.Rmd")

git2r::add(path = list.files(here::here("slides"), ".pdf$", full.names = T))
git2r::add(path = list.files(here::here("slides"), ".html$", full.names = T))
git2r::add(path = list.files(here::here("slides"), "_files/*", full.names = T))
git2r::commit(repo = here::here(), "Updated pdf and html slides")
