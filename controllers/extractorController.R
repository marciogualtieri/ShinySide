extracting_start <- function() {
  hide(id = "keywords", anim = TRUE)
  show(id = "extracting", anim = TRUE)
  disable("extract")
}

extracting_end <- function() {
  show(id = "keywords", anim = TRUE)
  hide(id = "extracting", anim = TRUE)
  enable("extract")
}

load_keywords <- function(data, keywords_source, columns, exclusion) {
  keywords <- extract_keywords(data[, columns], exclusion)
  assign(keywords_source, keywords, envir = .GlobalEnv)
  keywords
}

create_column_selector <- function(data_source, input, output) {
  observeEvent(input$tabs, { 
    output$columns <- renderUI({
      data <- get(data_source, envir = .GlobalEnv)
      if(!is.null(data)) {
        text_columns <- names(data)
        text_columns <- text_columns[sapply(text_columns, is_text_column, data = data)]
        checkboxGroupInput("columns", "Choose Text Columns", choices  = text_columns, selected = input$columns)
      }
    })
  })
  
  observeEvent(input$columns, {
    if(length(input$columns) > 0) enable("extract")
    else disable("extract")
  }, ignoreNULL = FALSE)
}

update_exclusion <- function(words_to_remove, keywords, input, output, session) {
  choices <- c(words_to_remove, as.character(keywords$keyword[1:EXCLUSION_SIZE]))
  updateSelectizeInput(session, "exclusion", 
                       choices = choices,
                       selected = words_to_remove)
}

update_keyword_extractor <- function(words_to_remove, keywords, input, output, session) {
  if(!is.null(keywords)) {
    keywords_page <- page(keywords, PAGE_SIZE)
    assign("KEYWORDS_PAGE", keywords_page, envir = .GlobalEnv)
    render_page("keywords", keywords, keywords_page, output)
    update_exclusion(words_to_remove, keywords, input, output, session)
  }
}

create_keywords_extractor <- function(input, output, session) {
  observeEvent(input$extract, {
    data <- get("DATA", envir = .GlobalEnv)
    if(!is.null(data)) {
      extracting_start()
      words_to_remove <- isolate(input$exclusion)
      keywords <- load_keywords(data, "KEYWORDS", input$columns, words_to_remove)
      extracting_end()
      update_keyword_extractor(words_to_remove, KEYWORDS, input, output, session)
    }
  })
}

extractor_controller <- function(input, output, session) {
  create_column_selector(data_source = "DATA", input, output)
  create_paginated_table(id = "keywords", data_source = "KEYWORDS", page_source = "KEYWORDS_PAGE", input, output)
  create_keywords_extractor(input, output, session)
}