read_data_file <- function(input) {
  data_file <- input$data_file
  if (is.null(data_file)) return(NULL)
  readRDS(file = data_file$datapath)
}

create_data_loader <- function(id, data_source, page_source, page_size, input, output) {
  observeEvent(input[[paste0(id, "_file")]], { 
    data <- read_data_file(input)
    assign(data_source, data, envir = .GlobalEnv)
    if(!is.null(data)) {
      data_page <- page(data, page_size)
      assign(page_source, data_page, envir = .GlobalEnv)
      render_page("data", data, data_page, output)
    }
    show(id = "data")
  })
}

loader_controller <- function(input, output) {
  create_data_loader(id = "data", data_source = "DATA", page_source = "DATA_PAGE", page_size = 100, input, output)
  create_paginated_table(id = "data", data_source = "DATA", page_source = "DATA_PAGE", input, output)
}