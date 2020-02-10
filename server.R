#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
library(sf)
library(plotly)
library(readr)

stp_file <- "stps.geojson"
stps <- st_read(stp_file,
                quiet = TRUE,
                stringsAsFactors = FALSE,
                as_tibble = TRUE) %>%
    st_transform(27700) %>%
    inner_join(read_csv("stp_extra_data.csv",
                        col_types = "ccc"),
               by = "stp17cd")

stp_p <- stps %>%
    ggplot() +
    geom_sf(aes(fill = colour)) +
    scale_fill_manual(values = c("1" = "#fbb4ae",
                                 "2" = "#b3cde3",
                                 "3" = "#ccebc5",
                                 "4" = "#decbe4",
                                 "0" = "#CCCCCC")) +
    coord_sf(datum = 27700) +
    theme_void() +
    theme(axis.line = element_blank(),
          legend.position = "none")

find_stp_name_from_event_data <- function(event) {
    if (is.null(event)) {
        return(NULL)
    }

    point <- st_point(c(event$x, event$y))
    find <- stps[st_contains(stps, point, sparse = FALSE), ]

    if (nrow(find) == 1) {
        find
    } else {
        NULL
    }
}



# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    output$stpMap <- renderPlotly({
        ggplotly(stp_p, tooltip = NA)
    })

    output$stpName <- renderText({
        event <- event_data("plotly_hover")
        stp <- find_stp_name_from_event_data(event)
        if (is.null(stp)) {
            return("")
        }
        stp$stp17nm
    })

    observeEvent(event_data("plotly_click"), {
        event <- event_data("plotly_click")
        stp <- find_stp_name_from_event_data(event)
        if (!is.null(stp)) {
            session$sendCustomMessage(type = "openStpFile",
                                      message = stp$url)
        }
    })

})
