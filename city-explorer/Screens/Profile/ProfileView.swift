//
//  ProfileScreen.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 10/9/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                GradientHeader(title: "Profile", subtitle: "Your profile information") {
                    ZStack {
                        Circle()
                            .fill(.ultraThickMaterial)
                            .frame(width: 96, height: 96)

                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.primary)
                    }
                }
                .padding(.bottom, 64)
                
                ProfileAboutCard(
                    name: "John Doe",
                    role: String(localized: "Software Engineer"),
                    location: String(localized: "Los Angeles, USA"),
                    bio: String(localized: "Passionate about software development and gym.")
                )
                
                ProfileQuickInfoCard(items: [
                    ProfileQuickInfoItem(
                        icon: "graduationcap",
                        title: String(localized: "College"),
                        value: String(localized: "Harvard University")
                    ),
                    ProfileQuickInfoItem(
                        icon: "globe",
                        title: String(localized: "Website"),
                        value: "www.swift.org",
                        link: URL(string: "https://www.swift.org/")
                    ),
                    ProfileQuickInfoItem(
                        icon: "envelope",
                        title: "Email",
                        value: "john_doe@example.com",
                        link: URL(string: "mailto:john_doe@example.com")
                    )
                ])
                
                ProfileTagsCard(
                    tags: ["iOS", "Android", "Web Dev", "AI", "LLMs", "Motorsport"]
                )
                
                Spacer(minLength: 12)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("")
    }
}

#Preview {
    ProfileView()
        .allowsLandscape()
}
