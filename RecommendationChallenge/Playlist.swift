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
    let color: Color
    var subtitle: String
    var imageName: String // Asume que usarás imágenes locales
}
