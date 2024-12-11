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
            let response: RecipesResponse = try await networkManager.fetch(RecipeEndpoint.fetchRecipes)
            recipes = response.recipes.sorted { $0.name < $1.name }
        } catch let networkError as NetworkError {
            // If it's a known NetworkError, assigned directly to the ViewModel's error property
            self.error = networkError
        } catch {
            // For any other error, wrap in NetworkError.unknown
            self.error = NetworkError.unknown(error)
        }
        
        isLoading = false
    }
}
