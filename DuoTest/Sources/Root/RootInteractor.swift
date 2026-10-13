//
//  RootInteractor.swift
//  DuoTest
//
//  Created by 김다예 on 10/12/26.
//

import Foundation
import Combine

final class RootInteractor: ObservableObject {

    struct State {
        enum Path: Hashable {
            case bounds
            case sizeClass
            case systemToolbar
            case customBar
        }

        enum Cover: String, Identifiable {
            case split, tab, arrangement
            var id: String { rawValue }
        }

        var paths: [Path] = []
        var cover: Cover?
    }

    enum Action {
        case updatePath([State.Path])
        case updateCover(State.Cover?)

        // push
        case tapBoundsButton
        case tapSizeClassButton
        case tapSystemToolbarButton
        case tapCustomBarButton

        // cover
        case tapSplitButton
        case tapTabButton
        case tapArrangementButton
    }

    enum Mutation {
        case setPaths([State.Path])
        case setCover(State.Cover?)
    }

    @Published
    private(set) var state: State

    init(state: State) {
        self.state = state
    }
}

extension RootInteractor {
    func send(_ action: Action) {
        Task { [weak self] in
            guard let self else { return }

            let mutation = await mutate(action: action)

            await MainActor.run {
                let newState = self.reduce(state: self.state, mutation: mutation)
                self.state = newState
            }
        }
    }

    func mutate(action: Action) async -> Mutation {
        switch action {
        case .updatePath(let paths):
            return .setPaths(paths)
        case .updateCover(let cover):
            return .setCover(cover)

        case .tapBoundsButton:
            return .setPaths([.bounds])
        case .tapSizeClassButton:
            return .setPaths([.sizeClass])
        case .tapSystemToolbarButton:
            return .setPaths([.systemToolbar])
        case .tapCustomBarButton:
            return .setPaths([.customBar])
        case .tapSplitButton:
            return .setCover(.split)
        case .tapTabButton:
            return .setCover(.tab)
        case .tapArrangementButton:
            return .setCover(.arrangement)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setPaths(let paths):
            newState.paths = paths
        case .setCover(let cover):
            newState.cover = cover
        }

        return newState
    }
}
