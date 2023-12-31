//
//  RecommendationChallengeApp.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 14/11/23.
//

import SwiftUI

@main
struct Melod: App {
    @StateObject var playlist = Playlist(title: "My Playlist #1", imageName: "dailyMix2", songs: [])

    var body: some Scene {
        WindowGroup {
            PlaylistDetailView(playlist: playlist).environmentObject(playlist)
        }
    }
}
