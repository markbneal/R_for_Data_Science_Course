#Workshop 15

# Rmarkdown
#1 combines code, output and prose (writing)
#2 fully reproducible
#3 Multiple outputs supported (html, pdf, word, etc)

# can be used for
#1 communication to decisions makers
#2 collaboration with other data scientists
#3 as an environment to do data science

# What does an Rmarkdown document look like?
# ##1 YAML header
# ---
#   title: "Diamond sizes"
# date: 2016-08-25
# output: html_document
# ---
#   
# ##2 Chunk of code  
#   
# ```{r setup, include = FALSE}
# library(ggplot2)
# library(dplyr)
# 
# smaller <- diamonds %>% 
#   filter(carat <= 2.5)
# ```
# 
# ##3 Text (with simple formatting)
# 
# We have data about `r nrow(diamonds)` diamonds. Only 
# `r nrow(diamonds) - nrow(smaller)` are larger than
# 2.5 carats. The distribution of the remainder is shown
# below:
#   
#   ```{r, echo = FALSE}
# smaller %>% 
#   ggplot(aes(carat)) + 
#   geom_freqpoly(binwidth = 0.01)
# ```


# key differences of rMarkdown vs basic script
#1 has a yaml header
#2 assumes text unless ```
#3 prose (writing) doesn't need #



# install.packages("bookdown")
# library(bookdown)
# 
# install.packages('tinytex')
# tinytex::install_tinytex()

#manually knit an Rmd document
rmarkdown::render("Our first rmarkdown file.Rmd")

rmarkdown::render("CV in rmarkdown.Rmd")

#27.3 Text formatting

mtcars <- mtcars

# 27.4.6 inline code

#format numbers with helper functions
pi

comma <- function(x) format(x, digits=2, big.mark = ",")

comma(345324)

comma(pi)

?format

#Ex 27.4.7

#q1 can download file direct from github, after getting raw link with this code
download.file("https://raw.githubusercontent.com/hadley/r4ds/master/rmarkdown/diamond-sizes.Rmd",
              "diamond-sizes.Rmd")

# or just copy and paste?

# 27.5 Troubleshooting

#27.6 yaml header
# parameters

rmarkdown::render("rmarkdown with mtcars yaml example.Rmd")

unique(mpg$class)

#can create tibble of parameters, and render multiple documents 
# (one for each row of parameters) See book

#bibliography

#Include this in yaml
# biblography: rmarkdown.bib
# csl: apa.csl
# read the book for pointers to learn more.


# 29 R markdown formats

rmarkdown::render("rmarkdown with mtcars yaml example.Rmd", 
                  output_format = "word_document")

# output options
rmarkdown::render("rmarkdown with mtcars yaml example.Rmd")


# 29.4 Notebooks

#superseded by github shared workflow

# 29.5 presentations

# 29.6 Dashboards

# 29.7 Interactivity

#htmlwidgets
#limited interactivity (stuff that can be done in a webpage)

library(leaflet)
leaflet() %>%
  setView(174.764, -36.877, zoom = 16) %>% 
  addTiles() %>%
  addMarkers(174.764, -36.877, popup = "Maungawhau") 

# Shiny
# when you need computations done by r, from interactive input, you need shiny

#29.8 Websites
#websites and blogs, prettyr straightforward

#29.9 Other formats

#bookdown

#30 Rmarkdown workflow

#bare minimum for reproducibility
saveRDS(sessionInfo, "sessioninfo.RDS")
#?saveRDS

#Better
#packrat #may be superseded?
#checkpoint #Old versions of all packages
#renv #working on it?
