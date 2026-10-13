
import SwiftUI

/**
 좌우의 시스템 바가 세로로 나오기 위한 조건
    1. Xcode 27.1 로 빌드
    2. 컨테이너가 관리하는 바를 사용해야 함
        - SwiftUI에서 .toolbar를 NavigationStack이나 NavigationSplitView 안에 붙여야 함
        - UIKit에서 toolbarItem을 UINavigation Controller에서 설정하게 할 때 ⭕️
            ex) let shareItem = UIBarButtonItem(title: "공유", image: UIImage(systemName: "square.and.arrow.up"), primaryAction: nil)
               let saveItem  = UIBarButtonItem(title: "저장", image: UIImage(systemName: "square.and.arrow.down"), primaryAction: nil)
               let moreItem  = UIBarButtonItem(title: "더보기", image: UIImage(systemName: "ellipsis"), primaryAction: nil)

               toolbarItems = [shareItem, .flexibleSpace(), saveItem]
               navigationItem.rightBarButtonItems = [moreItem]
            (UIToolbar()로 직접 만들어서, Item을 설정하고 UIToolbar의 레이아웃을 직접 잡아준 경우는 ❌)
 
 1, 2 조건을 모두 충족해야 시스템 툴바가 세로로 나오게 됨!
 
 1, 2 조건을 모두 충족해도 세로로 나오지 않는 경우
    1. 펼친 상태에서 세로로 들었을 때
        -> 아래의 SystemToolBarView에서 1, 2 조건을 모두 충족했음에도
           펼친 상태에서 화면을 세로로 돌리면 시스템 바가 하단에 위치함 (이 때 toolbarVerticalEdge는 nil)
    2. Toolbar의 Item이 아이콘 없이 텍스트만 존재할 때 (아래 코드 예시)
        -> 아래의 Button("타이틀만")과 같이 이미지 없이 사용하면 "공유"아이템이 세로에 배치되지 않음
    3. Toolbar의 Item을 커스텀 뷰 Item으로 만들어줄 때 (아래 코드 예시)
        ex) ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 4) {
                    Circle().fill(.red).frame(width: 8, height: 8)
                    Text("커스텀")
                }
            }
      단 커스텀 뷰 Item으로 만드어주는 경우여도, .axisBehavior(.verticalPreferred)를 붙여주면 세로에 위치할 수 있음 (아래 코드 예시)
      이 경우 세로바에 위치해도 충분한 여유 공간이 있을 때만 사용 가능
        ex) ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 4) {
                    Circle().fill(.red).frame(width: 8, height: 8)
                    Text("커")
                }
            }
            .axisBehavior(.verticalPreferred)
    4. SplitView의 Detail컬럼만 세로바, sidebar나 content 칼럼은 가로 (SplitView에서 설명 예정)
    5. 개발자가 직접 끈 경우
        - SwiftUI
            NavigationStack {
                CalculatorView()
                    .toolbarVerticalBehavior(.disabled)
            }

        - UIKit
            class CalculatorViewController: UIViewController {
                override var preferredVerticalBarBehavior: UIVerticalBarBehavior {
                    .disabled
                }
            }
*/

struct SystemToolbarView: View {
    var body: some View {
        SizeReadout(label: "systemToolbar")
            .overlay(alignment: .bottom) {
                if #available(iOS 27.1, *) {
                    VerticalEdgeLabel().padding()
                }
            }
            .navigationTitle("시스템 toolbar")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("공유", systemImage: "square.and.arrow.up") {}
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("필터", systemImage: "camera.filters") {}
                    Spacer()
                    Button("저장", systemImage: "square.and.arrow.down") {}
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("타이틀만") {}
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 4) {
                        Circle().fill(.red).frame(width: 8, height: 8)
                        Text("커스텀")
                    }
                }
                if #available(anyAppleOS 27.1, *) {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 4) {
                            Circle().fill(.red).frame(width: 8, height: 8)
                            Text("ㅎ")
                        }
                    }
                    .axisBehavior(.verticalPreferred)
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 4) {
                            Circle().fill(.red).frame(width: 8, height: 8)
                            Text("텍스트가 길어지면..?")
                        }
                    }
                    .axisBehavior(.verticalPreferred)
                }
            }
    }
}

/// 세로바가 어디에 붙는지 알려줌
/// toolbarVerticalEdge : 세로 배치가 가능한 상황에서만 유효한값이 존재
@available(iOS 27.1, *)
struct VerticalEdgeLabel: View {
    @Environment(\.toolbarVerticalEdge) private var edge
 
    var body: some View {
        Text("toolbarVerticalEdge: \(String(describing: edge))")
            .font(.caption)
            .padding(8)
            .background(.thinMaterial, in: .capsule)
    }
}
