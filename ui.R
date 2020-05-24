library(shiny)

shinyUI(fluidPage(
  
  titlePanel("hogai - an AI Groundhog"),
  
  sidebarPanel(
    
    numericInput('year',label='Year',value=2020,min=0,step=1),
    
    sliderInput('wind_angle', 'Wind Angle (Degrees)', min=0, max=360,
                value=0, step=1, round=0.01),
    
    numericInput('wind_speed','Wind Speed (MPH)',value=0,min=0,step=0.1),
    
    numericInput('temperature','Temperature (Fahrenheit)',value=28,step=0.1),
    
    sliderInput('visibility', 'Visibility (Miles)', min=0, max=10,
                value=1, step=0.1, round=0.1),
    
    selectInput('sky_coverage', 'Sky Coverage', c('Clear','Scattered (1/8 - 4/8)','Broken (5/8 - 7/8)','Overcast','Obscured')),

  ),
  
  mainPanel(div(
    imageOutput('res',hover="Art by Leah Briscoe"),align="center")
  )
))