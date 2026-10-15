//
//  SystemToolbarTabView.swift
//  DuoTest
//
//  Created by 김다예 on 10/15/26.
//

import SwiftUI

/// 툴바 + 탭바: 세로 바 관련 옵션을 바꿔가며 확인
@available(iOS 27.1, *)
struct SystemToolbarTabDemo: View {

    enum VerticalOption: String, CaseIterable, Identifiable {
        case automatic = "기본"
        case disabled = "끄기"
        var id: Self { self }
    }

    enum AxisOption: String, CaseIterable, Identifiable {
        case automatic = "기본"
        case verticalPreferred = "세로 선호"
        case horizontalOnly = "가로만"
        var id: Self { self }
    }

    enum CompressionOption: String, CaseIterable, Identifiable {
        case automatic = "기본 (툴바가 먼저 접힘)"
        case prefersToolbarItems = "툴바 우선 (탭바가 먼저 접힘)"
        var id: Self { self }
    }

    @Environment(\.dismiss) private var dismiss
    @State private var vertical: VerticalOption = .automatic
    @State private var axis: AxisOption = .automatic
    @State private var compression: CompressionOption = .automatic

    var body: some View {
        TabView {
            Tab("홈", systemImage: "house") { content("홈") }
            Tab("검색", systemImage: "magnifyingglass") { content("검색") }
            Tab("마이", systemImage: "person") { content("마이") }
        }
    }

    // MARK: - 화면

    private func content(_ title: String) -> some View {
        NavigationStack {
            applyCompression(applyVertical(list(title)))
        }
    }

    private func list(_ title: String) -> some View {
        List {
            Section("설정") {
                Picker("toolbarVerticalBehavior", selection: $vertical) {
                    ForEach(VerticalOption.allCases) { Text($0.rawValue).tag($0) }
                }
                Picker("axisBehavior (공유)", selection: $axis) {
                    ForEach(AxisOption.allCases) { Text($0.rawValue).tag($0) }
                }
                Picker("compression", selection: $compression) {
                    ForEach(CompressionOption.allCases) { Text($0.rawValue).tag($0) }
                }
            }
            Section("항목") {
                ForEach(1...5, id: \.self) { i in
                    Label("\(title) 항목 \(i)", systemImage: "music.note")
                }
            }
        }
        .navigationTitle(title)
        .toolbar { toolbarContent }
    }

    // MARK: - 툴바

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("닫기", systemImage: "xmark") { dismiss() }
        }

        // axisBehavior 적용 대상 (기본은 세로)
        withAxis(
            ToolbarItem(placement: .topBarTrailing) {
                Button("공유", systemImage: "square.and.arrow.up") {}
            }
        )

        ToolbarItem(placement: .topBarTrailing) {
            Button("알림", systemImage: "bell") {}
                .badge(3)
        }

        ToolbarItemGroup(placement: .bottomBar) {
            Button("녹화", systemImage: "record.circle") {}
            Button("좌우반전", systemImage: "arrow.left.and.right") {}
            Button("구간반복", systemImage: "repeat") {}
            Button("저장", systemImage: "square.and.arrow.down") {}
        }
    }

    // MARK: - 옵션 적용 ("기본"이면 modifier를 아예 안 붙임)

    @ToolbarContentBuilder
    private func withAxis<C: ToolbarContent>(_ item: C) -> some ToolbarContent {
        if axis == .verticalPreferred {
            item.axisBehavior(.verticalPreferred)
        } else if axis == .horizontalOnly {
            item.axisBehavior(.horizontalOnly)
        } else {
            item
        }
    }

    @ViewBuilder
    private func applyVertical<V: View>(_ view: V) -> some View {
        if vertical == .disabled {
            view.toolbarVerticalBehavior(.disabled)
        } else {
            view
        }
    }

    @ViewBuilder
    private func applyCompression<V: View>(_ view: V) -> some View {
        if compression == .prefersToolbarItems {
            view.toolbarVerticalCompressionBehavior(.prefersToolbarItems)
        } else {
            view
        }
    }
}
