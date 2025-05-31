//
//  BingoFeature.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//

import ComposableArchitecture

@Reducer
struct BingoFeature {
    @ObservableState
    struct State: Equatable {
        let ids: IDs
        var board = BoardFeature.State()

        struct IDs: Equatable {
            let bingo: String
            let player: String
            let match: String
        }
    }

    enum Action {
        case board(BoardFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.board, action: \.board) {
            BoardFeature()
        }
    }
}
