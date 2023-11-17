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
    
    private func deleteSong(at offsets: IndexSet) {
        playlist.songs.remove(atOffsets: offsets)
        updateRecommendations()
    }
    
    private func addSong(recommendation: String) {
        let parts = recommendation.components(separatedBy: " - ")
        let title = parts[0]
        let artist = parts.count > 1 ? parts[1] : "Unknown Artist"
        
        if !playlist.songs.contains(where: { $0.title == title && $0.artist == artist }) {
            playlist.songs.append(Song(title: title, artist: artist))
            updateRecommendations()
        }
    }

    var body: some View {
        // Playlist Header
        VStack(alignment: .center) {
            Image(playlist.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(8)
                .padding(.vertical)
        }
        VStack(alignment: .leading) {
            Text(playlist.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(playlist.subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        Button(action: {
            showingAddToPlaylist.toggle()
        }) {
            HStack {
                Image(systemName: "plus")
                Text("Add to this playlist")
                Spacer()
            }
        }
        .buttonStyle(BorderedButtonStyle())
        .padding(.horizontal, 10)
        .sheet(isPresented: $showingAddToPlaylist) {
            AddToPlaylistView().environmentObject(playlist)
        }

        List {
            // Songs list
            Section{
                ForEach(playlist.songs) { song in
                    VStack(alignment: .leading) {
                        Text(song.title)
                            .fontWeight(.medium)
                        Text(song.artist)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete(perform: deleteSong) // Add this line
            }
            VStack(alignment: .leading) {
                Text("Recommended songs")
                    .font(.headline)
                Text("Based on the songs of this playlist").font(.subheadline)
            }
            .padding(.vertical)
            
            Section {
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
