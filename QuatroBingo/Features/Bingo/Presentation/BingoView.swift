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
            switch store.orientation {
            case .landscapeLeft:
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
                .padding()
            case .landscapeRight:
                ShareView(store: store.scope(state: \.shareIds, action: \.share))
                    .padding()
            case .portrait:
                ScoreView(store: store.scope(state: \.score, action: \.score))
            default:
                Image(.luffyLu)
                    .resizable()
                    
            }

        } failure: {
            ErrorView {
                store.send(.onAppear)
            }
            .padding()
        }
        .fontDesign(.rounded)
        .animatedBackground()
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
                    ids: .init(bingo: "dm7Pmecx31VTkCKQcFA1", player: "F66F3F47-ED8F-4F23-97C0-65A6A492839A", match: "D9FA1AC0-2D6A-4EA0-8DDF-35E0050A5E33")
                ),
                reducer: BingoFeature.init
            )
        )
    }
}
