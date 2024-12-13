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
            titleView
            
            if recipes.count == 1 {
                singleImageView
            } else {
                multipleImagesView
            }
        }
    }
}

// MARK: - View Components
private extension FeaturedCuisineView {
    var titleView: some View {
        Text(recipes.count == 1 ? "Featured \(cuisine) Dish" : "Explore \(cuisine) Dishes")
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(.appPink)
    }
    
    var singleImageView: some View {
        Group {
            if let recipe = recipes.first, let imageURL = recipe.photoURLLarge {
                CachedAsyncImage(url: imageURL)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        overlayGradient(for: recipe, isSingle: true)
                    )
            }
        }
    }
    
    var multipleImagesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(recipes, id: \.uuid) { recipe in
                    if let imageURL = recipe.photoURLLarge {
                        CachedAsyncImage(url: imageURL)
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay(
                                overlayGradient(for: recipe, isSingle: false)
                            )
                    }
                }
            }
        }
    }
    
    func overlayGradient(for recipe: Recipe, isSingle: Bool) -> some View {
        ZStack(alignment: .bottomLeading) {
            // Gradient overlay
            LinearGradient(
                colors: [
                    .appPink.opacity(isSingle ? 0.7 : 0.5),
                    isSingle ? .clear : .black.opacity(0.3)
                ],
                startPoint: .bottom,
                endPoint: .center
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            // Recipe name
            VStack {
                Spacer()
                Text(recipe.name)
                    .font(isSingle ? .title2 : .title3)
                    .fontWeight(isSingle ? .bold : .semibold)
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

#Preview {
    RecipeHome()
}

