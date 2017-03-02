readme_controller <- function(input, output) {
  output$readme <- renderUI({
    tags$iframe(src = "./README.html", height=900)
  })
}