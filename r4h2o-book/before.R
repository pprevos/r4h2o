# Embed Youtube
# Use: eval=knitr::is_html_output(excludes = "epub"), results = 'asis', echo = F

youtube <- function(slug, caption = NULL){
  yt <- paste0('<figure><div style="position: relative; width: 100%; height: 0; margin-top: 3em; padding-bottom: 56.25%;"><iframe width="560" height="315" src="https://www.youtube.com/embed/', slug, '" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe></div><figcaption style="margin-top:6px; margin-bottom:1em;"><i>', caption, '</i></figcaption></figure>')
  cat(yt)
}
