//
//  Playlist.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 15/11/23.
//

import Foundation
import SwiftUI


struct Playlist: Identifiable{
    let id = UUID()
    let title: String
    var color: Color = Color.red
    var subtitle: String
    var imageName: String
    var songs: [Song]?

}
