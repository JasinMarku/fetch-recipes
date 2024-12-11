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
