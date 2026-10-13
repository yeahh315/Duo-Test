
import SwiftUI

/// ❌ VStack 맨 아래에 직접 깐 바 → 시스템이 바로 인식 못 함, 아래에 그대로 남음
struct CustomBarView: View {
    var body: some View {
        VStack(spacing: 0) {
            SizeReadout(label: "customBar")
            HStack {
                Button("필터", systemImage: "camera.filters") {}
                Spacer()
                Button("저장", systemImage: "square.and.arrow.down") {}
            }
            .padding()
            .background(.bar)
        }
        .navigationTitle("커스텀 바")
    }
}
