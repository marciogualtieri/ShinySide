plotting_start <- function() {
  hide(id = "wordcloud", anim = TRUE)
  show(id = "plotting", anim = TRUE)
  disable("generate")
}

plotting_end <- function() {
  show(id = "wordcloud", anim = TRUE)
  hide(id = "plotting", anim = TRUE)
  enable("generate")
}

render_wordcloud <- function(keywords, frequency, words, output) {
  output$plot <- renderPlot({
    if(is.null(keywords)) return(NULL)
    plotting_start()
    suppressWarnings(isolate(
        wordcloud(keywords$keyword, keywords$frequency, scale=c(4,0.5),
                               min.freq = frequency, max.words=words,
                               colors=brewer.pal(8, "Dark2"))
      ))
    plotting_end()
  }, height = 500, width = 500)
}

render_slider <- function(id, name, max, output) {
  output[[id]] <- renderUI({
    sliderInput(id, paste0(name, ":"),
                min = 1,
                max = max,
                value = round(max * 0.1, 0))
  })
}

render_sliders <- function(keywords, max_words, output) {
  if(!is.null(keywords)) {
    max_frequency <- max(keywords$frequency)
    max_words <- min(nrow(keywords), max_words)
    render_slider("frequency", "Minimum Frequency", max_frequency, output)
    render_slider("words", "Maximum Number of Words", max_words, output)
  }
}

wordcloud_controller <- function(input, output) {
  
  observeEvent(input$tabs, {
    render_sliders(KEYWORDS, MAX_WORDS, output)
  })
  
  observeEvent(input$generate, {
    render_wordcloud(KEYWORDS, input$frequency, input$words, output)
  })
}