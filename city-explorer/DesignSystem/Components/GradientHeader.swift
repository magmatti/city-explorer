//
//  GradientHeader.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 19/9/25.
//

import SwiftUI

struct GradientHeader<BottomContent: View>: View {
    
    var title: LocalizedStringKey?
    var subtitle: LocalizedStringKey?
    var height: CGFloat = 140
    var cornerRadius: CGFloat = 24
    
    @ViewBuilder var bottomContent: () -> BottomContent

    init(
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey? = nil,
        height: CGFloat = 140,
        cornerRadius: CGFloat = 24,
        @ViewBuilder bottomContent: @escaping () -> BottomContent = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.height = height
        self.cornerRadius = cornerRadius
        self.bottomContent = bottomContent
    }

    init(
        title: String,
        subtitle: String? = nil,
        height: CGFloat = 140,
        cornerRadius: CGFloat = 24,
        @ViewBuilder bottomContent: @escaping () -> BottomContent = { EmptyView() }
    ) {
        self.title = LocalizedStringKey(title)
        self.subtitle = subtitle.map { LocalizedStringKey($0) }
        self.height = height
        self.cornerRadius = cornerRadius
        self.bottomContent = bottomContent
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

            VStack(spacing: 6) {
                if let title {
                    Text(title)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                }
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
            .padding(.bottom, 36)

            bottomContent()
                .offset(y: 68)
        }
    }
}

#Preview {
    VStack(spacing: 48) {

        GradientHeader(title: "Profile", subtitle: "Welcome back!")
            .padding(.horizontal)

        GradientHeader(title: "Profile", subtitle: "Welcome back!") {
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
        .padding(.horizontal)
        .padding(.bottom, 64)
        .background(Color(.systemGroupedBackground))
    }
    .padding(.vertical)
}
