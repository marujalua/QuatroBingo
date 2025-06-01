//
//  ScoreFeature.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 01/06/25.
//

import ComposableArchitecture

@Reducer
struct ScoreFeature {
    @ObservableState
    struct State: Equatable {
        var players: [String: Player]
    }

    enum Action {
        case updatePlayers([String: Player])
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .updatePlayers(players):
                state.players = players
                return .none
            }
        }
    }
}
