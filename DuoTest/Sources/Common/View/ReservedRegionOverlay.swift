//
//  ReservedRegionOverlay.swift
//  DuoTest
//
//  Created by 김다예 on 10/13/26.
//

/** ReservedRegion이란?
    하드웨어가 쓰고있는 영역으로 iOS 27.1에 새로 생김
 
    .occlusion : 화면 일부를 가리는 영역
    .division : 화면을 나누는 영역 (Duo에서 힌지를 의미) */

import SwiftUI

nonisolated struct RegionFrames: Equatable, Sendable {
    var occlusion: [CGRect] = []
    var division: [CGRect] = []
    var inactiveOcclusion: [CGRect] = []
    var inactiveDivision: [CGRect] = []
}

@available(iOS 27.1, *)
struct ReservedRegionOverlay: View {
    var body: some View {
        GeometryReader { proxy in
            let divisions = proxy.reservedRegions(kind: .division, options: .includeInactive)
            let occlusions = proxy.reservedRegions(kind: .occlusion, options: .includeInactive)

            ZStack(alignment: .topLeading) {
                ForEach(Array(divisions.enumerated()), id: \.offset) { _, region in
                    RegionBox(frame: region.frame, color: .blue, label: "division", isActive: region.isActive)
                }
                ForEach(Array(occlusions.enumerated()), id: \.offset) { _, region in
                    RegionBox(frame: region.frame, color: .red, label: "occlusion", isActive: region.isActive)
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

struct RegionBox: View {
    let frame: CGRect
    let color: Color
    let label: String
    var isActive = true

    var body: some View {
        // inactive division은 폭이 0이라 최소 2pt로 그려서 위치만 보이게
        let width = max(frame.width, 2)
        let height = max(frame.height, 2)

        ZStack(alignment: .topLeading) {
            if isActive {
                Rectangle().fill(color.opacity(0.35))
                Rectangle().stroke(color, lineWidth: 2)
            } else {
                Rectangle().fill(color.opacity(0.08))
                Rectangle().stroke(color.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
            }
        }
        .frame(width: width, height: height, alignment: .topLeading)
        .overlay(alignment: .topLeading) {                                  // 라벨은 크기 계산에서 제외
            Text("\(label)\(isActive ? "" : " (inactive)")\n\(Int(frame.minX)),\(Int(frame.minY)) \(Int(frame.width))×\(Int(frame.height))")
                .font(.system(size: 10, weight: .semibold).monospacedDigit())
                .foregroundStyle(.white)
                .padding(4)
                .background(color.opacity(isActive ? 1 : 0.5), in: .rect(cornerRadius: 4))
                .fixedSize()
                .offset(x: 4, y: 4)
        }
        .offset(x: frame.minX, y: frame.minY)
    }
}
