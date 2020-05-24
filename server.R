library(shiny)
library(randomForest)
library(png)

load("rf.RData")
shadow_img <- "imgs/shadow.png"
no_shadow_img <- "imgs/no_shadow.png"
sky_convert <- c("CLR","BKN","SCT","OVC","OBS")
names(sky_convert) <- c('Clear','Broken','Scattered','Overcast','Obscured')

shinyServer(function(input, output) {
  
  results <- reactive({
    
    new_data <- data.frame(input$year,input$wind_angle,input$wind_speed,
                 sky_convert[input$sky_coverage],input$visibility,input$temperature)
    
    names(new_data) <- c("year","wind_angle","wind_speed","sky_coverage",'visibility','temperature')
    
    pred <- which.min(abs(c(1,2) - predict(rand_for,data.matrix(new_data))))
    pred
  })
  
  output$res <- renderImage({
    filename <- ifelse(results() == 2,file.path(shadow_img),file.path(no_shadow_img))
    list(src=filename,width='auto',height='300')
  },deleteFile = F)

})