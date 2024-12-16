//
//  RecipeDetailView.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/13/24.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 20) {
                    
                    // Hero Image with Cuisine Overlay
                    if let imageURL = recipe.photoURLLarge {
                        CachedAsyncImage(url: imageURL)
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                            .ignoresSafeArea(edges: .top)
                    }

                    SectionTitle(title: "Dish Overview")
                        .padding(.horizontal)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                                                    
                            Text(recipe.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("\(recipe.cuisine) Dish")
                                .font(.title3)
                                .foregroundStyle(.secondary.opacity(0.7))
                                .fontWeight(.semibold)
                                                        
                            
                            if let youtubeURL = recipe.youtubeURL {
                                LinkCard(title: "Video Tutorial", subtitle: "Step-by-Step", imageName: "youtube", destination: youtubeURL, accentColor: Color.mainAppAccent)
                            }
                            
                            if let sourceURL = recipe.sourceURL {
                                LinkCard(title: "Full Recipe", subtitle: "History & Guide", imageName: "recipe", destination: sourceURL, accentColor: Color.mainAppAccent)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .tint(.primary)
    }
}

private extension RecipeDetailView {
    struct LinkCard: View {
        let title: String
         let subtitle: String
         let imageName: String
         let destination: URL
         let accentColor: Color
        
        var body: some View {
            HStack(spacing: 10) {
                // Leading Image
                Image(imageName)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(accentColor)
                
                // Title and Subtitle
                HStack {
                    Text(title)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .fontWeight(.semibold)
                }
                
                Spacer()

                // Chevron
                Image(systemName: "chevron.right")
                    .foregroundStyle(accentColor)
            }
            .padding()
            .background(.thickMaterial)
            .cornerRadius(10)
        }
    }
}

#Preview {
    RecipeDetailView(recipe: Recipe(
        cuisine: "Malaysian",
        name: "Apam Balik",
        uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
        photoURLLarge: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"),
        photoURLSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"),
        sourceURL: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ"),
        youtubeURL: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
    ))
}
