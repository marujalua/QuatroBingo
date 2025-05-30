//
//  DetailView.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import SwiftUI
import ComposableArchitecture

struct DetailView: View {
    @State var store: StoreOf<DetailFeature>

    var body: some View {
        VStack {
            Text("Detail \(store.id)")
            Button("Next") { store.send(.testingNav) }
        }
    }
}

#Preview {
    DetailView(
        store: Store(
            initialState: DetailFeature.State(id: "id"),
            reducer: {DetailFeature()
            })
    )
}
