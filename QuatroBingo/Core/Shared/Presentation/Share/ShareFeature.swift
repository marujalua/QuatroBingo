//
//  ShareFeature.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 07/06/25.
//

import ComposableArchitecture
import UIKit

@Reducer
struct ShareFeature {
    @Dependency(\.pasteboard) private var pasteboard

    @ObservableState
    struct State: Equatable {
        let ids: IDs
        var shareCode: String?
    }

    enum Action {
        case copy(KeyPath<IDs, String>)
        case share(KeyPath<IDs, String>)
        case shareIsVisibible(String?)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .copy(keypath):
                return .run {[state] send in
                    await MainActor.run {
                        pasteboard.string = state.ids[keyPath: keypath]
                    }
                }
            case let .share(keypath):
                return .send(.shareIsVisibible(state.ids[keyPath: keypath]))
            case let .shareIsVisibible(value):
                state.shareCode = value
                return .none
            }
        }
    }
}

extension DependencyValues {
    var pasteboard: UIPasteboard {
        get {
            UIPasteboard.general
        }
    }
}
