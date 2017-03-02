creator_view <- function() {
  tabPanel(id = "exporter", "Feature Creation",
           
           sidebarPanel(selectizeInput("features", "Choose Features to Create", choices = NULL, multiple = TRUE),
                        actionButton("create", "Create Features"), br(), br(),
                        div(id = "link", downloadLink("download", "Download Result"))),
           div(id = "creating", sidebarPanel(width = 8, img(src = "./images/loading.gif")), align = "center"),
           div(id = "result", table_view(id = "result", name = "Result", width = 8))
           
  )}



