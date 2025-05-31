//
//  LogFeature.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//

import ComposableArchitecture

@Reducer
struct LogFeature {
    @ObservableState
    struct State: Equatable {
        var name: String
        var logs: [Match.Log]
    }

    enum Action {
        case updateLogs([Match.Log])
        case updateName(String)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .updateLogs(logs):
                state.logs = logs
                return .none
            case let .updateName(name):
                state.name = name
                return .none
            }
        }
    }
}
