
import SwiftUI

/**
    탭바가 어떻게 나타나는지
 
    닫은 화면과 펼친 상태의 가로 화면에서는 탭바가 세로로 위치하며,
    펼친 상태의 세로 화면에서는 탭바가 하단에 위치함
 
 */
struct TabDemo: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var isTabbarSideView: Bool = false
    
    var body: some View {
        if #available(iOS 18.0, *) {
            if #available(iOS 27.1, *),
               isTabbarSideView {
                TabView {
                    Tab("홈", systemImage: "house") { content("home") }
                    Tab("검색", systemImage: "magnifyingglass") { content("search") }
                    Tab("마이", systemImage: "person") { content("my") }
                }
                .tabViewStyle(.sidebarAdaptable)
                .defaultTabBarPlacement(.sidebar)
            } else {
                TabView {
                    Tab("홈", systemImage: "house") { content("home") }
                    Tab("검색", systemImage: "magnifyingglass") { content("search") }
                    Tab("마이", systemImage: "person") { content("my") }
                }
            }
        } else {
            TabView {
                content("home").tabItem { Label("홈", systemImage: "house") }
                content("search").tabItem { Label("검색", systemImage: "magnifyingglass") }
                content("my").tabItem { Label("마이", systemImage: "person") }
            }
        }
    }
    
    private func content(_ label: String) -> some View {
        NavigationStack {
            SizeReadout(label: "tab-\(label)")
                .navigationTitle(label)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("닫기", systemImage: "xmark") { dismiss() }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(
                            isTabbarSideView ? "탭바로" : "사이드바로",
                            systemImage: isTabbarSideView ? "dock.rectangle" : "sidebar.left"
                        ) {
                            isTabbarSideView.toggle()
                        }
                    }
                }
        }
    }
}
