//
//  FeaturedCuisineView.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/12/24.
//

import SwiftUI

struct FeaturedCuisineView: View {
    let cuisine: String
    let recipes: [Recipe]
    
    var body: some View {
        VStack(alignment: .leading) {
            if recipes.count == 1 {
                Text("Featured \(cuisine) Dish")
                    .font(.title3)
                    .fontWeight(.semibold)
            } else {
                Text("Explore \(cuisine) Dishes")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            if recipes.count == 1 {
                // Single image
                if let recipe = recipes.first, let imageURL = recipe.photoURLLarge {
                    CachedAsyncImage(url: imageURL)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            ZStack(alignment: .bottomLeading) {
                                // Black gradient overlay
                                LinearGradient(
                                    colors: [.black.opacity(0.7), .clear],
                                    startPoint: .bottom,
                                    endPoint: .center
                                )
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                
                                // Text content
                                VStack {
                                    Spacer()
                                    Text(recipe.name)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding()
                                }
                            }
                        )
                }
            } else {
                // Multiple images
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(recipes, id: \.uuid) { recipe in
                            if let imageURL = recipe.photoURLLarge {
                                CachedAsyncImage(url: imageURL)
                                    .frame(width: 200, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .overlay(
                                        ZStack(alignment: .bottomLeading) {
                                            // Black gradient overlay
                                            LinearGradient(
                                                colors: [.black.opacity(0.7), .clear],
                                                startPoint: .bottom,
                                                endPoint: .center
                                            )
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                            
                                            // Text content
                                            VStack {
                                                Spacer()
                                                Text(recipe.name)
                                                    .font(.title3)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)
                                                    .padding()
                                            }
                                        }
                                    )
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RecipeListView()
}
