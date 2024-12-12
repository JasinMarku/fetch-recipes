//
//  RecipeListView.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/11/24.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject private var viewModel = RecipeListViewModel()
    @State private var isRotating = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.accentBackground
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.recipes.isEmpty {
                    VStack {
                        EmptyStateView(title: "No Recipes Found",
                                       message: "Looks like something went wrong.\nRefresh or try again soon.",
                                       image: "emptystate")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .offset(y: -50)
                } else {
                    VStack(alignment: .leading) {
                        Text("Fetch Recipes")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .padding(.bottom, 10)
                        
                        
                        
                        ScrollView {
                            if let cuisine = viewModel.featuredCuisine {
                                FeaturedCuisineView(
                                    cuisine: cuisine,
                                    recipes: viewModel.featuredRecipes
                                )
                                .padding(.bottom, 20)
                            }
                            
                            LazyVStack(alignment: .leading) {
                                Text("All Dishes")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                ForEach(viewModel.sortedRecipes, id: \.uuid) { recipe in
                                    RecipeCell(recipe: recipe)
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                    .padding(.horizontal)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Menu {
                            Button {
                                viewModel.changeSortOption(to: .alphabetical)
                            } label: {
                                Label("Sort by Name", systemImage: "textformat")
                            }
                            
                            Button {
                                viewModel.changeSortOption(to: .origin)
                            } label: {
                                Label("Sort by Origin", systemImage: "globe")
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .tint(.primary)
                        }
                        
                        reloadButton
                    }
                }
            }
            .task {
                await viewModel.fetchRecipes() // remove to test empty state
            }
        }
    }
}

#Preview {
    RecipeListView()
}

extension RecipeListView {
    var reloadButton: some View {
        Button {
            Task {
                withAnimation(.linear(duration: 1)) {
                    isRotating = true
                }
                await viewModel.fetchRecipes()
                isRotating = false
            }
        } label: {
            Image(systemName: "arrow.clockwise")
                .rotationEffect(isRotating ? .degrees(180) : .degrees(0))
                .animation(isRotating ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isRotating)
                .tint(.primary)
        }
    }
}
