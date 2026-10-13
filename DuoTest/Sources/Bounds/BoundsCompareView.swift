//
//  BoundsView.swift
//  DuoTest
//
//  Created by 김다예 on 10/12/26.
//

import SwiftUI

struct BoundsCompareView: View {
    @State private var fullContainer = ContainerInfo()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            InfoRows(rows: [
                .init("UIScreen.main.bounds", sizeFormat(Env.screen.size)),
                .init("컨테이너 (geo.size)", sizeFormat(fullContainer.size)),
                .init("safeArea", insetFormat(fullContainer.safe)),
                .init("orientation", Env.orientation),
                .init("idiom", Env.idiom),
            ])
            .padding(.horizontal)

            Text("Width 값")
                .font(.headline)
                .padding(.horizontal)

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {

                    Text("❌ UIScreen.bouns.width")
                        .font(.caption2)
                        .padding(.horizontal)

                    Color.clear
                        .frame(height: 16)
                        .overlay(alignment: .leading) {
                            Rectangle().fill(.red.opacity(0.6))
                                .frame(width: Env.screen.width)
                        }

                    Text("⭕️ 컨테이너 width")
                        .font(.caption2)
                        .padding(.horizontal)

                    Color.clear
                        .frame(height: 16)
                        .overlay(alignment: .leading) {
                            Rectangle().fill(.green.opacity(0.6))
                                .frame(width: fullContainer.size.width)
                        }
                    
                }
            }
            .frame(alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .trackContainer($fullContainer, label: "full")
        .reservedRegionOverlay()
        .navigationTitle("bounds 비교")
    }
}
