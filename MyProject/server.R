#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(tidyr)
library(leaflet)

# Define server logic required to draw a map
shinyServer(function(input, output) {
  
    df <- 
      read.csv("okinawa.csv") |> 
      gather("Station","Passengers",-Year) |> 
      mutate(Station = recode(Station, 
                              "Naha.Airport"="Naha Airport",
                              "Pref.Office"="Prefectural Office",
                              "Tedako.Uranishi"="Tedako-Uranishi"),
             lng = case_when(
               Station == "Naha Airport" ~ 127.65186887791862,
               Station == "Oroku" ~ 127.66723257144604,
               Station == "Prefectural Office" ~ 127.67942052943985,
               Station == "Omoromachi" ~ 127.6979599585009,
               Station == "Shuri" ~ 127.72568327112519,
               Station == "Tedako-Uranishi" ~ 127.74121081707781
             ),
             lat = case_when(
               Station == "Naha Airport" ~ 26.206456484720434,
               Station == "Oroku" ~ 26.196522024831467,
               Station == "Prefectural Office" ~ 26.21469605242861,
               Station == "Omoromachi" ~ 26.222781042395496, 
               Station == "Shuri" ~ 26.219624113196563,
               Station == "Tedako-Uranishi" ~ 26.24159714008132
             )) |> 
      group_by(Station) |> 
      mutate(chg = Passengers - lag(Passengers, n=1))

    output$map <- renderLeaflet({

        # subset based on input$Year from ui.R
        df_sub <- 
          df |> 
          filter(Year == input$Year) |> 
          mutate(radius = ifelse(input$Stat == "Daily Average",
                                 Passengers,
                                 abs(chg)),
                 color = ifelse(input$Stat == "Daily Average" | chg > 0,
                                "blue",
                                "red"))
        
        # draw the map with the specified Year
        leaflet() |>
          addTiles() |> 
          addCircles(data = df_sub,
                     lat = ~lat,
                     lng = ~lng,
                     weight = 1,
                     radius = ~sqrt(radius)*10,
                     color = ~color,
                     popup = ~paste(Station, 
                                    "<br>Daily Average:", 
                                    format(Passengers,big.mark=","),
                                    "<br>Annual Change:", 
                                    format(chg,big.mark=",")))

    })

})
