//
//  RecipeListView.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/11/24.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject private var viewModel = RecipeListViewModel()
    @State private var isRotating = false // Tracks rotation state
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                    List(viewModel.recipes, id: \.uuid) { recipe in
                        RecipeCell(recipe: recipe)
                    }
                    .refreshable {
                        await viewModel.fetchRecipes()
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    reloadButton
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
                .rotationEffect(.degrees(isRotating ? 360 : 0))
                .animation(
                    isRotating ?
                        .linear(duration: 1)
                        .repeatForever(autoreverses: false) :
                        .default,
                    value: isRotating
                )
                .tint(.primary)
        }
    }
}
