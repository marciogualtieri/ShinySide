creating_start <- function() {
  hide(id = "result", anim = TRUE)
  hide(id = "link", anim = TRUE)
  show(id = "creating", anim = TRUE)
  disable("create")
}

creating_end <- function() {
  show(id = "result", anim = TRUE)
  show(id = "link", anim = TRUE)
  hide(id = "creating", anim = TRUE)
  enable("create")
}

update_features_control <- function(features, keywords, input, output, session) {
  if(!is.null(keywords)) {
    choices <- c(features, as.character(keywords$keyword[1:FEATURES_SIZE]))
    updateSelectizeInput(session, "features", 
                         choices = choices,
                         selected = features)
  }
}

update_feature_creator <- function(features, keywords, result, input, output, session) {
  if(!is.null(result)) {
    result_page <- page(result, PAGE_SIZE)
    assign("RESULT_PAGE", result_page, envir = .GlobalEnv)
    render_page("result", result, result_page, output)
    update_features_control(features, keywords, input, output, session)
  }
}

create_features <- function(input, output, session) {
  data <- get("DATA", envir = .GlobalEnv)
  if(!is.null(data)) {
    creating_start()
    features <- isolate(input$features)
    result <- add_features(data, isolate(input$columns), features)
    assign("RESULT", result, envir = .GlobalEnv)
    creating_end()
    update_feature_creator(features, KEYWORDS, result, input, output, session)
  }
}

create_result_downloader <- function(input, output) {
  output$download <- downloadHandler(
    filename = function() {
      paste("result", Sys.Date(), ".rda", sep = "")
    },
    content = function(file) {
      saveRDS(RESULT, file)
    }
  )
}

create_feature_selector <- function(input, output, session){
  observeEvent(input$tabs, {
    features <- isolate(input$features)
    update_features_control(features, KEYWORDS, input, output, session)
  })
  
  observeEvent(input$features, {
    if(length(input$features) > 0) enable("create")
    else disable("create")
  }, ignoreNULL = FALSE)
}

create_feature_creator_controls <- function(input, output, session) {
  observeEvent(input$create, {
    create_features(input, output, session)
  })
  create_result_downloader(input, output)
}

creator_controller <- function(input, output, session) {
  create_feature_selector(input, output, session)
  create_paginated_table(id = "result", data_source = "RESULT", page_source = "RESULT_PAGE", input, output)
  create_feature_creator_controls(input, output, session)
}