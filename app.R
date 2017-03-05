library(shiny)
library(DT)
ui <- fluidPage(
  titlePanel("Datatable for dynamic text selection"),
  sidebarLayout(
    sidebarPanel(
      dataTableOutput("pairs")
    ),
    mainPanel(
      strong("Sentence"), htmlOutput("content"),
      strong("Selection"),textOutput("selection")
    )
  )
)

server <- function(input, output) {
  output$content <- renderText("A sample sentence for demo purpose")
  select_text <- JS(
    'table.on("click.dt","tr", function(){
contentdiv = document.getElementById("content");
var selectedCell=this.lastChild;
var sentence = contentdiv.innerHTML;
var target = selectedCell.innerHTML;
var sentenceIndex = sentence.indexOf(target); 
selection = window.getSelection();
range = document.createRange();
range.setStart(contentdiv.firstChild, sentenceIndex);
range.setEnd(contentdiv.firstChild, (sentenceIndex + target.length));
selection.removeAllRanges();
selection.addRange(range);
                                                    })'
  )
  df <- data.frame(SrNo=1:5, Pairs=c("A sample", "sample sentence", 
                                     "sentence for", "for demo", "demo purpose"))
  output$pairs <- renderDataTable(DT::datatable(df, selection = "single",
                                                callback = select_text))
  
   observeEvent(input$pairs_cell_clicked,{
     info = input$pairs_cell_clicked
     if(is.null(info$value)) return()
     output$selection <- renderText(info$value)
   })
}

shinyApp(ui = ui, server = server)