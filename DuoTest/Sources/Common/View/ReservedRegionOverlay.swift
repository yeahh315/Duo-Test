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
}

@available(iOS 27.1, *)
struct ReservedRegionOverlay: View {
    
    @State private var regions = RegionFrames()

    var body: some View {
        Color.clear
            .onGeometryChange(for: RegionFrames.self) { proxy in
                RegionFrames(
                    occlusion: proxy.reservedRegions(kind: .occlusion).map(\.frame),
                    division: proxy.reservedRegions(kind: .division).map(\.frame)
                )
            } action: { new in
                regions = new
                print("occlusion:", new.occlusion, "/ division:", new.division)
            }
            .overlay(alignment: .topLeading) {
                ZStack(alignment: .topLeading) {
                    ForEach(Array(regions.division.enumerated()), id: \.offset) { _, frame in
                        RegionBox(frame: frame, color: .orange, label: "division")
                    }
                    ForEach(Array(regions.occlusion.enumerated()), id: \.offset) { _, frame in
                        RegionBox(frame: frame, color: .purple, label: "occlusion")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
    }
}

struct RegionBox: View {
    let frame: CGRect
    let color: Color
    let label: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle().fill(color.opacity(0.35))
            Rectangle().stroke(color, lineWidth: 2)

            Text("\(label)\n\(Int(frame.minX)),\(Int(frame.minY)) \(Int(frame.width))×\(Int(frame.height))")
                .font(.system(size: 10, weight: .semibold).monospacedDigit())
                .foregroundStyle(.white)
                .padding(4)
                .background(color, in: .rect(cornerRadius: 4))
                .fixedSize()
                .offset(x: 4, y: 4)
        }
        .frame(width: frame.width, height: frame.height, alignment: .topLeading)
        .offset(x: frame.minX, y: frame.minY)
    }
}
