library("httr")
library("jsonlite")
library("dplyr")
library("spotifyr") # install: 'devtools::install_github('charlie86/spotifyr')'
library("ggplot2")
source("keys.R")
top <- read.csv("regional-global-daily-latest.csv", stringsAsFactors = FALSE)
#devtools::install_github('charlie86/spotifyr')
Sys.setenv(SPOTIFY_CLIENT_ID = client_id)
Sys.setenv(SPOTIFY_CLIENT_SECRET = secret_id)
access_token <- get_spotify_access_token()

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
write.csv(big.frame, file = "big_table.csv")

# Extra stuff that I was testing


# length <- mean(big.frame$duration_ms) #avg length: 3:30
# loud <- mean(big.frame$loudness) #avg loud: -5.96
# Noisia.discog <- get_artist_audio_features('noisia')

#/v1/users/{user_id}/playlists/{playlist_id}

uri.base <- "https://api.spotify.com/v1/users/"

#spotify:user:spotify:playlist:37i9dQZF1DX0XUsuxWHRQd    rap
#spotify:user:spotify:playlist:37i9dQZF1DX1lVhptIYRda    country
#spotify:user:spotify:playlist:37i9dQZF1DXcF6B6QPhFDv    rock
#spotify:user:spotify:playlist:37i9dQZF1DX6aTaZa0K6VA    pop
#spotify:user:spotify:playlist:37i9dQZF1DWWEJlAGA9gs0    classical

playlist.ids <- list("37i9dQZF1DX0XUsuxWHRQd", "37i9dQZF1DX1lVhptIYRda", "37i9dQZF1DXcF6B6QPhFDv", "37i9dQZF1DX6aTaZa0K6VA", "37i9dQZF1DWWEJlAGA9gs0")

final.music.dataframe <- data.frame()

for(row in 1:5){
  
  music <- GET(paste0(uri.base, "spotify/playlists/", playlist.ids[row], "/tracks"), add_headers(Authorization = paste("Bearer", access_token)))
  music.body <- content(music, "text")
  music.data <- data.frame(data.frame(fromJSON(music.body)[2])[4])
  music.uris <- select(music.data[1:25,1], uri)[1:25,1]
  music.uris <- gsub("spotify:track:", "", music.uris)
  if(row == 1){
    music.dataframe <- data.frame(music.uris, "rap")
  }else if(row == 2){
    music.dataframe <- data.frame(music.uris, "country")
  }else if(row == 3){
    music.dataframe <- data.frame(music.uris, "rock")
  }else if(row == 4){
    music.dataframe <- data.frame(music.uris, "pop")
  }else{
    music.dataframe <- data.frame(music.uris, "classical")
  }
  colnames(music.dataframe)[1] <- "uri" 
  colnames(music.dataframe)[2] <- "genre" 
  final.music.dataframe <- rbind(final.music.dataframe, music.dataframes)
}

audio.features <- data.frame()
for(row in 1:125) { #use nrow(top) for all songs in the csv
  track.data <- GET (paste0("https://api.spotify.com/v1/audio-features/", final.music.dataframe[row, 1]), add_headers(Authorization = paste("Bearer", access_token)))
  track.body <- content(track.data, "text")         
  track <- data.frame(fromJSON(track.body)) %>% mutate(genre =  music.dataframes[row, 2])
  audio.features <- rbind(audio.features, track, stringsAsFactors = FALSE)
}

classical.averages <- filter(audio.features, genre == "classical") %>% 
  summarise(danceability = mean(danceability), energy = mean(energy), key = mean(key), loudness = mean(loudness),
            speechiness = mean(speechiness), acousticness = mean(acousticness), instrumentalness = mean(instrumentalness),
            liveness = mean(liveness), valence = mean(valence), tempo = mean(tempo), duration_ms = mean(duration_ms)) %>% mutate(genre = "classical")

country.averages <- filter(audio.features, genre == "country") %>% 
  summarise(danceability = mean(danceability), energy = mean(energy), key = mean(key), loudness = mean(loudness),
            speechiness = mean(speechiness), acousticness = mean(acousticness), instrumentalness = mean(instrumentalness),
            liveness = mean(liveness), valence = mean(valence), tempo = mean(tempo), duration_ms = mean(duration_ms)) %>% mutate(genre = "country")

pop.averages <- filter(audio.features, genre == "pop") %>% 
  summarise(danceability = mean(danceability), energy = mean(energy), key = mean(key), loudness = mean(loudness),
            speechiness = mean(speechiness), acousticness = mean(acousticness), instrumentalness = mean(instrumentalness),
            liveness = mean(liveness), valence = mean(valence), tempo = mean(tempo), duration_ms = mean(duration_ms)) %>% mutate(genre = "pop")

rap.averages <- filter(audio.features, genre == "rap") %>% 
  summarise(danceability = mean(danceability), energy = mean(energy), key = mean(key), loudness = mean(loudness),
            speechiness = mean(speechiness), acousticness = mean(acousticness), instrumentalness = mean(instrumentalness),
            liveness = mean(liveness), valence = mean(valence), tempo = mean(tempo), duration_ms = mean(duration_ms)) %>% mutate(genre = "rap")

rock.averages <- filter(audio.features, genre == "rock") %>% 
  summarise(danceability = mean(danceability), energy = mean(energy), key = mean(key), loudness = mean(loudness),
            speechiness = mean(speechiness), acousticness = mean(acousticness), instrumentalness = mean(instrumentalness),
            liveness = mean(liveness), valence = mean(valence), tempo = mean(tempo), duration_ms = mean(duration_ms)) %>% mutate(genre = "rock")



music.averages <- rbind(classical.averages, country.averages, pop.averages, rap.averages, rock.averages, stringsAsFactors = FALSE)

