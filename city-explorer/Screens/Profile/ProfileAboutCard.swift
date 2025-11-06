//
//  ProfileAboutCard.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 10/9/25.
//

import SwiftUI

struct ProfileAboutCard: View {
    
    let name: String
    let role: String
    let location: String
    let bio: String
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 10) {
                Text(name).font(.title3).bold()
                Text(role).font(.subheadline).foregroundStyle(.secondary)
                
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                    Text(location)
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
                
                Divider().padding(.vertical, 2)
                
                Text(bio)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    ProfileAboutCard(
        name: "John Doe",
        role: "Software Engineer",
        location: "Los Angeles, USA",
        bio: "Passionate about software development and gym"
    )
}
