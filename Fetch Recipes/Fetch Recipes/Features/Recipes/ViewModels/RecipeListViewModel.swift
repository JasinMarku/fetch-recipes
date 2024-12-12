//
//  RecipeListViewModel.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/11/24.
//

import Foundation

@MainActor
final class RecipeListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    // Properties observed by the UI, ui will automatically update with changes
    // Private(set) so you can publicly see values from other parts of code, but only modifiable from this ViewModel
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var error: NetworkError?
    @Published private(set) var isLoading = false
    
    // Explore wheel
    @Published private(set) var featuredCuisine: String?
    @Published private(set) var featuredRecipes: [Recipe] = []
    
    private var lastUpdateTime: Date = .distantPast
    
    private func updateFeaturedCuisine() {
        let currentTime = Date()
        
        guard currentTime.timeIntervalSince(lastUpdateTime) >= 3600 else { return } // checks if an hour passed
        
        // get unique cuisines
        let cuisines = Array(Set(recipes.map { $0.cuisine }))
        guard let randomCuisine = cuisines.randomElement() else { return }
        
        featuredCuisine = randomCuisine
        featuredRecipes = recipes.filter { $0.cuisine == randomCuisine }
        lastUpdateTime = currentTime
    }
    
    
    @Published var currentSortOption: SortOption = .alphabetical

    // Sorting enum
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
    
    // Cuisine of the day
    var randomRecipe: Recipe? {
        guard !recipes.isEmpty else { return nil }
        return recipes.randomElement()
    }

     var sortedRecipes: [Recipe] {
        switch currentSortOption {
        case .alphabetical:
            return recipes.sorted { $0.name < $1.name }
        case .origin:
            return recipes.sorted { $0.cuisine < $1.cuisine }
        }
     }

     func changeSortOption(to option: SortOption) {
         currentSortOption = option
     }

    
    // MARK: - Private Properties
    // handles actual network request
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    // MARK: - Public Methods
    func fetchRecipes() async {
        isLoading = true
        error = nil
        
        do {
            // Fetch from the main endpoint
            let response: RecipesResponse = try await networkManager.fetch(RecipeEndpoint.fetchRecipes)
            recipes = response.recipes.sorted { $0.name < $1.name }
            updateFeaturedCuisine() 
        } catch {
            // Handle specific cases for malformed and empty data
            if let networkError = error as? NetworkError {
                switch networkError {
                case .invalidData:
                    // Handle malformed data case
                    self.error = NetworkError.unknown(error)
                    self.recipes = [] // Clear recipes
                case .serverError(let code) where code == 404:
                    // Handle empty data case
                    self.recipes = [] // Clear recipes
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

