//
//  DetailView.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import SwiftUI
import ComposableArchitecture
import SwiftUINavigation

struct DetailView: View {
    @State var store: StoreOf<DetailFeature>

    private let columnLayout = [
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 4),
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 4),
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 4),
    ]

    var body: some View {
        StatusView(status: store.status) {
            if let bingo = store.bingo?.model {
                VStack {
                    bingoGrid(bingo: bingo)
                    Spacer()
                    steps
                }
            }
        } failure: {
            ErrorView {
                store.send(.retrieveBingo)
            }
        }
        .onAppear {
            store.send(.retrieveBingo)
        }
        .navigationTitle(store.bingo?.model.name ?? "")
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(
            isPresented: $store.enterMatchErrorDisplayed.sending(\.enterMatchErrorDisplayed)
        ) {
            ErrorView {
                store.send(.enterMatch)
            }
            .presentationDetents([.fraction(0.4)])
        }
    }

    @ViewBuilder
    private var steps: some View {
        let store = store.scope(state: \.stepState, action: \.stepChanged)

        switch store.step {
        case .name:
            NameStep(store: store)
                .transition(.slide)
        case .search:
            SearchMatchStep(store: store) {
                self.store.send(.enterMatch)
            }
                .transition(.slide)
        case .create:
            CreateMatchStep(store: store) {
                self.store.send(.enterMatch)
            }
                .transition(.slide)
        }
    }

    @ViewBuilder
    private func bingoGrid(bingo: Bingo) -> some View {
        ScrollView {
            LazyVGrid(columns: columnLayout, spacing: 4) {
                ForEach(Array(bingo.words.enumerated()), id: \.offset) { _, word in
                    ZStack {
                        Rectangle().foregroundStyle(Color.purple.opacity(0.6))
                        Text(word)
                            .font(.system(size: 10))
                            .bold()
                            .foregroundStyle(Color.white)
                            .padding()
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
            }
            .clipShape(RoundedRectangle(cornerSize: .init(width: 8, height: 8)))
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(
            store: Store(
                initialState: DetailFeature.State(id: "id"),
                reducer: { DetailFeature() }
            )
        )
    }
}
