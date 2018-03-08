my.ui <- fluidPage(
  
  titlePanel("Spotify Top 100 Trends (all data taken from Feburary 24th 2017)"),
  sidebarLayout(   
    mainPanel(
      div(
        style = "position:relative",
        plotOutput('plot1', hover = hoverOpts("plot_hover", delay = 100, delayType = "debounce")),
        uiOutput("hover_info")
      ),
      p("Using the graphs above, you can discover some interesting trends! 
        For example, energy and valence appear to have a highly positive correlation, perhaps indicating that high energy music tends to evoke happier emotions.
        Another interesting graph is speechiness and loudness which are slightly negativley correlated, indicating that louder music tends to include less spoken word.
        The most interesting correlation is perhaps between valence and danceability, which implies that happier music is easier to dance to within Spotify's top 100.
        One of the most illuminating aspects of these graphs is how Spotify's algorithmic values are not always perfect. 
        For example, the instrumentalness catagory is skewed heavily because of an Imagine Dragons song that is calculated by spotify to be ten times more instrument 
        based than the other tracks, which is objectivley not true. ")
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
      ),
    h1("Audio Features By Genre Analysis:"),
    textOutput('section2analysis')
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
      ),
      textOutput('section3analysis')
    ),
    sidebarPanel(
      #the options on what to compare, "valence" vs "whatever characteristic"
      selectInput("select4", label = h3("Audio Feature"), 
                  choices = list("Danceability", "Energy", "Loudness", "Speechiness", "Acousticness", "Instrumentalness", "Liveness", "Tempo", "Duration")
      )
    )
  )
)

shinyUI(my.ui)
