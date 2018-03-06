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
                  choices = list("Danceability", "Energy", "Loudness", "Speechiness", "Acousticness", "Instrumentalness", "Liveness", "Valence", "Tempo"), 
                  selected = "Energy"),
      selectInput("select2", label = h3("With..."), 
                  choices = list("Danceability", "Energy", "Loudness", "Speechiness", "Acousticness", "Instrumentalness", "Liveness", "Valence", "Tempo"), 
                  selected = "Loudness")
    )
  )
)

shinyUI(my.ui)