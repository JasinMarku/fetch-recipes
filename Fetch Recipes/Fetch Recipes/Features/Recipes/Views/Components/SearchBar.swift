//
//  SearchBar.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/12/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(isFocused ? Color.accentPink : Color.gray)
                .font(isFocused ? .subheadline : .footnote)
            
            TextField("Search Dishes", text: $searchText)
                .focused($isFocused) // Tracks whether the TextField is focused
                .padding(10)
                .background(Color.clear)
        }
        .padding(.horizontal, 10)
        .overlay(
            Capsule()
                .stroke(Color.accentPink, lineWidth: isFocused ? 2 : 1)
                .opacity(isFocused ? 1 : 0.7)
        )
        .animation(.easeInOut, value: isFocused)
        .padding(.horizontal, 0.5)
    }
}

#Preview {
    SearchBar(searchText: .constant("Italian"))
}
