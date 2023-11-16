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
    
    var body: some View {
        // Playlist Header
        VStack(alignment: .center) {
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
                            // Implement delete song action
                        }) {
                            Image(systemName: "minus.circle")
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
    PlaylistDetailView(playlist: Playlist(title: "My Playlist #1", subtitle: "Playlist", imageName: "heart.fill", songs: [Song(title: "Blinding Lights", artist: "The Weekend")]))
        .preferredColorScheme(.dark)
}
