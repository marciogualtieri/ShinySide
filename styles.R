apply_styles <- function() {
  toggleClass(class = "button", id = "data_previous_page")
  toggleClass(class = "button", id = "data_next_page")
  toggleClass(class = "button", id = "keywords_previous_page")
  toggleClass(class = "button", id = "keywords_next_page")
  toggleClass(class = "button", id = "result_previous_page")
  toggleClass(class = "button", id = "result_next_page")
  
  hide(id = "extracting", anim = TRUE)
  hide(id = "plotting", anim = TRUE)
  hide(id = "creating", anim = TRUE)
  hide(id = "data")
  hide(id = "keywords")
  hide(id = "result")
  hide(id = "link")
}