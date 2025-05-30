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
        } failure: {
            Text("Failure")
        }
        .onAppear {
            store.send(.requestBingo)
        }
        .navigationTitle("1Bingo")
    }
}

struct HomeBingoItem: View {
    let bingo: BingoViewModel

    var body: some View {
        VStack {
            Text(bingo.name)
            HStack {
                ForEach(Array(bingo.wordsPreview.enumerated()), id: \.offset) { _, word in
                    Text(word)
                        .frame(width: 96, height: 96, alignment: .center)
                        .background {
                            Color.white.opacity(0.2)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            HStack {
                Text("\(bingo.wordCount) palavras")
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .padding()
        .background(Color.purple)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
