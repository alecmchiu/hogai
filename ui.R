library(shiny)

shinyUI(fluidPage(
  
  titlePanel("hogai - an AI Groundhog"),
  
  sidebarPanel(
    
    numericInput('year',label='Year',value=2020,min=0,step=1),
    
    sliderInput('wind_angle', 'Wind Angle', min=0, max=360,
                value=30, step=1, round=0.01),
    
    numericInput('wind_speed','Wind Speed',value=5,min=0,step=1),
    
    numericInput('temperature','Temperature (F)',value=28,step=0.1),
    
    sliderInput('visibility', 'Visibility', min=0, max=10,
                value=1, step=0.1, round=0.1),
    
    selectInput('sky_coverage', 'Sky Coverage', c('Clear','Broken','Scattered','Overcast','Obscured')),

  ),
  
  mainPanel(
    imageOutput('res',hover="Art by Leah Briscoe")
  )
))