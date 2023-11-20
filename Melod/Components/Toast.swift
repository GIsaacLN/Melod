//
//  Toast.swift
//  RecommendationChallenge
//
//  Created by Gustavo Isaac Lopez Nunez on 17/11/23.
//

import SwiftUI

struct Toast: View {
    var message: String

    var body: some View {
        HStack{
            Spacer()
            Text(message)
            Spacer()
        }
            .foregroundColor(.black)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 10)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
    }
}

#Preview {
    Toast(message: "Added to ...")
}
