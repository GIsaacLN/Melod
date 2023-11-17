//
//  Recommender.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 16/11/23.
//

import Foundation

struct Recommendation: Identifiable, Decodable {
    let id: UUID
    let song: Song
}
