//
//  Fmt.swift
//  DuoTest
//
//  Created by 김다예 on 10/13/26.
//

import Foundation
import SwiftUI

func sizeFormat(_ size: CGSize) -> String {
    "\(Int(size.width)) × \(Int(size.height))"
}

func insetFormat(_ insets: EdgeInsets) -> String {
    "T\(Int(insets.top)) L\(Int(insets.leading)) B\(Int(insets.bottom)) R\(Int(insets.trailing))"
}
