#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Passengers of Okinawa Monorail"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("Year",
                        "Fiscal Year:",
                        choices = 2003:2022,
                        selected = 2022),
            p("Note: Okinawa Monorail opened in 2003 and linked 15 stations from Naha Airport to Shuri. It was extended to Tedako-Uranishi in 2019.",
              style = "padding-bottom: 12pt"),
            selectInput("Stat",
                        "Statistics:",
                        choices = c("Daily Average",
                                    "Annual Change in Daily Average"),
                        selected = 2022),
            p("Note: When the change statistics is selected, blue indicates increase and red indicates decrease.")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            leafletOutput("map")
        )
    )
))
