setwd(here::here("slides/"))
rmd_files <- list.files(".", "Rmd")

build_slides <- function(x, stop_at = ifelse(grepl("index", x), "html", "pdf")) {
  x_base <- stringr::str_extract(x, "\\.((?:[Pp][Dd][Ff])|(?:[Hh][Tt][Mm][Ll])|(?:[Rr][Mm][Dd]))$")
  x_base <- stringr::str_remove(x_base, "\\.")

  xhtml <- stringr::str_replace(x, x_base, "html")
  xpdf <- stringr::str_replace(x, x_base, "pdf")
  xrmd <- stringr::str_replace(x, x_base, "Rmd")

  if (!file.exists(xrmd)) {
    warning(paste0("ERROR printing ", x, " Rmd file does not exist"))
  } else {
    # Rerender if rmd modtime is more recent or if HTML file doesn't exist
    html_update <- ifelse(file.exists(xhtml), file.mtime(xhtml), -Inf)
    if (file.mtime(xrmd) > file.mtime(x) | file.mtime(xrmd) > html_update) {
      rmarkdown::render(input = xrmd, output_file = xhtml)
    }
  }

  # If HTML still doesn't exist, quit
  if (!file.exists(xhtml)) {
    warning(paste0("ERROR printing ", xhtml, " html file does not exist"))
    return()
  }
  # If we're stopping at HTML, quit
  if (stop_at == "html") return()

  # If PDF doesn't exist, create it
  pdf_update <- ifelse(file.exists(xpdf), file.mtime(xpdf), -Inf)
  if (file.mtime(xhtml) > pdf_update) {
    res <- try(pagedown::chrome_print(xhtml, xpdf))
    if ("try-error" %in% class(res)) warning(paste("PDF build of ", xhtml, " failed")) else {
      system(paste0("pdfnup --nup 2x2 --frame true --paper letterpaper --noautoscale false --scale 0.92 --suffix 4 ", xpdf))
      system(paste0("pdfnup --nup 1x2 --frame true --paper letterpaper --noautoscale false --scale 0.92 --no-landscape --suffix 2 ", xpdf))
      system(paste0("pdfjam-slides3up --suffix 3 --paper letterpaper ", xpdf))
    }
  }
}


purrr::map(rmd_files, build_slides) %>% unlist()

git2r::add(path = list.files(here::here("slides"), ".pdf$", full.names = T))
git2r::add(path = list.files(here::here("slides"), ".html$", full.names = T))
git2r::add(path = list.files(here::here("slides"), "_files/*", full.names = T))
git2r::commit(repo = here::here(), "Updated pdf and html slides")
