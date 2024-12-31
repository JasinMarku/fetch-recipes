//
//  RecipeListViewModelTests.swift
//  RecipeListViewModelTests
//
//  Created by Jasin ‎ on 12/20/24.
//

import XCTest
@testable import Fetch_Recipes

@MainActor
final class RecipeListViewModelTests: XCTestCase {
    
    var sut: RecipeListViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        sut = RecipeListViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    // Checks the view model’s state right after initialization, before fetching any data.
    func testInitialState() {
        XCTAssertTrue(sut.recipes.isEmpty)
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.searchText, "")
        XCTAssertEqual(sut.currentSortOption, .alphabetical)
    }
    
    // MARK: - Fetch Tests
    // Verifies that when a successful response is received from the mock network manager
    func testFetchRecipesSuccess() async {
        let testRecipes = [
            Recipe(cuisine: "Italian", name: "Pizza", uuid: "1",
                   photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(cuisine: "Japanese", name: "Sushi", uuid: "2",
                   photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        ]
        
        mockNetworkManager.mockResult = .success(RecipesResponse(recipes: testRecipes))
        
        // When
        await sut.fetchRecipes() // triggers the logic to fetch recipes using the mock network manager
        
        XCTAssertEqual(sut.recipes.count, 2) // checks that sut.recipes contains exactly the two recipes from the mock response
        XCTAssertNil(sut.error) // confirms no error was set during the fetch since the response was successful
        XCTAssertFalse(sut.isLoading) // ensures the isLoading property is set to false after the fetch completes
    }
    
    func testFetchRecipesFailure() async {
        // Given
        mockNetworkManager.mockResult = .failure(.invalidResponse)
        
        // When
        await sut.fetchRecipes()
        
        // Then
        XCTAssertTrue(sut.recipes.isEmpty) // ensures the recipes array is cleared after a failed fetch
        XCTAssertNotNil(sut.error) //  confirms that the view model records the error, providing feedback for debugging
        XCTAssertFalse(sut.isLoading) // ensures the isLoading property is turned off after the fetch attempt
    }
    
    
    // MARK: - Search Tests
    // Validates that when the user updates their search text, RecipeListViewModel correctly filters the recipes
    func testSearchFiltering() async {
        // Given
        let testRecipes = [
            Recipe(cuisine: "Italian", name: "Pizza", uuid: "1",
                   photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(cuisine: "Japanese", name: "Sushi", uuid: "2",
                   photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        ]
        
        mockNetworkManager.mockResult = .success(RecipesResponse(recipes: testRecipes)) // tells the MockNetworkManager to return these recipes on success
        await sut.fetchRecipes()
        
        // When - search by name
        sut.searchText = "Pizza" // simulating what happens when a user types “Pizza” into a search bar
        
        // Then
        XCTAssertEqual(sut.filteredAndSortedRecipes.count, 1)
        XCTAssertEqual(sut.filteredAndSortedRecipes.first?.name, "Pizza")
        
        // When - search by origin (cuisine)
        sut.searchText = "Japanese"
        
        // Then
        XCTAssertEqual(sut.filteredAndSortedRecipes.count, 1)
        XCTAssertEqual(sut.filteredAndSortedRecipes.first?.cuisine, "Japanese")
    }
    
    // MARK: - Sort Tests
    // Verifies that when currentSortOption is changed, the order of filteredAndSortedRecipes reflects the new sorting criteria, either alphabetical or by origin
    
    func testSortingOptions() async {
        // Given
        let testRecipes = [
            Recipe(cuisine: "Italian", name: "Pizza", uuid: "1",
                  photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(cuisine: "Japanese", name: "Sushi", uuid: "2",
                  photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(cuisine: "Italian", name: "Pasta", uuid: "3",
                  photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        ]
        mockNetworkManager.mockResult = .success(RecipesResponse(recipes: testRecipes))
        await sut.fetchRecipes()
        
        // When - Alphabetical
        sut.changeSortOption(to: .alphabetical)
        // Then -- verify that when sorting by name (alphabetically), “Pasta” comes first
        XCTAssertEqual(sut.filteredAndSortedRecipes[0].name, "Pasta")
        XCTAssertEqual(sut.filteredAndSortedRecipes[2].name, "Sushi")
        
        // When - Origin
        sut.changeSortOption(to: .origin)
        
        // Then
        let italianRecipes = sut.filteredAndSortedRecipes.filter { $0.cuisine == "Italian" } // Checks there are exactly 2 Italian recipes in the sorted list
        XCTAssertEqual(italianRecipes.count, 2)
        XCTAssertEqual(sut.filteredAndSortedRecipes.last?.cuisine, "Japanese") // Ensures “Sushi” ends up at the bottom of the list, confirming the ascending sort by cuisine
    }
    
    
    // MARK: - Featured Section Tests
    
    func testFeaturedCuisineSelection() async {
        // Given -  view model has only Italian recipes to choose from as its “featured” choice
        let testRecipes = [
            Recipe(cuisine: "Italian", name: "Pizza", uuid: "1",
                  photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil),
            Recipe(cuisine: "Italian", name: "Pasta", uuid: "2",
                  photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        ]
        mockNetworkManager.mockResult = .success(RecipesResponse(recipes: testRecipes))
        
        // When
        await sut.fetchRecipes()
        
        // Then
        XCTAssertEqual(sut.featuredCuisine, "Italian")
        XCTAssertEqual(sut.featuredRecipes.count, 2)
    }
    
}

// MARK: - Mock Network Manager
class MockNetworkManager: NetworkManager {
    var mockResult: Result<RecipesResponse, NetworkError>!
    
    override func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let result = mockResult else {
            XCTFail("mockResult must be set before calling fetch.")
            throw NetworkError.invalidResponse
        }
        
        switch result {
        case .success(let response):
            guard let typedResponse = response as? T else {
                fatalError("Type mismatch in MockNetworkManager. Expected \(T.self).")
            }
            return typedResponse
        case .failure(let error):
            throw error
        }
    }
}
