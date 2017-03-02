page <- function(data, page_size_) {
  data_size_ <- nrow(data)
  page_start_ <- 1
  page_end_ <- page_size_

  page_start <- function() page_start_
  
  page_size <- function() page_size_
  
  page_end <- function() min(page_end_, data_size_)
  
  next_page <- function() {
    pages_left <- function() page_end_ < data_size_
    full_size_page <- function() (page_end_ + page_size_) < data_size_
    
    if(pages_left()){
      if(full_size_page()) {
        page_start_ <<- page_end_ + 1
        page_end_ <<- page_end_ + page_size_
      }
      else {
        page_start_ <<- page_end_ + 1
        page_end_ <<- data_size_
      }
    }
  }
  
  previous_page <- function() {
    pages_left <- function() (page_start_ - page_size_) > 0
    
    if(pages_left()) {
      page_start_ <<- max(page_start_ - page_size_, 1)
      page_end_ <<- min(page_start_ + page_size_ - 1, data_size_)
      
    }
  }
  
  label <- function() paste0(toString(page_start_), ":", toString(page_end_))
  
  return(list(page_start = page_start, page_size = page_size, page_end = page_end,
              next_page = next_page, previous_page = previous_page,
              label = label))
}

page_data <- function(data, page)
  data[page$page_start():page$page_end(), ]

render_page <- function(table_id, data, page, output) {
  output[[paste0(table_id, "_table")]] <- renderTable({
    list_to_string_columns(page_data(data, page))
  })
  
  output[[paste0(table_id, "_page_index")]] <- renderText({ page$label() })
}

create_next_page_button <- function(id, data_source, page_source, input, output) {
  observeEvent(input[[paste0(id, "_next_page")]], {
    page <- get(page_source, envir = .GlobalEnv)
    if(!is.null(page)) {
      data <- get(data_source, envir = .GlobalEnv)
      if(!is.null(data)) {
        page$next_page()
        render_page(id, data, page, output)
      }
    }
  })
}

create_previous_page_button <- function(id, data_source, page_source, input, output) {
  observeEvent(input[[paste0(id, "_previous_page")]], {
    page <- get(page_source, envir = .GlobalEnv)
    if(!is.null(page)) {
      data <- get(data_source, envir = .GlobalEnv)
      if(!is.null(data)) {
        page$previous_page()
        render_page(id, data, page, output)
      }
    }
  })
}

create_paginated_table <- function(id, data_source, page_source, input, output) {
  create_next_page_button(id, data_source, page_source, input, output)
  create_previous_page_button(id, data_source, page_source, input, output)
}