
import SwiftUI

@available(iOS 27.1, *)
struct ArrangementDemo: View {
    @Environment(\.dismiss) private var dismiss
 
    var body: some View {
        NavigationStack {
            ArrangementView {
                SizeReadout(label: "primary")
                    .background(Color.blue.opacity(0.1))
            } secondary: {
                SizeReadout(label: "secondary")
                    .background(Color.orange.opacity(0.1))
            }
            /// 가로일 때만 나란히: .split.axes(.horizontal)
//            .arrangementViewStyle(.split)
            .navigationTitle("Arrangement")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("닫기", systemImage: "xmark") { dismiss() }
                }
            }
        }
    }
}
