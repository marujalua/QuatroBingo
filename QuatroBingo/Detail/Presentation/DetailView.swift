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


    private let columnLayout = [
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 4),
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 4),
        GridItem(.flexible(minimum: 100, maximum: 200), spacing: 4),
    ]

    var body: some View {
        StatusView(status: store.status) {
            if let bingo = store.bingo?.model {
                VStack {
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

                    Spacer()

                    steps

                }
            }
        } failure: {
            Text("Oiii")
        }
        .onAppear {
            store.send(.retrieveBingo)
        }
        .navigationTitle(store.bingo?.model.name ?? "")
        .toolbarBackground(.visible, for: .navigationBar)
    }

    @ViewBuilder
    var steps: some View {
        let store = store.scope(state: \.stepState, action: \.stepChanged)

        switch store.step {
        case .name:
            NameStep(store: store)
                .transition(.slide)
        case .search:
            SearchMatchStep(store: store)
                .transition(.slide)
        case .create:
            CreateMatchStep(store: store)
                .transition(.slide)
        }
    }
}

struct NameStep: View {
    @Bindable var store: StoreOf<StepperFeature>
    @FocusState var isInputActive: Bool

    var body: some View {
        VStack {
            TextField("Apelido", text: $store.nickname.sending(\.valueDidChange))
                .focused($isInputActive)
                .textFieldStyle(.roundedBorder)

            Button {
                store.send(.createMatch, animation: .linear)
            } label: {
                Text("Criar partida")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            .disabled(store.nickname.isEmpty)

            Button {
                store.send(.searchMatch, animation: .linear)
            } label: {
                Text("Buscar partida")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.bordered)
            .tint(.purple)
            .disabled(store.nickname.isEmpty)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .padding(.bottom, 8)
        .background(Color(UIColor.systemBackground))
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isInputActive = false
                }
            }
        }
    }
}

struct CreateMatchStep: View {
    @Bindable var store: StoreOf<StepperFeature>

    var body: some View {
        VStack {
            TextField("Código da partida", text: .constant(store.roomId))
                .textFieldStyle(.roundedBorder)

            Button {
                store.send(.enterMatch)
            } label: {
                Text("Criar partida")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)

            Button {
                store.send(.back, animation: .linear)
            } label: {
                Text("Voltar")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.bordered)
            .tint(.purple)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .padding(.bottom, 8)
        .background(Color(UIColor.systemBackground))
    }
}

struct SearchMatchStep: View {
    @Bindable var store: StoreOf<StepperFeature>
    @FocusState var isInputActive: Bool

    var body: some View {
        VStack {
            TextField("Código da partida", text: $store.roomId.sending(\.roomIdDidChange))
                .textFieldStyle(.roundedBorder)
                .focused($isInputActive)

            Button {
                store.send(.enterMatch)
            } label: {
                Text("Buscar partida")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)

            Button {
                store.send(.back, animation: .linear)
            } label: {
                Text("Voltar")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.bordered)
            .tint(.purple)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .padding(.bottom, 8)
        .background(Color(UIColor.systemBackground))
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isInputActive = false
                }
            }
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
