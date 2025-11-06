//
//  ProfileQuickInfoCard.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 10/9/25.
//

import SwiftUI

struct ProfileQuickInfoCard: View {
    
    let items: [ProfileQuickInfoItem]
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                Text("Quick Info").font(.headline)
                
                ForEach(items) { item in
                    HStack(alignment: .firstTextBaseline, spacing: 10) {
                        Image(systemName: item.icon)
                            .frame(width: 20)
                            .foregroundStyle(.secondary)
                        
                        Text(item.title + ":")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        if let url = item.link {
                            Link(destination: url) {
                                HStack(spacing: 4) {
                                    Text(item.value).font(.subheadline)
                                    Image(systemName: "arrow.up.right.square")
                                        .imageScale(.small)
                                }
                            }
                        } else {
                            Text(item.value)
                                .font(.subheadline)
                                .textSelection(.enabled)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    
    let items = [
        ProfileQuickInfoItem(icon: "graduationcap", title: "College", value: "Harvard University"),
        ProfileQuickInfoItem(icon: "globe", title: "Website", value: "example.com", link: URL(string: "example.com"))
    ]
    
    ProfileQuickInfoCard(items: items)
        .padding()
        .background(Color(.systemGroupedBackground))
}
