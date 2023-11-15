//
//  ContentView.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 14/11/23.
//

import SwiftUI

struct ContentView: View {
    
    // Array de datos para tus tarjetas
    let cards = [
        Playlist(title: "Daily Mix 1", color: Color.red, subtitle: "Lorem ipsum", imageName: "dailyMix1"),
        Playlist(title: "Daily Mix 2", color: Color.green, subtitle: "Lorem ipsum", imageName: "dailyMix2"),
        Playlist(title: "Daily Mix 2", color: Color.blue, subtitle: "Lorem ipsum", imageName: "dailyMix3")
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: LikedSongsView() ){
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.white)
                            .padding(15)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        Text("Liked Songs")
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Made For You")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(cards) { card in
                                NavigationLink(destination: LikedSongsView()) {
                                    VStack {
                                        ZStack(alignment: .bottomLeading) {
                                            Image(card.imageName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 200, height: 200)
                                                .clipped()
                                                .cornerRadius(8)
                                                .overlay(
                                                    WaveOverlayShape()
                                                        .fill(LinearGradient(gradient: Gradient(colors: [card.color.opacity(0.9), card.color.opacity(0.9)]), startPoint: .top, endPoint: .bottom))
                                                        .frame(height: 250)
                                                        .offset(y: 130) // Desplaza el overlay hacia abajo
                                                )
                                            
                                            Text(card.title)
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                                .padding()
                                        }
                                        .frame(width: 200, height: 200)
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(8)
                                        
                                        Text(card.subtitle)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    }
                                }
                                
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
