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
    @Dependency(\.shareMessageWorker) private var messageWorker
    @Dependency(\.uuid) private var uuid
    @Dependency(\.shareUrlWorker) private var urlBuilder

    @ObservableState
    struct State: Equatable {
        let ids: IDs
        var shareCode: ShareData?

        struct ShareData: Identifiable, Equatable {
            let id: UUID
            let message: String
            let url: URL
        }
    }

    enum Action {
        case copy(KeyPath<IDs, String>)
        case share
        case shareIsVisibible(State.ShareData?)
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
            case .share:
                return .run {[state] send in
                    let message = try await messageWorker.execute(with: state.ids)
                    let url = try await urlBuilder.execute(with: state.ids)

                    let data = State.ShareData(id: uuid(), message: message, url: url)

                    await send(.shareIsVisibible(data))
                }
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
