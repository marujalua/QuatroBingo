//
//  RouterFeature.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import ComposableArchitecture

@Reducer
struct RouterFeature {
    @Reducer
    enum Path {
        case detail(DetailFeature)
    }

    @ObservableState
    struct State {
        var path = StackState<Path.State>()
    }

    enum Action {
        case detail(id: String)
        case path(StackActionOf<Path>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .detail(id):
                state.path.append(.detail(DetailFeature.State(id: id)))
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension RouterFeature.Path.State: Equatable {}
