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
  output$section2analysis <- renderText({
    
    selection <- input$select3
    if(selection == "Danceability"){
      return("Rap had the highest average danceability rating of the genres tested. All other genres had similar scores to that of rap, except classical, which, as expected, had a very low average danceability rating.")
    }else if(selection == "Energy"){
      return("Rock had the highest average energy rating of the genres tested. All other genres had similar scores to that of rock, except classical, which had a very low average energy rating.")
    }else if(selection == "Loudness"){
      return("Classical had the lowest average loudness rating of the tested genres, being well below the other tested genres.")
    }else if(selection == "Speechiness"){
      return("Rap clearly had the highest average speechiness rating of the tested genres, which was expected due to the nature of rap music.")
    }else if(selection == "Acousticness"){
      return("As the majority of classical music is acoustic, and the majority of the other genres are not, it makes sense that classical is the only genre with an average acoustic rating close to 1.")
    }else if(selection == "Instrumentalness"){
      return("As the majority of classical music contains no words, and the majority of the other genres do contain words, it makes sense that classical is the only genre with an average instrumentalness rating close to 1.")
    }else if(selection == "Liveness"){
      return("Rap had the highest average liveness rating of the genres tested. All other genres had similar scores to that of rap.")
    }else if(selection == "Valence"){
      return("Country had the highest average valence of the genres tested. All other genres had similar scores to that of country, except classical, which had a very low average valence.")
    }else if(selection == "Tempo"){
      return("Average tempo was the closest of all the audio features. Rock was barely ahead of the other genres.")
    }else{
      return("Classical music had the longest average duration, and the rest of the genres had similar ratings.")
    }

  })
  #Valence Data Bar Graph
  output$plot4 <- renderPlot({
    option <- tolower(input$select4)
    averages <- rbind(high.avg, low.avg)
    rownames(averages) <- c("high_average", "low_average")
    return(
      ggplot(data = averages, aes(x = rownames(averages), y = eval(parse(text=option)))) +
      geom_bar(stat = "identity", fill="steelblue") + labs(y = toString(option))
      )
  })
  output$section3analysis <- renderText({
    "This section compares different audio features for songs with a high valence, and those with a low valence. 
    Valence is the positivity of the song. After selecting a specific audio feature you can see the relationship that valence
    has.Some features such as Acousticness were nearly identical for both high and low valence. However features such as 
    Intrumentalness were very different when comparing high and low valence songs."
    
  })
  
  
}

shinyServer(my.server)
