//
//  RecipeCell.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/11/24.
//

import SwiftUI

struct RecipeCell: View {
    let recipe: Recipe
    @State private var showDetailView = false
    
    var body: some View {
        HStack(spacing: 12) {
            CachedAsyncImage(url: recipe.photoURLSmall)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.name)
                    .font(.headline)
                
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .contentShape(Rectangle()) 
        .onTapGesture {
            showDetailView = true
        }
        .sheet(isPresented: $showDetailView) {
            RecipeDetailView(recipe: recipe)
                .presentationDetents([.fraction(0.9)]) // Set the height to 90% of the screen
                .presentationDragIndicator(.hidden) // Hide the drag indicator
                .presentationBackground(.thinMaterial) // Use a material background
        }
    }
}


struct CachedAsyncImage: View {
    let url: URL?
    
    @State private var image: Image?
    @State private var isLoading = false
    @State private var error: Error?
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                ProgressView()
            } else if error != nil {
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            } else {
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            }
        }
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard let url = url else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let uiImage = try await ImageCache.shared.image(for: url)
            // Convert UIImage to SwiftUI.Image
            image = Image(uiImage: uiImage)
        } catch {
            self.error = error
            print("Image loading error: \(error)") // Add this for debugging
        }
    }
}

#Preview {
    RecipeCell(recipe: Recipe(
        cuisine: "Malaysian",
        name: "Apam Balik",
        uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
        photoURLLarge: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"),
        photoURLSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"),
        sourceURL: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ"),
        youtubeURL: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
    ))
}
