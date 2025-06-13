//
//  BoardView.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//
import ComposableArchitecture
import SwiftUI

struct BoardView: View {
    @Bindable var store: StoreOf<BoardFeature>

    var body: some View {
        if let board = store.table {
            Grid(
                alignment: .center,
                horizontalSpacing: 4,
                verticalSpacing: 4
            ) {
                ForEach(
                    Array(board.table.enumerated()),
                    id: \.offset
                ) { y, row in
                    GridRow {
                        ForEach(Array(row.enumerated()), id: \.offset) { x, word in
                            BoardCell(word: word)
                                .onTapGesture {
                                    store.send(.toggleWordAt(x: x, y: y), animation: .easeIn)
                                }
                        }
                    }
                }
            }
            .gridCellUnsizedAxes(.horizontal)
        }
    }
}

#Preview {
    BoardView(
        store: Store(
            initialState: BoardFeature.State(
                table: BingoTable(words: Array(repeating: "A Big Word", count: 25))
            ),
            reducer: {
                BoardFeature()
            }
        )
    )
    .animatedBackground()
}
