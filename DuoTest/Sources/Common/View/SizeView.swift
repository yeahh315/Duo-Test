//
//  SizeView.swift
//  DuoTest
//
//  Created by 김다예 on 10/13/26.
//

import SwiftUI

/// 이 뷰가 실제로 받은 영역을 빨간 테두리로 표시하고 + 크기/safeArea 출력
/// 테두리가 세로 바·카메라를 침범하는지

struct SizeReadout: View {
    let label: String
    @Environment(\.horizontalSizeClass) private var hSizeClass
    @State private var info = ContainerInfo()

    var body: some View {
        InfoRows(rows: [
            .init("컨테이너", sizeFormat(info.size)),
            .init("safeArea", insetFormat(info.safe)),
            .init("hSizeClass", Env.name(hSizeClass)),
        ])
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .border(.red, width: 2)
        .trackContainer($info, label: label)
    }
}
