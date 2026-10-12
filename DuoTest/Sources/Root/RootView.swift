//
//  RootView.swift
//  DuoTest
//
//  Created by 김다예 on 10/12/26.
//

import SwiftUI

struct RootView: View {
    
    @StateObject
    var interactor: RootInteractor
    
    init(interactor: RootInteractor) {
        self._interactor = .init(wrappedValue: interactor)
    }
    
    var body: some View {
        NavigationStack(path: .init(
            get: { self.interactor.state.paths },
            set: { self.interactor.send(.updatePath($0)) }
        )) {
            List {
                Button {
                    self.interactor.send(.tapBoundsButton)
                } label: {
                    Text("Bounds")
                }
            }
            .navigationDestination(for: RootInteractor.State.Path.self) { route in
                switch route {
                case .bounds:
                    BoundsView()
                }
            }
        }
    }
}
