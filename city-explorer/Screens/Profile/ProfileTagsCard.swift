//
//  ProfileTagsCard.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 10/9/25.
//

import SwiftUI

struct ProfileTagsCard: View {
    
    let tags: [String]
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                Text("Interests").font(.headline)
                FlowLayout(spacing: 8) {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                            .font(.footnote)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color(.tertiarySystemFill)))
                    }
                }
            }
        }
    }
}

#Preview {
    
    let tags = ["Swift", "SwiftUI", "MapKit", "CNC", "3D Print"]
    
    ProfileTagsCard(tags: tags)
        .padding()
        .background(Color(.systemGroupedBackground))
}
