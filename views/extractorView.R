extractor_view <- function() {
  tabPanel(id = "extractor", "Keyword Extraction",
           
           sidebarPanel(uiOutput("columns"),
                        selectizeInput("exclusion", "Choose Keywords to Exclude", choices = NULL, multiple = TRUE),
                        actionButton("extract", "Extract Keywords")),
           div(id = "extracting", sidebarPanel(width = 8, img(src = "./images/loading.gif")), align = "center"),
           div(id = "keywords", table_view(id = "keywords", name = "Extracted Keywords", width = 8))

)}