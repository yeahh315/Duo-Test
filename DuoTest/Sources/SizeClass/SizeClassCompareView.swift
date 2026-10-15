
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
        let byIdiom = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 1
        let byOrientation = Env.isLandscape ? 3 : 1
        let bySizeClass = hSizeClass == .regular ? 3 : 1

        VStack(spacing: 0) {
            Text("넓으면 3열, 좁으면 1열이 권장 (기준: sizeClass)")
                .font(.headline)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    InfoRows(rows: [
                        .init("컨테이너 Width", "\(Int(fullContainer.size.width))"),
                        .init("hSizeClass", Env.name(hSizeClass)),
                        .init("vSizeClass", Env.name(vSizeClass)),
                        .init("idiom", Env.idiom),
                        .init("orientation", Env.orientation),
                    ])
                    GridDemo(
                        title: "idiom 기준",
                        columns: byIdiom,
                        expected: bySizeClass,
                        failsWhen: "펼쳤을 때 (넓은데도 .phone이라 1열)"
                    )
                    GridDemo(
                        title: "orientation 기준",
                        columns: byOrientation,
                        expected: bySizeClass,
                        failsWhen: "닫고 가로로 눕혔을 때 (좁은데 3열) · 펼치고 세로로 들었을 때 (넓은데 1열)"
                    )
                    GridDemo(
                        title: "sizeClass 기준 (권장)",
                        columns: bySizeClass,
                        expected: bySizeClass,
                        failsWhen: "모든 상황에서 받은 공간 기준으로 맞음"
                    )
                    AnyLayoutDemo()
                }
                .padding()
            }
        }
        .trackContainer($fullContainer, label: "fullContainer")
        .onChange(of: hSizeClass) { old, new in
            print("hSizeClass:", Env.name(old), "→", Env.name(new))
        }
        .onChange(of: vSizeClass) { old, new in
            print("vSizeClass:", Env.name(old), "→", Env.name(new))
        }
        .navigationTitle("sizeClass 비교")
    }
}

struct GridDemo: View {
    let title: String
    let columns: Int
    let expected: Int          // 지금 상태의 정답 열 수 (sizeClass 기준)
    let failsWhen: String      // 이 방식이 틀리는 상황

    private var isCorrect: Bool { columns == expected }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(title) → \(columns)열")
                    .font(.headline)
                Spacer()
                Label(
                    isCorrect ? "맞음" : "권장 X · 권장 \(expected)열",
                    systemImage: isCorrect ? "checkmark.circle.fill" : "xmark.octagon.fill"
                )
                .font(.caption.bold())
                .foregroundStyle(isCorrect ? .green : .red)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns)) {
                ForEach(0..<6, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 8)
                        .fill((isCorrect ? Color.accentColor : Color.red).opacity(0.2))
                        .frame(height: 44)
                        .overlay(Text("\(i + 1)"))
                }
            }

            Text(failsWhen)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCorrect ? Color.clear : Color.red, lineWidth: 2)
        )
        .animation(.default, value: isCorrect)
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

/// AnyLayout을 통해서 화면이 넓으면 HStack으로, 좁으면 VStack으로 뷰 배치
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
