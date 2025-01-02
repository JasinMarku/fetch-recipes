//
//  NetworkError.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/11/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError
    case serverError(Int)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .invalidData:
            return "Invalid data"
        case .decodingError:
            return "Decoding error"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .unknown(let error):
            return "Uknown error: \(error.localizedDescription)"
        }
    }
}
