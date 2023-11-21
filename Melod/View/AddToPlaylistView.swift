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
    @State private var recommendations: [Song] = [] // Assuming Song is the model's output
    @State private var searchText = ""
    @State private var showToast = false // State to control toast visibility
    @State private var toastMessage = "" // State to hold the toast message
    @State private var loadingMore = false // Track if we are currently loading more items
    @State private var allRecommendations: [String] = [] // Hold all recommendations
    @State private var recommendationChunks: [[String]] = [] // Paginated recommendations
    @State private var currentPage = 0 // Current page of recommendations

    private let modelHandler = RecommendationModelHandler()

    private let pageSize = 20 // Number of recommendations to fetch per page

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
    
    private func loadAllRecommendations() {
        allRecommendations = modelHandler.makePredictions(for: playlist.songs, k: Int.max) ?? []
        paginateRecommendations()
    }

    private func paginateRecommendations() {
        recommendationChunks = allRecommendations.chunked(into: pageSize)
        if !recommendationChunks.isEmpty {
            recommendations = recommendationChunks[0].map(transformPredictionString)
        }
    }

    private func transformPredictionString(_ prediction: String) -> Song {
        let components = prediction.components(separatedBy: " - ")
        let title = components.first ?? "Unknown"
        let artist = components.count > 1 ? components[1] : "Unknown"
        return Song(title: title, artist: artist)
    }

    private func loadMoreRecommendationsIfNeeded(currentItem song: Song) {
        guard let last = recommendations.last, last == song, currentPage < recommendationChunks.count - 1 else { return }

        currentPage += 1
        let moreRecommendations = recommendationChunks[currentPage].map(transformPredictionString)
        recommendations.append(contentsOf: moreRecommendations)
    }

    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                SearchBar(text: $searchText)
                    .padding()

                // Use ScrollView instead of List
                ScrollView {
                    // Use LazyVStack to only load views as needed
                    LazyVStack {
                        // Suggested songs header
                        Text("Suggested songs")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .padding(.top)
                            .accessibilityAddTraits(.isHeader)

                        // Songs
                        ForEach(searchText.isEmpty ? recommendations : filteredSongs) { song in
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
                                    guard !playlist.songs.contains(song) else { return }
                                    playlist.songs.append(song)
                                    toastMessage = "Added to \(playlist.title)"
                                    loadAllRecommendations()
                                    withAnimation { showToast = true }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation { showToast = false }
                                    }
                                }) {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.accentColor)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding()
                            .background(Color(UIColor.tertiarySystemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .padding(.horizontal)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(song.title) by \(song.artist)")
                            .accessibilityHint("Double tap to add this song")
                            .accessibilityAction {
                                guard !playlist.songs.contains(song) else { return }
                                playlist.songs.append(song)
                                toastMessage = "Added to \(playlist.title)"
                                loadAllRecommendations()
                                withAnimation { showToast = true }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation { showToast = false }
                                }

                            }

                            .onAppear {
                                loadMoreRecommendationsIfNeeded(currentItem: song)
                            }
                        }
                        // Loading more view
                        if loadingMore {
                            ProgressView()
                                .padding()
                        }

                    }
                }
                .background(Color(UIColor.secondarySystemBackground)) // Match List background
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))

            }
            .overlay(showToast ? Toast(message: toastMessage) : nil, alignment: .bottom)
            .navigationBarTitle("Add to this playlist", displayMode: .inline)
            .navigationBarItems(leading: Button(action: { presentationMode.wrappedValue.dismiss() }) { Image(systemName: "xmark") })
            .onAppear{
                songs = loadSongs()
                loadAllRecommendations()
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


extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}


#Preview {
    AddToPlaylistView()
        .environmentObject(Playlist(title: "My Playlist #1", subtitle: "Playlist", imageName: "dailyMix2", songs: [Song(title: "Blinding Lights", artist: "The Weekend"), Song(title: "Shake It Off", artist: "Taylor Swift")]))
}
