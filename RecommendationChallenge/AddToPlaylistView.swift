//
//  AddToPlaylistView.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 15/11/23.
//

import SwiftUI

struct AddToPlaylistView: View {
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @EnvironmentObject var playlist: Playlist // Playlist data
    var modelHandler: RecommendationModelHandler // For generating recommendations

    @State private var songs: [Song] = [] // List of all songs
    @State private var searchText = "" // For filtering songs
    @State private var addedSongs = Set<UUID>() // IDs of added songs

    // Load songs from a local JSON file
    func loadSongs() -> [Song] {
        // Implementation to load songs...
        guard let url = Bundle.main.url(forResource: "songs", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return []
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Song].self, from: data)
        } catch {
            print("Error loading songs: \(error)")
            return []
        }
    }
    
    // Add a song to the playlist and update recommendations
    private func addSongToPlaylistAndUpdateRecommendations(song: Song) {
        // Implementation to add song and update recommendations...
        if !self.playlist.songs.contains(song) {
            self.playlist.songs.append(song)
            self.addedSongs.insert(song.id)
            // Update the recommendations since the playlist has changed
            DispatchQueue.global(qos: .userInitiated).async {
                let newRecommendations = self.modelHandler.makePredictions(for: self.playlist.songs, k: 5) ?? []
                DispatchQueue.main.async {
                    // It's not clear where `self.recommendations` is declared in your `AddToPlaylistView`
                    // You might want to pass a binding to `PlaylistDetailView`'s recommendations or use another method to update it
                }
            }
        }
    }

    // Keep track of added songs
    func updateAddedSongs() {
        addedSongs = Set(playlist.songs.map { $0.id })
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "multiply")
                    }
                    Spacer()
                    Text("Add to this playlist")
                        .font(.headline)
                    Spacer()
                }
                .padding()

                SearchBar(text: $searchText)
                    .padding(.horizontal)

                List(filteredSongs) { song in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .font(.headline)
                            Text(song.artist)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Button(action: {
                            addSongToPlaylistAndUpdateRecommendations(song: song)
                        }) {
                            Image(systemName: self.addedSongs.contains(song.id) ? "checkmark.circle.fill" : "plus.circle")
                        }
                    }
                }
            }
            .onAppear {
                self.songs = loadSongs()
                self.updateAddedSongs()
            }
        }
    }
    
    // Filter songs based on search text
    var filteredSongs: [Song] {
        if searchText.isEmpty {
            return songs
        } else {
            return songs.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.artist.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
