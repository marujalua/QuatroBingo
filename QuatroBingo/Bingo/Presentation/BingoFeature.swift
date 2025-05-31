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
        
        struct IDs: Equatable {
            let bingo: String
            let player: String
            let match: String
        }
    }
}
