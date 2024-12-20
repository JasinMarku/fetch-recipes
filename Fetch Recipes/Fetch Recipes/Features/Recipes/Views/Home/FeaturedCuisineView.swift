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
        SectionTitle(title: recipes.count == 1 ? "Featured \(cuisine) Dish" : "Explore \(cuisine) Dishes")
    }
    var singleImageView: some View {
        Group {
            if let recipe = recipes.first, let imageURL = recipe.photoURLLarge {
                RecipeImageButton(recipe: recipe) {
                    CachedAsyncImage(url: imageURL)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            overlayGradient(for: recipe, isSingle: true)
                        )
                }
            }
        }
    }
    
    var multipleImagesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(recipes, id: \.uuid) { recipe in
                    if let imageURL = recipe.photoURLLarge {
                        RecipeImageButton(recipe: recipe) {
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
    }
    
    func overlayGradient(for recipe: Recipe, isSingle: Bool) -> some View {
        ZStack(alignment: .bottomLeading) {
            // Gradient overlay
            LinearGradient(
                colors: [
                    .black.opacity(0.8), .clear
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

struct RecipeImageButton<Content: View>: View {
    let recipe: Recipe
    let content: () -> Content
    @State private var showDetailView = false
    
    init(recipe: Recipe, @ViewBuilder content: @escaping () -> Content) {
        self.recipe = recipe
        self.content = content
    }
    
    var body: some View {
        content()
            .contentShape(Rectangle())
            .onTapGesture {
                showDetailView = true
            }
            .sheet(isPresented: $showDetailView) {
                RecipeDetailView(recipe: recipe)
                    .presentationDetents([.fraction(0.9)])
                    .presentationDragIndicator(.hidden)
                    .presentationCornerRadius(25)
            }
    }
}

#Preview {
    RecipeHome()
}

