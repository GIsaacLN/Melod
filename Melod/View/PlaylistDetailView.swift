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
        VStack(alignment: .center) {
            Image(playlist.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(8)
                .padding(.top)
                .accessibility(label: Text("\(playlist.title)"))

            VStack(alignment: .leading) {
                Text(playlist.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .accessibility(addTraits: .isHeader)

                Text(playlist.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            Button(action: {
                showingAddToPlaylist.toggle()
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add to this playlist")
                    Spacer()
                }
                .padding([.top,.horizontal])
            }
            .buttonStyle(PlainButtonStyle())
            .accessibility(label: Text("Add to this playlist"))
            .sheet(isPresented: $showingAddToPlaylist) {
                AddToPlaylistView().environmentObject(playlist)
            }


            ScrollView {
                LazyVStack {
                    Text("Songs")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .top])
                        .padding(.bottom, 5)
                        .accessibilityAddTraits(/*@START_MENU_TOKEN@*/.isHeader/*@END_MENU_TOKEN@*/)
                    
                    if playlist.songs.isEmpty {
                        Text("Your playlist is empty.")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                    } else {
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
                            .padding()
                            .background(Color(UIColor.tertiarySystemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .padding(.horizontal)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel("\(song.title) by \(song.artist)")
                            .accessibilityHint("Double tap to delete this song")
                            .accessibilityAction {
                                self.deleteSong(song: song)
                            }

                        }
                    }
                    
                    VStack {
                        Text("Recommended songs")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading, .top])
                        Text("Based on the songs of this playlist")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading])
                            .padding(.bottom, 5)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isHeader)


                    ForEach(recommendations, id: \.self) { recommendation in
                        let parts = recommendation.components(separatedBy: " - ")
                        let title = parts[0]
                        let artist = parts.count > 1 ? parts[1] : "Unknown Artist"
                        HStack {

                            VStack(alignment: .leading) {
                                
                                Text(title)
                                    .fontWeight(.medium)
                                Text(artist)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                addSong(recommendation: recommendation)
                            }) {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.accentColor)
                            }
                            .accessibility(label: Text("Add \(title) to the playlist"))
                        }
                        .padding()
                        .background(Color(UIColor.tertiarySystemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 1)
                        .padding(.horizontal)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(title) by \(artist)")
                        .accessibilityHint("Double tap to add this song")
                        .accessibilityAction {
                            self.addSong(recommendation: recommendation)

                        }
                    }
                }
            }
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)

        }
        .onChange(of: showingAddToPlaylist) {
            updateRecommendations()
        }
        .onAppear {
            updateRecommendations()
        }
    }
}

#Preview {
    PlaylistDetailView(playlist: Playlist(title: "My Playlist #1", subtitle: "Playlist", imageName: "dailyMix2", songs: [Song(title: "Blinding Lights", artist: "The Weekend"), Song(title: "Shake It Off", artist: "Taylor Swift")]))
}
