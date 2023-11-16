//
//  Song.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 15/11/23.
//

import Foundation

struct Song: Decodable, Identifiable, Hashable {
    let id = UUID()
    let title: String
    let artist: String
}
