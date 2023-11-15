//
//  PlaylistView.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 15/11/23.
//

import SwiftUI

struct PlaylistDetailView: View {
    let playlist: Playlist
    @State private var showingAddToPlaylist = false
    
    var body: some View {
        // Playlist Header
        VStack(alignment: .leading) {
            Image(systemName: playlist.imageName) // Replace with actual image loading if needed
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
                        .foregroundColor(.accentColor)
                    Text("Add to this playlist")
                }
                .buttonStyle(BorderedButtonStyle())
                .sheet(isPresented: $showingAddToPlaylist) {
                    AddToPlaylistView()
                }
                
                ForEach(playlist.songs ?? []) { song in
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
                            // Implement like action
                        }) {
                            Image(systemName: "heart")
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Section(header: Text("Suggested For You").font(.headline)) {
                
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PlaylistDetailView(playlist: Playlist(title: "Liked Songs", subtitle: "2,113 songs", imageName: "heart.fill", songs: [Song(title: "Money Trees", artist: "Kendrick Lamar, Jay Rock"),         Song(title: "Reaggeton Champagne", artist: "Dany Flow")]))
        .preferredColorScheme(.dark)
}
