//
//  DuoTestApp.swift
//  DuoTest
//
//  Created by 김다예 on 10/12/26.
//

import SwiftUI

@main
struct DuoTestApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                interactor: RootInteractor(state: .init())
            )
        }
    }
}


// MARK: - 공용

/// 이 뷰가 실제로 받은 영역을 빨간 테두리로 표시 + 크기/safeArea 출력
/// 테두리가 세로 바·카메라 밑으로 들어가는지 보면 됨
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

nonisolated struct ContainerInfo: Equatable, Sendable {
    var size: CGSize = .zero
    var safe = EdgeInsets()
}

extension View {
    /// 크기·safeArea가 바뀔 때마다 상태 갱신 + 콘솔 로그 (UIScreen 값과 비교용)
    func trackContainer(_ info: Binding<ContainerInfo>, label: String) -> some View {
        onGeometryChange(for: ContainerInfo.self) { proxy in
            ContainerInfo(size: proxy.size, safe: proxy.safeAreaInsets)
        } action: { new in
            info.wrappedValue = new
            print("[\(label)] screen: \(sizeFormat(Env.screen.size)) / container: \(sizeFormat(new.size)) / safe: \(insetFormat(new.safe))")
        }
    }
}

struct InfoRow: Identifiable {
    let key: String
    let value: String
    var id: String { key }
    init(_ key: String, _ value: String) {
        self.key = key
        self.value = value
    }
}

struct InfoRows: View {
    let rows: [InfoRow]

    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 6) {
            ForEach(rows) { row in
                GridRow {
                    Text(row.key).foregroundStyle(.secondary)
                    Text(row.value).monospacedDigit()
                }
            }
        }
        .font(.footnote)
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color.secondary.opacity(0.12),
            in: .rect(cornerRadius: 12)
        )
    }
}

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
