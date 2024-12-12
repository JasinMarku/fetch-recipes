//
//  RecipeListView.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/11/24.
//

import SwiftUI

struct RecipeHome: View {
    
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
                    emptyState
                } else {
                    VStack(alignment: .leading) {
                        HStack (alignment: .bottom){
                            Text("Recipes")
                                .font(.largeTitle)
                            
                            Text("by Fetch")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 5)
                        }
                        .padding(.bottom, 10)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)

                        ScrollView {
                            featuredSection
                            
                            Divider()
                                                        
                            fullList
                        }
                        .scrollIndicators(.hidden)
                    }
                    .padding(.horizontal)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        sortOptions
                        
                        reloadButton
                    }
                }
            }
            .task {
                await viewModel.fetchRecipes()
            }
        }
    }
}

#Preview {
    RecipeHome()
}


extension RecipeHome {
    
    var emptyState: some View {
        VStack {
            EmptyStateView(title: "No Recipes Found",
                           message: "Looks like something went wrong.\nRefresh or try again soon.",
                           image: "emptystate")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .offset(y: -50)
    }
    
    var featuredSection: some View {
        Group {
            if let cuisine = viewModel.featuredCuisine {
                FeaturedCuisineView(
                    cuisine: cuisine,
                    recipes: viewModel.featuredRecipes
                )
                .padding(.bottom, 5)
            } else {
                EmptyView()
            }
        }
    }
    
    var fullList: some View {
        LazyVStack(alignment: .leading, spacing: 15) {
            Text("All Dishes")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.appPink)
            
            SearchBar(searchText: $viewModel.searchText)
            
            ForEach(viewModel.filteredAndSortedRecipes, id: \.uuid) { recipe in
                RecipeCell(recipe: recipe)
            }
        }
        .padding(.top, 5)
    }
    
    
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
    
    var sortOptions: some View {
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
    }
}
