//
//  Playlist.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 15/11/23.
//

import Foundation
import SwiftUI


class Playlist: ObservableObject {
    var title: String
    var imageName: String
    @Published var songs: [Song]

    init(title: String, imageName: String, songs: [Song]) {
        self.title = title
        self.imageName = imageName
        self.songs = songs
    }
}
