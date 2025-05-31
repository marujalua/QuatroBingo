//
//  BingoTableView.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//
import ComposableArchitecture

@Reducer
struct BoardFeature {
    @ObservableState
    struct State {
        var table: BingoTable?
    }

    enum Action {
        
    }
}
