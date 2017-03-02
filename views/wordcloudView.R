wordcloud_view <- function() {
  tabPanel(id = "wordcloud", "Word Cloud",
           
           sidebarLayout(sidebarPanel(uiOutput("frequency"),
                                      uiOutput("words"),
                                      actionButton("generate", "Generate Wordcloud")),
                         mainPanel(div(id = "plotting", sidebarPanel(width = 8, img(src = "./images/loading.gif")), align = "center"),
                                   div(id = "wordcloud", plotOutput("plot", width = "100%"))))
  )
}


