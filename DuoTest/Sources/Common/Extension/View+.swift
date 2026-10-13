
import SwiftUI

extension View {
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
}
