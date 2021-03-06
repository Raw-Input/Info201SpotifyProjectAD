# Info 201 Project README

This project focused on using the Spotify API to retrieve data about the audio features of specific groups of music. Our project was divided up into 3 sections, one for each group member, and we each focused on a specific question we were trying to answer. We developed our report as an interactive Shiny app.

## An overview of audio features within Spotify's API

Spotify has several audio features that it calculates for each track in its database. We used these audio features as the main tool for answering our questions. Here is what each of the 10 audio features we used specifies, seperated into two groups: discrete and algorithmic features. Discrete means that the values are directly measured in scientific units while algorithmic means the values are calculated using proprietary algorithms and are on a scale from 1 to 0.

**Discrete**

- *Duration_ms* - The duration of the track in milliseconds.
- *Loudness* - The overall loudness of a track in decibels (dB). Loudness values are averaged across the entire track and are useful for comparing relative loudness of tracks.
- *Tempo* - The overall estimated tempo of a track in beats per minute (BPM). In musical terminology, tempo is the speed or pace of a given piece and derives directly from the average beat duration.

**Algorithmic**

- *Acousticness* - A confidence measure from 0.0 to 1.0 of whether the track is acoustic. 1.0 represents high confidence the track is acoustic.
- *Danceability* - Danceability describes how suitable a track is for dancing based on a combination of musical elements including tempo, rhythm stability, beat strength, and overall regularity. A value of 0.0 is least danceable and 1.0 is most danceable.
- *Energy* - Energy is a measure from 0.0 to 1.0 and represents a perceptual measure of intensity and activity. Typically, energetic tracks feel fast, loud, and noisy. For example, death metal has high energy, while a Bach prelude scores low on the scale. Perceptual features contributing to this attribute include dynamic range, perceived loudness, timbre, onset rate, and general entropy.
- *Instrumentalness* - Predicts whether a track contains no vocals. "Ooh" and "aah" sounds are treated as instrumental in this context. Rap or spoken word tracks are clearly "vocal". The closer the instrumentalness value is to 1.0, the greater likelihood the track contains no vocal content. Values above 0.5 are intended to represent instrumental tracks, but confidence is higher as the value approaches 1.0.
- *Liveness* - Detects the presence of an audience in the recording. Higher liveness values represent an increased probability that the track was performed live. A value above 0.8 provides strong likelihood that the track is live.
- *Speechiness* - Speechiness detects the presence of spoken words in a track. The more exclusively speech-like the recording (e.g. talk show, audio book, poetry), the closer to 1.0 the attribute value. Values above 0.66 describe tracks that are probably made entirely of spoken words. Values between 0.33 and 0.66 describe tracks that may contain both music and speech, either in sections or layered, including such cases as rap music. Values below 0.33 most likely represent music and other non-speech-like tracks.
- *Valence* - A measure from 0.0 to 1.0 describing the musical positiveness conveyed by a track. Tracks with high valence sound more positive (e.g. happy, cheerful, euphoric), while tracks with low valence sound more negative (e.g. sad, depressed, angry).

# Part 1: Spotify Top 100 Trends

Finding relationships in popular music can help artists and music industry professionals better cater to their audiences. These relationships can also tell us a lot about our music culture as a whole. For this part we took the top 100 most played songs on Spotify from Feburary 24th and analyzed their audio features. Since Spotify's API does not have a specific endpoint for finding the top 100 tracks, we used a third party website (https://spotifycharts.com) to download the top 100 as a csv file which we could then load into R and call various things using the Spotify API. We were able to produce an interactive scatterplot graph where you can change the x and y axis to represent an audio feature. The graph included a trend line to show how these audio features correlated with each other within the top 100. The color of the dots in the scatterplot corresponded to how high up the chart each individual song was, with lighter colors indicating the song was more popular. By hovering over a dot on the plot, users could see the name of the song, the artists, the rank it had on Spotify, and the values of the audio features that had been selected.

Using these graphs, we were able to determine a number of interesting correlations within top 100 music. We detailed some of them within the app.

# Part 2: Audio Features By Genre

The possibilities for how music can sound are endless, however many of the millions of songs available on Spotify will have a similar style. The different styles of music are what we call genres. Sticking to a specific genre can be beneficial to members of the music industry as it can help them better suit their music to a specific audience. Therefore, knowing the trends of the values of different audio features of different genres would be beneficial as it would help one know if their music statistically fits into a genre. For this part of the project we selected five common genres and, using the Spotify API, gathered data on popular songs from those genres so that this data could be compared and trends between genres could be seen. We were able to produce a bar graph, which displays the average value of the selected audio feature for each genre, and a point plot, which displayed the individual values gathered. These charts also included interactivity for the user as the user is able to select which audio feature they would like to see the data for, and then both charts change to display the correct data.

Using these charts, we were able to determine a number of interesting correlations within the samples from each genre. We detailed some of them within the app. Within the app the analysis on the discovered patterns changes based on the selected audio feature.


# Part 3: Audio Features vs. Valence

All songs have a certain Valence, or positivity, associated with them. Songs with a high valence are more positive, while songs with a low valence value tend to be more negative and depressing. In this project, the top 100 most popular tracks on Spotify were selected and sorted by valence. Songs with a high valence (>0.75) and low valence (<0.25) were considered in this data and were used to find trends between the valence of a track and several specific audio features. The data for both groups is then displayed side by side in order to show not only the relationship between valence and these features, but how those relationships compare with songs on the opposite end of the valence spectrum. This data can be useful for users who tend to listen to music that has a high or low valence by informing them of what impact that will have on the music they listen to. In the app many of these relationships are explained following the visual representation of the data.


# NOTE

In order for our code to work with shinyapps.io and without giving up our spotify developer keys, the repository for our project contains csv files that we obtained using the API. However to view the code that produced those files one can look at spotify_code.R
