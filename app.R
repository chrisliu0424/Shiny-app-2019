#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#This shiny has different options for different tabs,
#So the panels will be mainly under navbarPage

library(shiny)
library(tidyverse)

#https://shiny.rcg.sfu.ca/u/jla507/myapp/Climate_Change

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Climate Change in Vancouver Area"),
  navbarPage(title = "",
    tabPanel("About",source("about.R")$value()),
    #FIRST TAB PANEL, let user play with data
    tabPanel("Plots",
      #Sidebar with a slider input for number of bins 
        sidebarLayout(
            sidebarPanel(
              radioButtons("Files","Which plot you want to play with?",
                           c("CO2 over years"     = "CO2", 
                             "MaxTemp over years" = "MaxTemp",
                             "MeanTemp over years" = "MeanTemp",
                             "MinTemp over years" = "MinTemp",
                             "Snow over years" = "Snow")),
                #numeric input of the range of year that the user want to see
                numericInput("xmin","From:",1980),
                numericInput("xmax","To:"  ,2019),
                #see if the user wants to add a smooth line
                checkboxInput("Checkline","Do you want a smooth line",FALSE),
                #conditionalpanel of the banwidth of the smooth line
                conditionalPanel(
                   condition = "input.Checkline ==true", 
                   sliderInput("banwidth",
                       "Choose the banwidth that you want to use",
                       min = 1,
                       max = 40,
                       value = 5,
                       step = 1)
                )
            ),
            mainPanel(plotOutput("distPlot"))
        )),
    #SECOND TAB PANEL
    tabPanel("Descriptive Plots",
        sidebarLayout(
            sidebarPanel(
              #users are only able to choose three of the five data
              radioButtons("Files2","Which plot you want to see?",
                  c("CO2 over years"      = "CO2", 
                    "MeanTemp over years" = "MeanTemp",
                    "Snow over years"     = "Snow")),
              checkboxInput("RegressionLine","Do you want to add a regression line?",FALSE)
              #conditionalpanel of the banwidth of the smooth line
              ),
            mainPanel(plotOutput("descPlot"),
            HTML("<p>Co2 is constantly incresing over years in Vancouver Area.
                  One of the main reasons is because car emissions, people are becoming more wealthy and living 
                  in more advance environment. However, we should pay more attention to this enviromental issue 
                  because the increase of Co2 ppm have given a good sign of awareness. Moreover, the evidence have 
                  shown that in January the mean temperature is constantly increasing by small amount and the 
                  amount of snow in January is unstable but constantly decreasing over years in Vancouver.
                  From plot 'Mean Temperature vs. Year', we can see that the slope is 0.02088, which means that 
                  in approximately 100 years, the mean temperature will increase by 2.08 degrees. Furthermore, from
                  the plot 'Snow vs. Year', the slope is -0.06345, which means in approximatly 300 years, there will 
                  no longer be snowing in January in Vancouver.</p>"))
            )
    ),
    #THIRD TAB PANEL
    
    tabPanel("References",source("references.R")$value())
)
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
   output$distPlot <- renderPlot({
     
     #CO2
     if(input$Files == "CO2"){
       load("C02NorthernHemisphere.Rds")
       Co2North$Year = substr(Co2North$YearDecimal,start = 1, stop = 4)
       Co2North_byyear = group_by(Co2North,Year)
       
       #calculating the avg and set x,y
       Co2_avg = summarise(Co2North_byyear,
                           Avglat49value = mean(Latitude49value))
       x = Co2_avg$Year
       y = Co2_avg$Avglat49value
       xlabel = "Year"
       ylabel = "Co2 ppm"
       title = "Year VS CO2 around Vancouver(Latitude 49)"
       ylimit = c(300,450)
     }
     
     #MaxTemp
     else if(input$Files == "MaxTemp"){
      load("CanadianMaxTemp.Rds")
      MaxTemp_Van = filter(MaxTemp,`InfoTemp[2]` == "VANCOUVER")
      MaxTemp_Van[MaxTemp_Van$Jan==-9999.9,2] = NA
      x = MaxTemp_Van$Year
      y = MaxTemp_Van$Jan
      xlabel = "Year"
      ylabel = "Temperature (Celsius)"
      title = "Year VS January Maximun temperature in Vancouver,BC"
      ylimit = c(-20,20)
     }
     
     #MeanTemp
     else if(input$Files == "MeanTemp"){
       load("CanadianMeanTemp.Rdata")
       MeanTemp_Van = filter(MeanTemp,`InfoTemp[2]` == "VANCOUVER")
       MeanTemp_Van[MeanTemp_Van$Jan==-9999.9,2] = NA
       x = MeanTemp_Van$Year
       y = MeanTemp_Van$Jan
       xlabel = "Year"
       ylabel = "Temperature (Celsius)"
       title = "Year VS January Mean temperature in Vancouver,BC"
       ylimit = c(-20,20)
     }

     #MinTemp
     else if(input$Files == "MinTemp"){
       load("CanadianMinTemp.Rds")
       MinTemp_Van = filter(MinTemp,`InfoTemp[2]` == "VANCOUVER")
       MinTemp_Van[MinTemp_Van$Jan==-9999.9,2] = NA
       x = MinTemp_Van$Year
       y = MinTemp_Van$Jan
       xlabel = "Year"
       ylabel = "Temperature (Celsius)"
       title = "Year VS January Minimun temperature in Vancouver,BC"
       ylimit = c(-20,20)
     }
     
     #Snow
     else if(input$Files == "Snow"){
       load("CanadianAvgSnow.Rdata")
       Snow_Van = filter(AllSnow,`InfoTemp[2]` == "VANCOUVER")
       Snow_Van[Snow_Van$Jan==-9999.9,2] = NA
       x = Snow_Van$Year
       y = Snow_Van$Jan
       xlabel = "Year"
       ylabel = "Snow (cm)"
       title = "Year VS Snow in January in Vancouver,BC"
       ylimit = c(0,110)
       #plot(x,y, ylim = ylimit)
       #lines(ksmooth(x, y, bandwidth = 10,kernel = "normal"))
     }else{
       NULL
     }
     
     
     #draw plots base on input
      Year = c(input$xmin,input$xmax)
      plot(x, y, main = title, ylim =  ylimit,xlim = Year, xlab = xlabel, ylab = ylabel, pch = 16)
      
      #respond to conditional panel
      if(input$Checkline == TRUE){
        lines(ksmooth(x, y, bandwidth = input$banwidth,kernel = "normal"))
      }

     
      
      
      
       #####DESCRIPTIVE TAB############
      output$descPlot <- renderPlot({
        #load all three data and preform the same data cleaning as in the previous tab
        if(input$Files2 == "CO2"){
          load("C02NorthernHemisphere.Rds")
          #data cleaning
          Co2North$Year = substr(Co2North$YearDecimal,start = 1, stop = 4)
          Co2North_byyear = group_by(Co2North,Year)
          #calculating the avg and set x,y
          Co2_avg = summarise(Co2North_byyear,
                              Avglat49value = mean(Latitude49value))
          #make Year a numeric variable instead of factor
          Co2_avg$Year = as.numeric(Co2_avg$Year)
          x = Co2_avg$Year
          y = Co2_avg$Avglat49value
          xlabel = "Year"
          ylabel = "Co2 ppm"
          title = "Year VS CO2 around Vancouver(Latitude 49)"
          legendtext = "y = -3230.135 + 1.801x"
        }
        else if(input$Files2 == "MeanTemp"){
          load("CanadianMeanTemp.Rdata")
          MeanTemp_Van = filter(MeanTemp,`InfoTemp[2]` == "VANCOUVER")
          MeanTemp_Van[MeanTemp_Van$Jan==-9999.9,2] = NA
          x = MeanTemp_Van$Year;
          y = MeanTemp_Van$Jan
          xlabel = "Year"
          ylabel = "Temperature (Celsius)"
          title = "Year VS January Minimun temperature in Vancouver,BC"
          legendtext = "y = -37.92636 + 0.02088x"
        }
        else if(input$Files2 == "Snow"){
          load("CanadianAvgSnow.Rdata")
          Snow_Van = filter(AllSnow,`InfoTemp[2]` == "VANCOUVER")
          Snow_Van[Snow_Van$Jan==-9999.9,2] = NA
          x = Snow_Van$Year 
          y = Snow_Van$Jan
          xlabel = "Year"
          ylabel = "Snow (cm)"
          title = "Year VS Snow in January in Vancouver,BC"
          legendtext = "y = 140.29210 - 0.06345x"
        }
        else{NULL}
        
        plot(x, y, main = title, xlab = xlabel, ylab = ylabel, pch =16)
        if(input$RegressionLine == TRUE){
          abline(lm(y~x),col = "red", lwd = 2)
          legend("topleft",col = "red", lwd = 2, lty = 1, legend = legendtext)
        }
        
        
      })
      
      
      
})
}
   

# Run the application 
shinyApp(ui = ui, server = server)





### check for warming within a city,
### temp changes faster or slower in different regions
### extreme weather
### driver is greenhouse gas
### There may be a lag between emissions and climate impact
### higher wind speed

### no climate change






