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
    @State private var addedSongs = Set<UUID>()

    func loadSongs() -> [Song] {
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
                            if !self.addedSongs.contains(song.id) {
                                self.playlist.songs.append(song)
                                self.addedSongs.insert(song.id)
                            }
                        }) {
                            Image(systemName: self.addedSongs.contains(song.id) ? "checkmark.circle.fill" : "plus.circle")
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                self.songs = loadSongs()
                self.updateAddedSongs()
            }

        }
    }
    
    var filteredSongs: [Song] {
        if searchText.isEmpty {
            return songs
        } else {
            return songs.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.artist.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

#Preview {
    AddToPlaylistView()
        .preferredColorScheme(.dark)
}
