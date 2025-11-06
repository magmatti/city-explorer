//
//  AllowsLandscape.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 26/9/25.
//

import SwiftUI
import UIKit

struct AllowsLandscape: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                OrientationLock.shared.mask = .allButUpsideDown
            }
            .onDisappear {
                OrientationLock.shared.mask = .portrait
            }
    }
}

extension View {
    
    func allowsLandscape() -> some View {
        modifier(AllowsLandscape())
    }
}
