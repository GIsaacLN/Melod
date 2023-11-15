//
//  AddToPlaylistView.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 15/11/23.
//

import SwiftUI

struct AddToPlaylistView: View {
    @Environment(\.presentationMode) var presentationMode
    let songs: [Song] = [
        Song(title: "Lo-fi Study", artist: "Lo-Fi Beats"),
        Song(title: "Coffee for Your Head", artist: "Powfu, beabadoobee"),
        Song(title: "In the End", artist: "Tom Misch"),
        Song(title: "Blinding Lights", artist: "The Weeknd"),
        Song(title: "Levitating", artist: "Dua Lipa"),
        Song(title: "Watermelon Sugar", artist: "Harry Styles")]

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()
                    Text("Add to this playlist")
                        .font(.headline)
                    Spacer()
                    // If you have an icon for this, replace Text with Image
                }
                .padding()

                // Your search bar here

                List(songs) { song in
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
                            // Action to add song to playlist
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    AddToPlaylistView()
}
