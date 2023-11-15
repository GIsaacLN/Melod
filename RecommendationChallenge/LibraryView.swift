//
//  LibraryView.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 15/11/23.
//

import SwiftUI

struct LibraryView: View {
    let playlists: [Playlist] = [
        Playlist(
            title: "Liked Songs",
            subtitle: "241 songs",
            imageName: "heart.fill",
            songs: [
                Song(title: "Blinding Lights", artist: "The Weeknd"),
                Song(title: "Levitating", artist: "Dua Lipa"),
                Song(title: "Watermelon Sugar", artist: "Harry Styles")
            ]
        ),
        Playlist(
            title: "Indie Chillout",
            subtitle: "Isaac LN",
            imageName: "music.note.list",
            songs: [
                Song(title: "Breathe", artist: "Seafret"),
                Song(title: "Flightless Bird, American Mouth", artist: "Iron & Wine"),
                Song(title: "Sofia", artist: "Clairo")
            ]
        ),
        Playlist(
            title: "Workout Hits",
            subtitle: "Made for Isaac LN",
            imageName: "repeat",
            songs: [
                Song(title: "Stronger", artist: "Kanye West"),
                Song(title: "POWER", artist: "Kanye West"),
                Song(title: "Eye of the Tiger", artist: "Survivor")
            ]
        ),
        Playlist(
            title: "Focus Beats",
            subtitle: "Isaac LN",
            imageName: "hifispeaker.fill",
            songs: [
                Song(title: "Lo-fi Study", artist: "Lo-Fi Beats"),
                Song(title: "Coffee for Your Head", artist: "Powfu, beabadoobee"),
                Song(title: "In the End", artist: "Tom Misch")
            ]
        ),
        Playlist(
            title: "Top 50 - Global",
            subtitle: "Spotify",
            imageName: "globe.europe.africa.fill",
            songs: [
                Song(title: "Bad Guy", artist: "Billie Eilish"),
                Song(title: "Senorita", artist: "Shawn Mendes, Camila Cabello"),
                Song(title: "Dance Monkey", artist: "Tones And I")
            ]
        ),
        Playlist(
            title: "Chill Vibes",
            subtitle: "Spotify",
            imageName: "person.2.fill",
            songs: [
                Song(title: "Sunflower", artist: "Post Malone, Swae Lee"),
                Song(title: "Circles", artist: "Post Malone"),
                Song(title: "Memories", artist: "Maroon 5")
            ]
        )
    ]

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Recents").font(.headline)) {
                    ForEach(playlists) { playlist in
                        // Update the destination to point to PlaylistDetailView
                        NavigationLink(destination: PlaylistDetailView(playlist: playlist)) {
                            HStack {
                                Image(systemName: playlist.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.accentColor)
                                    .padding()
                                    .background(Color(UIColor.systemGray6))
                                    
                                VStack(alignment: .leading) {
                                    Text(playlist.title)
                                        .font(.headline)
                                    Text(playlist.subtitle)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Your Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    LibraryView()
        .preferredColorScheme(.dark)
}
