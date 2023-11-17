//
//  PlaylistView.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 15/11/23.
//

import SwiftUI

struct PlaylistDetailView: View {
    @ObservedObject var playlist: Playlist
    @State private var showingAddToPlaylist = false
    @State private var recommendations: [String] = []
    
    private let modelHandler = RecommendationModelHandler()
    
    private func updateRecommendations() {
        recommendations = modelHandler.makePredictions(for: playlist.songs, k: 5) ?? []
    }
    
    private func deleteSong(song: Song) {
        if let index = playlist.songs.firstIndex(of: song) {
            playlist.songs.remove(at: index)
            updateRecommendations()
        }
    }
    
    private func delete(at offsets: IndexSet) {
        playlist.songs.remove(atOffsets: offsets)
    }
    
    private func addSong(recommendation: String) {
        let parts = recommendation.components(separatedBy: " - ")
        let title = parts[0]
        let artist = parts.count > 1 ? parts[1] : "Unknown Artist"
        let song = Song(title: title, artist: artist) // Assuming `Song` can be initialized like this.
        
        if !self.playlist.songs.contains(where: { $0.title == song.title && $0.artist == song.artist }) {
            self.playlist.songs.append(song)
            updateRecommendations()
        }
    }

    var body: some View {
        // Playlist Header
        VStack(alignment: .center) {
            Image(playlist.imageName) // Replace with actual image loading if needed
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .cornerRadius(8)
                .padding(.vertical)
            
            Text(playlist.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(playlist.subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        List {
            // Songs list
            Section(header: Text("Songs").font(.headline)){
                Button(action: {
                    showingAddToPlaylist.toggle()
                }) {
                    Image(systemName: "plus")
                    Text("Add to this playlist")
                    Spacer()
                }
                .buttonStyle(BorderedButtonStyle())
                .sheet(isPresented: $showingAddToPlaylist) {
                    AddToPlaylistView().environmentObject(playlist)
                }

                ForEach(playlist.songs) { song in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .fontWeight(.medium)
                            Text(song.artist)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button(action: {
                            self.deleteSong(song: song)
                        }) {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            
            Section(header: Text("Suggested For You").font(.headline)) {
                ForEach(recommendations, id: \.self) { recommendation in
                    HStack {
                        VStack(alignment: .leading) {
                            let parts = recommendation.components(separatedBy: " - ")
                            let title = parts[0]
                            let artist = parts.count > 1 ? parts[1] : "Unknown Artist"
                            
                            Text(title)
                                .fontWeight(.medium)
                            Text(artist)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button(action: {
                            self.addSong(recommendation: recommendation)
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .onChange(of: showingAddToPlaylist, {
            updateRecommendations()
        })
        .onAppear {
            updateRecommendations()
        }
    }
}

#Preview {
    PlaylistDetailView(playlist: Playlist(title: "My Playlist #1", subtitle: "Playlist", imageName: "dailyMix2", songs: [Song(title: "Blinding Lights", artist: "The Weekend"), Song(title: "Shake It Off", artist: "Taylor Swift")]))
}
