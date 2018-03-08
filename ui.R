my.ui <- fluidPage(
  
  titlePanel("Spotify Top 100 Trends"),
  sidebarLayout(   
    mainPanel(
      div(
        style = "position:relative",
        plotOutput('plot1', hover = hoverOpts("plot_hover", delay = 100, delayType = "debounce")),
        uiOutput("hover_info")
      )
    ),
    sidebarPanel(
      selectInput("select1", label = h3("Compare..."), 
                  choices = list("Danceability", "Energy", "Loudness", "Speechiness", "Acousticness", "Instrumentalness", "Liveness", "Valence", "Tempo", "Duration_ms"), 
                  selected = "Energy"),
      selectInput("select2", label = h3("With..."), 
                  choices = list("Danceability", "Energy", "Loudness", "Speechiness", "Acousticness", "Instrumentalness", "Liveness", "Valence", "Tempo", "Duration_ms"), 
                  selected = "Loudness")
    )
  ),
  
  titlePanel("Audio Features By Genre"),
  sidebarLayout(
    mainPanel(
      div(
        plotOutput('plot2'),
        plotOutput('plot3')
      )
    ),
    sidebarPanel(
      selectInput("select3", label = h3("Audio Feature"), 
                  choices = list("Danceability", "Energy", "Loudness", "Speechiness", "Acousticness", "Instrumentalness", "Liveness", "Valence", "Tempo", "Duration_ms"), 
                  selected = "Energy")
    )
  ),
  #liam
  titlePanel("Audio Features vs Valence"),
  sidebarLayout( 
    mainPanel(
      div(
        plotOutput('plot4')
      )
    ),
    sidebarPanel(
      #the options on what to compare, "valence" vs "whatever characteristic"
      selectInput("select4", label = h3("Characteristic"), 
                  choices = list("Danceability", "Energy", "Loudness", "Speechiness", "Acousticness", "Instrumentalness", "Liveness", "Tempo", "Duration")
      )
    )
  )
  
)

shinyUI(my.ui)
