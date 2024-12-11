//
//  Endpoint.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/11/24.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var url: URL? { get }
}

enum RecipeEndpoint: Endpoint {
    case fetchRecipes
    case malformedRecipes
    case emptyRecipes
    
    var baseURL: String {
        "https://d3jbb8n5wk0qxi.cloudfront.net"
    }
    
    var path: String {
        switch self {
        case .fetchRecipes:
            return "/recipes.json"
        case .malformedRecipes:
            return "/recipes-malformed.json"
        case .emptyRecipes:
            return "/recipes-empty.json"
        }
    }
    
    var url: URL? {
        URL(string: baseURL + path)
    }
    
}
