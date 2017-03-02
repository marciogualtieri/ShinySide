loader_view <- function() {
  tabPanel(id = "loader", "Data Load",
           
           fileInput("data_file", "Choose Rdata File", accept = c(".rda")),
           div(id = "data", table_view("data", "Input Data", 12))

)}