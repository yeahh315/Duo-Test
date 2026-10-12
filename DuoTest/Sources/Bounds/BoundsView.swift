//
//  BoundsView.swift
//  DuoTest
//
//  Created by 김다예 on 10/12/26.
//

import SwiftUI

struct BoundsView: View {
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("bounds")
                    .font(.title)
                
                Text("width : \(Int(geo.size.width))")
                
                Text("height : \(Int(geo.size.height))")
                
                Color.clear
                    .frame(height: 40)
                
                Text("SafeArea")
                    .font(.title)
                
                Text("top : \(Int(geo.safeAreaInsets.top))")
                Text("bottom : \(Int(geo.safeAreaInsets.bottom))")
                Text("leading : \(Int(geo.safeAreaInsets.leading))")
                Text("trailing : \(Int(geo.safeAreaInsets.trailing))")
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .background {
                Color.indigo
                    .frame(width: geo.size.width,
                           height: geo.size.height)
            }
        }
    }
}

