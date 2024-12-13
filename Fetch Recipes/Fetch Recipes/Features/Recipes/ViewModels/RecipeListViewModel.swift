//
//  RecipeListViewModel.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/11/24.
//

import Foundation

@MainActor
final class RecipeListViewModel: ObservableObject {
    
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var error: NetworkError?
    @Published private(set) var isLoading = false
    
    @Published private(set) var featuredCuisine: String?
    @Published private(set) var featuredRecipes: [Recipe] = []
    
    @Published var searchText: String = ""
    @Published var currentSortOption: SortOption = .alphabetical
    
    // Filter and sort recipes
    var filteredAndSortedRecipes: [Recipe] {
        let filtered = searchText.isEmpty
            ? recipes
            : recipes.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchText) ||
                recipe.cuisine.localizedCaseInsensitiveContains(searchText)
            }
        
        switch currentSortOption {
        case .alphabetical:
            return filtered.sorted { $0.name < $1.name }
        case .origin:
            return filtered.sorted { $0.cuisine < $1.cuisine }
        }
    }

    // Featured Section Update
    private func updateFeaturedCuisine() {
        // Get unique cuisines
        let cuisines = Array(Set(recipes.map { $0.cuisine }))
        
        // Randomly select a cuisine
        guard let randomCuisine = cuisines.randomElement() else { return }
        
        // Update the featured section
        featuredCuisine = randomCuisine
        featuredRecipes = recipes.filter { $0.cuisine == randomCuisine }
    }

    // Sorting options
    enum SortOption {
        case alphabetical
        case origin
     
        var text: String {
            switch self {
            case .alphabetical: return "Alphabetically"
            case .origin: return "Origin"
            }
        }
    }
    
    // Update sorting option
    func changeSortOption(to option: SortOption) {
        currentSortOption = option
    }
    
    // Network Handling
    private let networkManager: NetworkManager
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }

    func fetchRecipes() async {
        isLoading = true
        error = nil
        
        do {
            let response: RecipesResponse = try await networkManager.fetch(RecipeEndpoint.fetchRecipes)
            recipes = response.recipes
            updateFeaturedCuisine()
        } catch {
            if let networkError = error as? NetworkError {
                switch networkError {
                case .invalidData:
                    self.error = NetworkError.unknown(error)
                    self.recipes = []
                case .serverError(let code) where code == 404:
                    self.recipes = []
                default:
                    self.error = networkError
                }
            } else {
                self.error = NetworkError.unknown(error)
            }
        }
        
        isLoading = false
    }
}

