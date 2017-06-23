#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Text Prediction"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      textInput("text.in", "Type here", ""),
      helpText("Type a space to generate a prediction.")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      verbatimTextOutput("echo", placeholder = TRUE),
      verbatimTextOutput("text.out", placeholder = TRUE)
    )
  )
))
