source("globals.R")
source("views/tableView.R")
source("views/loaderView.R")
source("views/extractorView.R")
source("views/wordcloudView.R")
source("views/creatorView.R")
source("views/readmeView.R")

shinyUI(fluidPage(theme = "style.css", useShinyjs(), tabsetPanel(id = "tabs",

  loader_view(),
  extractor_view(),
  wordcloud_view(),
  creator_view(),
  readme_view()
                        
)))
