//
//  Env.swift
//  DuoTest
//
//  Created by 김다예 on 10/13/26.
//

import UIKit
import SwiftUI

enum Env {
    /// 비교용으로만 사용 (UIScreen.main은 deprecated)
    static var screen: CGRect { UIScreen.main.bounds }

    static var windowScene: UIWindowScene? {
        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
    }

    static var isLandscape: Bool {
        windowScene?.interfaceOrientation.isLandscape ?? false
    }

    static var orientation: String {
        switch windowScene?.interfaceOrientation ?? .unknown {
        case .portrait: "portrait"
        case .portraitUpsideDown: "portraitUpsideDown"
        case .landscapeLeft: "landscapeLeft"
        case .landscapeRight: "landscapeRight"
        default: "unknown"
        }
    }

    static var idiom: String {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: "phone"
        case .pad: "pad"
        case .mac: "mac"
        default: "other"
        }
    }

    static func name(_ sizeClass: UserInterfaceSizeClass?) -> String {
        guard let sizeClass else { return "nil" }
        switch sizeClass {
        case .compact: return "compact"
        case .regular: return "regular"
        @unknown default: return "unknown"
        }
    }
}
