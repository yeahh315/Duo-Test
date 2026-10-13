//
//  S.swift
//  DuoTest
//
//  Created by 김다예 on 10/13/26.
//

import SwiftUI

/**
    - Toolbar에 대한 부가 설명
        SystemToolbarView에서 설명했다시피
        NavigationSplitView의 Detail컬럼만 세로바, sidebar나 content 칼럼은 가로로 나온다는 것
        
        목록인 Sidebar 칼럼에서는 .toolbar의 아이템이 가로에 위치하고, Detail 칼럼의 .toolbar의 아이템은 세로에 위치함
    단 이것을 펼쳤을 때 기준인 듯
    접었을 때는 sidebar 칼럼의 .toolbar의 아이템도 세로에 위치함
 
 
    NavigationSplitView는 Duo에서
    접었을 때와, 펼치고 세로 화면에서는 sidebar칼럼 위에 Detail칼럼이 위치하고 (sidebar에 Detail이 푸시된 느낌)
    펼쳤을 때, 가로 화면에서는 sidebar 칼럼이 좌측에 Detail 칼럼이 우측에 위치한다.
 
        
    **참고**
    NavigationSplitView를 push가 아니라 fullScreenCover로 띄운 이유
    이미 NavigationStack안에 SplitView가 존재하는 경우이기 때문에 NavigationStack이 중첩됨
    만약 앱의 루트거나, TabView의 탭 안에 NavigationSplitView를 넣는 경우에는 NavigationStack이 중첩되지 않아 괜찮음
        ex) // 탭 안
            TabView {
                Tab("영상", systemImage: "play.rectangle") {
                    NavigationSplitView {
                        VideoListView()
                    } detail: {
                        VideoDetailView()
                    }
                }
                Tab("마이", systemImage: "person") {
                    NavigationStack { MyPageView() }
                }
            }
 
 
    - UIKit에서는? 아래와 같은 형식으로 사용 가능
        let split = UISplitViewController(style: .doubleColumn)

        split.setViewController(VideoListViewController(), for: .primary)     // sidebar
        split.setViewController(VideoDetailViewController(), for: .secondary) // detail

        window.rootViewController = split
 */

struct SplitDemo: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selection: Int? = 1
 
    var body: some View {
        NavigationSplitView {
            // 여기는 sidebar 칼럼
            List(1...5, id: \.self, selection: $selection) {
                Text("영상 \($0)")
            }
            .navigationTitle("목록")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("닫기", systemImage: "xmark") { dismiss() }
                }
            }
        } detail: {
            // 여기는 Detail 칼럼
            SizeReadout(label: "split-detail")
                .navigationTitle("영상 \(selection ?? 0)")
                .toolbar {
                    Button("공유", systemImage: "square.and.arrow.up") {}
                }
        }
    }
}

