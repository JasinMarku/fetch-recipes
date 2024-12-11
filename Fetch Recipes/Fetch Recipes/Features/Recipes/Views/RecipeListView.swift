//
//  RecipeListView.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/11/24.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject private var viewModel = RecipeListViewModel()
    
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
            .task {
                await viewModel.fetchRecipes()
            }
        }
    }
}

#Preview {
    RecipeListView()
}
