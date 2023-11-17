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
        HStack (alignment: .center){
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $text)
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
        .foregroundColor(.primary)
        .padding(10)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}
