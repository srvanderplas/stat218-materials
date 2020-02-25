setwd(here::here("slides/"))
html_files <- list.files(".", "html")

html_files <- html_files[!grepl("index", html_files)]

html_to_pdf <- function(x) {
  xpdf <- stringr::str_replace(x, "html", "pdf")
  xrmd <- stringr::str_replace(x, "html", "Rmd")
  if (!file.exists(xrmd)) return(paste0("ERROR printing ", x, " Rmd file does not exist"))

  # Rerender if rmd modtime is more recent
  if (file.mtime(xrmd) > file.mtime(x)) rmarkdown::render(input = xrmd, output_file = x)

  # If PDF doesn't exist, that's ok
  pdf_update <- ifelse(file.exists(xpdf), file.mtime(xpdf), -Inf)
  if (file.mtime(x) > pdf_update) {
    res <- try(pagedown::chrome_print(x, xpdf))
    if ("try-error" %in% class(res)) warning(paste("PDF build of ", x, " failed")) else {
      system(paste0("pdfnup --nup 2x2 --frame true --paper letterpaper --noautoscale false --scale 0.92 --suffix 4 ", xpdf))
      system(paste0("pdfnup --nup 1x2 --frame true --paper letterpaper --noautoscale false --scale 0.92 --no-landscape --suffix 2 ", xpdf))
      system(paste0("pdfjam-slides3up --suffix 3 --paper letterpaper ", xpdf))
    }
  }
}

# mod_date_Rmd <- file.mtime(str_replace(html_files, "html", "Rmd"))
# mod_date_html <- file.mtime(html_files)
# mod_date_pdf <- file.mtime(str_replace(html_files, "html", "pdf"))
#
# regen <- (mod_date_html >= mod_date_pdf) | is.na(mod_date_pdf)

purrr::map(html_files, html_to_pdf)
rmarkdown::render("index.Rmd")

git2r::add(path = list.files(here::here("slides"), ".pdf$", full.names = T))
git2r::add(path = list.files(here::here("slides"), ".html$", full.names = T))
git2r::add(path = list.files(here::here("slides"), "_files/*", full.names = T))
git2r::commit(repo = here::here(), "Updated pdf and html slides")
