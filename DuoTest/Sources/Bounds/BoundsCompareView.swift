//
//  BoundsView.swift
//  DuoTest
//
//  Created by 김다예 on 10/12/26.
//

import SwiftUI

/**
    UIScreen.main.bounds는 무조건 외부 디스플레이의 값을 반환함
        화면을 접었을 때 외부 디스플레이의 회전에 대한 Rect값은 업데이트 되지만,
        화면을 펼친 상태에서 회전을 해도 외부 디스플레이 기준으로 잡히기 때문에 Rect에 변화가 없다.
 
        또한 기존에는 Horizontal에 대해 SafeAreaInset이 없어서
        UIScreen.main.bounds.width를 사용했을 때 원하는 너비를 얻을 수 있지만,
        Duo에서는 safeAreaInset이 상하좌우 어디에든 생길 수 있기 때문에 원하는 값을 얻기 어렵다.
 
    ** 따라서 UIScreen.main.bounds로 레이아웃을 잡는 행위는 지양 **
 
 
 */

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
            .frame(alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .trackContainer($fullContainer, label: "full")
        .reservedRegionOverlay()
        .navigationTitle("bounds 비교")
    }
}
