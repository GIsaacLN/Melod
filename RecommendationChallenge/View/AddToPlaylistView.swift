//
//  AddToPlaylistView.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 15/11/23.
//

import SwiftUI

struct AddToPlaylistView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var playlist: Playlist

    @State private var songs: [Song] = []
    @State private var searchText = ""
    @State private var showToast = false // State to control toast visibility
    @State private var toastMessage = "" // State to hold the toast message

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

    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                SearchBar(text: $searchText)
                    .padding()

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
                            if !playlist.songs.contains(song) {
                                playlist.songs.append(song)
                                toastMessage = "Added to \(playlist.title)"
                                withAnimation {
                                    showToast = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation {
                                        showToast = false
                                    }
                                }
                            }
                        }) {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            }
            .overlay(
                showToast ? Toast(message: toastMessage) : nil,
                alignment: .bottom
            )
            .onAppear {
                self.songs = loadSongs()
            }
        }
    }
    
    // Filter songs based on search text
    var filteredSongs: [Song] {
        let nonPlaylistSongs = songs.filter { song in
            !playlist.songs.contains(where: { $0.title == song.title && $0.artist == song.artist })
        }

        if searchText.isEmpty {
            return nonPlaylistSongs
        } else {
            return nonPlaylistSongs.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.artist.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

#Preview {
    AddToPlaylistView()
        .environmentObject(Playlist(title: "My Playlist #1", subtitle: "Playlist", imageName: "dailyMix2", songs: [Song(title: "Blinding Lights", artist: "The Weekend"), Song(title: "Shake It Off", artist: "Taylor Swift")]))
}
