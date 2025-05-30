//
//  HomeView.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//
import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    @State var store: StoreOf<HomeFeature>
    let router: StoreOf<RouterFeature>

    var body: some View {
        StatusView(status: store.status) {
            List(store.bingos) { bingo in
                HomeBingoItem(bingo: bingo)
                    .onTapGesture {
                        router.send(.detail(id: bingo.id))
                    }
            }
            .listStyle(.plain)
        } failure: {
            Text("Failure")
        }
        .onAppear {
            store.send(.requestBingo)
        }
        .navigationTitle("1Bingo")
    }
}


