//
//  RouterView.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import SwiftUI
import ComposableArchitecture

struct RouterView: View {
    @State var store: StoreOf<RouterFeature>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            HomeView(
                store: Store(initialState: HomeFeature.State()) {
                    HomeFeature()
                },
                router: store
            )
        } destination: { store in
            switch store.case {
            case .detail(let store):
                DetailView(store: store)
            case .bingo(let store):
                BingoView(store: store)
            }
        }
    }
}
