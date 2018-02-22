library("httr")
library("jsonlite")
library("dplyr")
library("spotifyr") # install: 'devtools::install_github('charlie86/spotifyr')'
library("ggplot2")
source("keys.R")
top <- read.csv("regional-global-daily-latest.csv", stringsAsFactors = FALSE)
devtools::install_github('charlie86/spotifyr')
Sys.setenv(SPOTIFY_CLIENT_ID = client_id)
Sys.setenv(SPOTIFY_CLIENT_SECRET = secret_id)
access_token <- get_spotify_access_token()
Noisia.discog <- get_artist_audio_features('noisia')
stripName <- function(track.url) {
  return (substr(track.url, 32,100))
}
new.top <- top
audio.features.all <- data.frame()
for(row in 1:100) { #use nrow(top) for all songs in the csv
  music <- GET (paste0("https://api.spotify.com/v1/audio-features/", stripName(top[row, "URL"])), add_headers(Authorization = paste("Bearer", access_token)))
  body.2 <- content(music, "text") 
  parsed.song.2 <- fromJSON(body.2) 
  print(parsed.song.2)
  audio.features.all <- rbind(audio.features.all, parsed.song.2, stringsAsFactors = FALSE)
}
new.top <- slice(new.top, 1:100)
new.top$id <- audio.features.all$id
big.frame <- right_join(audio.features.all, new.top)
ggplot(data = big.frame) + geom_point(mapping = aes(x = Position, y = loudness)) + geom_smooth(mapping = aes(x = Position, y = loudness)) #+ facet_wrap(~key)
length <- mean(big.frame$duration_ms) #avg length: 3:30
loud <- mean(big.frame$loudness) #avg loud: -5.96
