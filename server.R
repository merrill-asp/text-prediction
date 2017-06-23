#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
load("w4.RData")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  is.bad.1.char <- function(words) {
    sapply(words, nchar) == 1 & words != "a" & words != "i"
  }
  
  translate.unknown <- function(word) {
    if(!any(grepl(paste("^", word, sep=""), names(t4)))) {
      return("0")
    } else {
      return(word)
    }
  }
  
  prediction <- function(words) {
    n <- length(words)
    while(n > 0){
      n <- length(words)
      n.gram <- paste(words, collapse = " ")
      if(n == 3){
        guesses <- sort(t4[grep(paste("^", n.gram, " ", sep=""), names(t4))], decreasing = TRUE)
      } else if(n == 2) {
        guesses <- sort(t4[grep(paste("^['0a-z]+ ", n.gram, " ", sep=""), names(t4))], decreasing = TRUE)
      } else if(n == 1) {
        guesses <- sort(t4[grep(paste("^['0a-z]+ ['0a-z]+ ", n.gram, " ", sep=""), names(t4))], decreasing = TRUE)
      }
      if(length(guesses) == 0) {
        words <- words[-1]
      } else {
        words.out <- unlist(strsplit(names(guesses), "^['0a-z]+ ['0a-z]+ ['0a-z]+ "))
        words.out <- words.out[words.out != ""]
        words.out <- words.out[words.out != "'"]
        words.out <- unique(words.out)
        words.out <- words.out[!is.bad.1.char(words.out)]
        words.out <- words.out[1:5]
        words.out <- words.out[!is.na(words.out)]
        return(paste(words.out, collapse = ",   "))
      }
    }
    return("and,   the,   in,   of,   a")
  }
  
  predictions <- reactive({
    if(substring(input$text.in, nchar(input$text.in)) != " ") {
      return("...Ready")
    }
    line <- gsub('’', "'", input$text.in) # standardize apostrophes
    words <- unlist(strsplit(tolower(line), "[^[:alnum:]']")) # split words
    words <- words[words != ""] # remove blanks
    words[grepl("\\d", words)] <- "0" # set words with digits in them "unknown"
    words[grepl("[^a-z']", words)] <- "0" # set words with a non a-z character "unknown"
    
    if(length(words) > 2) {
      words <- words[(length(words) - 2):(length(words))]
    }
    
    return(prediction(words))
  })
  
  output$echo <- renderText({ paste("You wrote:", input$text.in) })
  output$text.out <- renderText({ predictions() })
})
