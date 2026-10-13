
import SwiftUI

/**
 화면에 따른 레이아웃 분기 시
    userInterfaceIdiom이나, windowScene.interfaceOrientation을 사용하는게 아니라
    traitCollection.horizontalSizeClass 사용을 권장
 
    userInterfaceIdiom : 무슨 종류의 기기인지 (.phone, .pad, .mac)
    windowScene.interfaceOrientation : 화면의 방향이 가로인지 세로인지 (true, false)
    traitCollection.horizontalSizeClass : 내가 받은 공간이 좁은지 넓은지 (.compact, .regular)
        참고 : Duo에서 외부 디스플레이는
            horizontalSizeClass는 가로 화면이든 세로 화면이든 둘 다 .compact
            verticalSizeClass는 가로일 때 .compact, 세로일 때 .regular
 */

struct SizeClassCompareView: View {
    @Environment(\.horizontalSizeClass) private var hSizeClass
    @Environment(\.verticalSizeClass) private var vSizeClass
    @State private var fullContainer = ContainerInfo()

    var body: some View {
        
        // fullContainer를 body에서 읽으므로 크기가 바뀔 때마다 아래 값도 다시 계산됨
        
        /// .pad이거나, 가로이이거나, .regular일 때 3개의 열이 되도록 아니라면 1개의 열
        let byIdiom = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 1
        let byOrientation = Env.isLandscape ? 3 : 1
        let bySizeClass = hSizeClass == .regular ? 3 : 1
 
        Text("너비가 넓을 땐 3열, 좁을 땐 1열로 나와야 정상 동작")
            .font(.headline)
        
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                InfoRows(rows: [
                    .init("컨테이너 Width", "\(Int(fullContainer.size.width))"),
                    .init("hSizeClass", Env.name(hSizeClass)),
                    .init("idiom", Env.idiom),
                    .init("orientation", Env.orientation),
                ])
                GridDemo(title: "❌ idiom 기준", columns: byIdiom)
                GridDemo(title: "❌ orientation 기준", columns: byOrientation)
                GridDemo(title: "⭕️ sizeClass 기준", columns: bySizeClass)
                AnyLayoutDemo()
            }
            .padding()
        }
        .trackContainer($fullContainer, label: "fullContainer")
        .onChange(of: hSizeClass) { old, new in
            
            /// 로그용
            print("hSizeClass:", Env.name(old), "→", Env.name(new))
        }
        .onChange(of: vSizeClass) { old, new in
            
            /// 로그용
            print("vSizeClass:", Env.name(old), "→", Env.name(new))
        }
        .navigationTitle("sizeClass 비교")
    }
}

struct GridDemo: View {
    let title: String
    let columns: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text("\(title) → \(columns)열")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns)) {
                ForEach(0..<6, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.accentColor.opacity(0.2))
                        .frame(height: 44)
                        .overlay(Text("\(i + 1)"))
                }
            }
        }
    }
}

/**
 AnyLayout이란 런타임에 규칙을 바뀌어 낄 수 있는 Layout
    HStackLayout : HStackView는 뷰이지만, HStackLayout은 가로로 나열한다는 규칙
    struct HStackLayout : Layout
    layout은 함수처럼 호출해서 자식을 넣어서 쓸 수 있음
 
    이게 if 분기와 다른점이 뭐냐
            if 분기                                                                                AnyLayout
 ───────────────────                     ───────────────────
         if-true 쪽:  HStack                                                     AnyLayout   ← 항상 같은 자리
            ├ CounterBox (A)                                                  ├ CounterBox (A)  ← 같은 뷰
            └ CounterBox (B)                                                 └  CounterBox (B)  ← 같은 뷰
         if-false 쪽: VStack
            ├ CounterBox (A')  ← 다른 뷰로 인식
            └ CounterBox (B')
    
    따라서 AnyLayout으로 만들어주면 아래의 예시에서 CounterBox의 Count 값이 뷰가 변해도 유지될 수 있음!
 */

struct AnyLayoutDemo: View {
    @Environment(\.horizontalSizeClass) private var hSizeClass
 
    var body: some View {
        
        let isWide = hSizeClass == .regular
        
        let layout = isWide
            ? AnyLayout(HStackLayout(spacing: 12))
            : AnyLayout(VStackLayout(spacing: 12))
 
        VStack(alignment: .leading, spacing: 8) {
            
            Text("AnyLayout → \(isWide ? "HStack" : "VStack")")
                .font(.headline)
            
            layout {
                CounterBox(name: "영상 영역")
                CounterBox(name: "정보 영역")
            }
            .animation(.default, value: isWide)
        }
    }
}
 
struct CounterBox: View {
    let name: String
    @State private var count = 0
 
    var body: some View {
        Button {
            count += 1
        } label: {
            VStack {
                Text(name)
                
                Text("탭: \(count)")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(
                Color.accentColor.opacity(0.15),
                in: .rect(cornerRadius: 12)
            )
        }
        .buttonStyle(.plain)
    }
}
