
import SwiftUI

extension View {
    
    /// 뷰가 실제로 받은 영역을 재서,
    /// 바뀔 때마다 상태에 저장해줌
    func trackContainer(_ info: Binding<ContainerInfo>, label: String) -> some View {
        onGeometryChange(for: ContainerInfo.self) { proxy in
            ContainerInfo(size: proxy.size, safe: proxy.safeAreaInsets)
        } action: { new in
            info.wrappedValue = new
            print("[\(label)] screen: \(sizeFormat(Env.screen.size)) / container: \(sizeFormat(new.size)) / safe: \(insetFormat(new.safe))")
        }
    }
    
    func reservedRegionOverlay() -> some View {
        overlay {
            if #available(iOS 27.1, *) {
                ReservedRegionOverlay()
            }
        }
    }
    
    func safeAreaRegionBackground() -> some View {
        background {
            if #available(iOS 27.1, *) { SafeAreaBackground() }
        }
    }
    
    @ViewBuilder
    func hingeInfo(
        _ action: @escaping (_ status: String, _ degrees: Double?) -> Void
    ) -> some View {
        if #available(iOS 27.1, *) {
            onHingeChange { _, context in
                guard let hinge = context.hinge else {
                    action("힌지 없음", nil)
                    return
                }
                action(String(describing: hinge.status), hinge.angle.degrees)
            }
        } else {
            self
        }
    }
}
