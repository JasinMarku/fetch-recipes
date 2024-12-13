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
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(isFocused ? Color.accentPink : Color.gray)
            
            TextField("Search Dishes...", text: $searchText)
                .focused($isFocused)
                .padding(.vertical, 12)
                .background(Color.clear)
            
            // X button to clear text
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.gray)
                }
                .padding(.trailing, 8)
            }
        }
        .padding(.horizontal, 10)
        .overlay(
            Capsule()
                .stroke(isFocused ? Color.accentPink : Color.gray, lineWidth: isFocused ? 2 : 1)
        )
        .animation(.easeInOut, value: isFocused)
        .padding(.horizontal, 0.5)
    }
}

#Preview {
    SearchBar(searchText: .constant("Italian"))
}
