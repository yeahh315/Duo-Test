//
//  RootView.swift
//  DuoTest
//
//  Created by 김다예 on 10/12/26.
//

import SwiftUI

struct RootView: View {

    @StateObject
    var interactor: RootInteractor

    init(interactor: RootInteractor) {
        self._interactor = .init(wrappedValue: interactor)
    }

    var body: some View {
        NavigationStack(path: .init(
            get: { self.interactor.state.paths },
            set: { self.interactor.send(.updatePath($0)) }
        )) {
            List {
                Section("1. 화면 크기 vs 컨테이너 크기") {
                    Button("bounds 비교") { self.interactor.send(.tapBoundsButton) }
                }
                Section("3·4. idiom / orientation / sizeClass") {
                    Button("열 개수 분기 비교") { self.interactor.send(.tapSizeClassButton) }
                }
                Section("Bar 위치") {
                    Button("⭕️ 시스템 toolbar") { self.interactor.send(.tapSystemToolbarButton) }
                    Button("❌ 커스텀 바") { self.interactor.send(.tapCustomBarButton) }
                    Button("아이템 종류별 (타이틀/아이콘/커스텀)") { self.interactor.send(.tapToolbarItemKindsButton) }
                }
                Section("2. 시스템 컨테이너") {
                    Button("NavigationSplitView") { self.interactor.send(.tapSplitButton) }
                    Button("TabView") { self.interactor.send(.tapTabButton) }
                    Button("ArrangementView") { self.interactor.send(.tapArrangementButton) }
                }
            }
            .navigationTitle("Duo Test")
            .navigationDestination(for: RootInteractor.State.Path.self) { route in
                switch route {
                case .bounds:
                    BoundsCompareView()
                case .sizeClass:
                    SizeClassCompareView()
                case .systemToolbar:
                    SystemToolbarView()
                case .customBar:
                    CustomBarView()
                case .toolbarItemKinds:
                    ToolbarItemKindsView()
                }
            }
        }
        .fullScreenCover(item: .init(
            get: { self.interactor.state.cover },
            set: { self.interactor.send(.updateCover($0)) }
        )) { cover in
            switch cover {
            case .split:
                SplitDemo()
            case .tab:
                TabDemo()
            case .arrangement:
                if #available(iOS 27.1, *) {
                    ArrangementDemo()
                } else {
                    Text("iOS 27.1+ 필요")
                }
            }
        }
    }
}
