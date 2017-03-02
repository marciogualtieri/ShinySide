table_view <- function(id, name, width) {
  sidebarPanel(width = width, h4(paste0(name, ":")), br(),
               tableOutput(paste0(id, "_table")),
               fluidRow(column(1, actionLink(paste0(id, "_previous_page"), "<<")),
                        column(2, textOutput(paste0(id, "_page_index"))),
                        column(1, actionLink(paste0(id, "_next_page"), ">>")))
)}
