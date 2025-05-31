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
    struct State: Equatable {
        var table: BingoTable?
    }

    enum Action {
        case loadTable(BingoTable)
        case toggleWordAt(x: Int, y: Int)
        case updateDataDelegate(table: BingoTable?, x: Int, y: Int)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .loadTable(table):
                state.table = table
                return .none
            case let .toggleWordAt(x, y):
                var word = state.table?[x, y]
                word?.isSelected.toggle()
                state.table?[x, y] = word
                return .send(.updateDataDelegate(table: state.table, x: x, y: y))
            default:
                return .none
            }
        }
    }
}
