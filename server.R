library("shiny")
library("httr")
library("jsonlite")
library("dplyr")
library("ggplot2")
theme_set(theme_bw())
options(scipen = 999)
if(file.exists("big_table.csv") == FALSE) {
  source("spotify_code.R")
} else {
  big.frame <- read.csv("big_table.csv", stringsAsFactors = FALSE)
  music.averages <- read.csv("music_averages.csv", stringsAsFactors = FALSE)
  high.avg <- read.csv("high_avg.csv", stringsAsFactors = FALSE)
  low.avg <- read.csv("low_avg.csv", stringsAsFactors = FALSE)
  audio.features <- read.csv("audio_features.csv", stringsAsFactors =  FALSE)
}

#Creating plot
my.server <- function (input, output) {
  output$plot1 <- renderPlot({
    choice <- tolower(input$select1)
    choice.2 <- tolower(input$select2)
    return(ggplot(data = big.frame) + 
             geom_point(mapping = aes_string(x = choice, y = choice.2, col = big.frame$Position)) + scale_colour_gradient(low = "pink", high = "black") +
             geom_smooth(mapping = aes_string(x = choice, y = choice.2), method ="loess", se=F) + 
             labs(title = paste(input$select1, "vs.", input$select2), subtitle = "In Spotfy's Top 100 Tracks", x=input$select1, y=input$select2, col = "Top 100 Rank (lighter is more popular)"))
  })
  
  # Creating tooltip hover for plot
  output$hover_info <- renderUI({
    hover <- input$plot_hover
    point <- nearPoints(big.frame, hover, threshold = 5, maxpoints = 1, addDist = TRUE)
    if (nrow(point) == 0) return(NULL)
    # calculate point position INSIDE the image as percent of total dimensions
    # from left (horizontal) and from top (vertical)
    left_pct <- (hover$x - hover$domain$left) / (hover$domain$right - hover$domain$left)
    top_pct <- (hover$domain$top - hover$y) / (hover$domain$top - hover$domain$bottom)
    
    # calculate distance from left and bottom side of the picture in pixels
    left_px <- hover$range$left + left_pct * (hover$range$right - hover$range$left)
    top_px <- hover$range$top + top_pct * (hover$range$bottom - hover$range$top)
    
    # create style property fot tooltip
    # background color is set so tooltip is a bit transparent
    # z-index is set so we are sure are tooltip will be on top
    style <- paste0("position:absolute; z-index:100; background-color: rgba(245, 245, 245, 0.85); ",
                    "left:", left_px + 2, "px; top:", top_px + 2, "px;")
    
    # actual tooltip created as wellPanel
    wellPanel(
      
      style = style,
      p(HTML(paste0("<b> Spotify Rank: </b>", rownames(point), "<br/>",
                    "<b> Artist: </b>", point$Artist, "<br/>",
                    "<b> Song: </b>", point$Track.Name, "<br/>",
                    "<b>", paste0(input$select1,":"),"</b> ", eval(parse(text=paste0("point$",tolower(input$select1)))), "<br/>",
                    "<b>", paste0(input$select2,":"),"</b> ", eval(parse(text=paste0("point$",tolower(input$select2)))), "<br/>")))
    )
  })
  
  output$plot2 <- renderPlot({
    
    return(ggplot(data = music.averages) + geom_col(mapping = aes_string(x = "genre", y = tolower(input$select3), fill = "genre"))
           + labs(title = paste("Average", input$select3, "for Each Genre")))
  })
  output$plot3 <- renderPlot({
    
    return(ggplot(data = audio.features) + geom_point(mapping = aes_string(x = "genre", y = tolower(input$select3), color = "genre"), size = 5) 
           + labs(title = paste("Specific Values of", input$select3, "for Each Genre")))
  })
  #liam server code
  #Valence Data Bar Graph
  output$plot4 <- renderPlot({
    option <- tolower(input$select4)
    return(ggplot()+
             geom_bar(data=high.avg, mapping =  aes(x=option), color='blue') +
             geom_bar(data=low.avg, mapping = aes(x=option),color='green')
           
    )
  })
  
  
}

shinyServer(my.server)
