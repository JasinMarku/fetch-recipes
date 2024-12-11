//
//  EmptyStateView.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/11/24.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    let image: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
        EmptyStateView(
            title: "No Recipes Found",
            message: "Your plate is empty at the moment. Refresh or try again soon.",
            image: "emptystate"
        )
}
