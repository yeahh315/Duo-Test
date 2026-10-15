//
//  SafeAreaOverlay.swift
//  DuoTest
//
//  Created by 김다예 on 10/15/26.
//

import SwiftUI

struct SafeAreaBackground: View {
    var body: some View {
        ZStack {
            Color.purple.opacity(0.3)
                .ignoresSafeArea()
            Color.white                     // safe area 안에서만
        }
        .allowsHitTesting(false)
    }
}
