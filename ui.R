#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Mental Health Physical Health"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            p("Select an STP below to view it's report"),
            textOutput("stpName")

        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotlyOutput("stpMap", height = "600px")
        )
    ),

    singleton(
        tags$head(tags$script(src = "message_handler.js"))
    )
))
