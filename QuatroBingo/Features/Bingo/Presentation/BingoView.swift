//
//  BingoView.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 29/05/25.
//
import ComposableArchitecture
import SwiftUI

struct BingoView: View {
    @State var store: StoreOf<BingoFeature>

    var body: some View {
        StatusView(status: store.status) {
            HStack {
                LogView(
                    store: store.scope(state: \.log, action: \.log)
                )
                Spacer()
                BoardView(
                    store: store.scope(
                        state: \.board,
                        action: \.board
                    )
                )
            }
        } failure: {
            ErrorView {
                store.send(.onAppear)
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            )
        .toolbarVisibility(.hidden, for: .navigationBar)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    NavigationStack {
        BingoView(
            store: Store(
                initialState: BingoFeature.State(
                    ids: .init(bingo: "", player: "", match: "")
                ),
                reducer: BingoFeature.init
            )
        )
    }
}
