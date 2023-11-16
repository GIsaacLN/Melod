//
//  SearchBar.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 16/11/23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $text)
                .foregroundColor(.primary)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
    }
}
