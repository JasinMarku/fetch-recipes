//
//  SectionTitle.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/16/24.
//

import SwiftUI

struct SectionTitle: View {
    
    let title: String

    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 20, height: 1)
                .foregroundStyle(.primary.opacity(0.2))
            
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.appPink)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .layoutPriority(1) 
                            
            Rectangle()
                .frame(width: .infinity, height: 1)
                .foregroundStyle(.primary.opacity(0.2))
        }
    }
}

#Preview {
    SectionTitle(title: "All Dishes")
}
