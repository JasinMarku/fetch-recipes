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
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Hero Image with Cuisine Overlay
                    if let imageURL = recipe.photoURLLarge {
                            CachedAsyncImage(url: imageURL)
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 5)
                    }
                                        
                    // Recipe Info
                    VStack(alignment: .leading) {
                        Text(recipe.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                         Text("\(recipe.cuisine) Dish")
                             .font(.title3)
                             .foregroundStyle(.secondary.opacity(0.7))
                             .fontWeight(.semibold)
                    }
                    
                    Divider()
                    
                    ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Make this recipe:")
                            .foregroundStyle(.primary)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        if let youtubeURL = recipe.youtubeURL {
                            Link(destination: youtubeURL) {
                                HStack(spacing: 10) {
                                    Image("youtube")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                    
                                    Text("Watch Recipe Video")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(.red.gradient.opacity(0.2))
                                .cornerRadius(10)
                            }
                        }
                        
                        if let sourceURL = recipe.sourceURL {
                            Link(destination: sourceURL) {
                                HStack(spacing: 10) {
                                    Image("link")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    
                                    Text("View Full Recipe")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(.gray.gradient.opacity(0.2))
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .fontDesign(.rounded)
            }
            .padding(20)
        }
        .tint(.primary)
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
