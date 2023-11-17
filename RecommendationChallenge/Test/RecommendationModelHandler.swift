//
//  RecommendationModelHandler.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 16/11/23.
//

import Foundation
import CoreML

class RecommendationModelHandler {
    private var model: SongRecommender?

    // Initialize the recommendation model
    init() {
        // Try to load the machine learning model...
        do {
            model = try SongRecommender(configuration: MLModelConfiguration())
        } catch {
            print("Error loading model: \(error)")
        }
    }

    // Generate song recommendations
    func makePredictions(for songs: [Song], k: Int) -> [String]? {
        // Implementation to make predictions...
        guard let model = model else {
            print("Model is not loaded.")
            return nil
        }
        
        // Prepare the items dictionary with combined titles
        let items = Dictionary(uniqueKeysWithValues: songs.map { ($0.combinedTitle, 1.0) })
        let input = SongRecommenderInput(items: items, k: Int64(k))
        
        do {
            let result = try model.prediction(input: input)
            return result.recommendations
        } catch {
            print("Error making predictions: \(error)")
            return nil
        }
    }
}
