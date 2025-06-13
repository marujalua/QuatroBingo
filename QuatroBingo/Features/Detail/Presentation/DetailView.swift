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
            steps
                .foregroundStyle(.white)
                .fontDesign(.rounded)
        } failure: {
            ErrorView {
                store.send(.retrieveBingo)
            }
            .background(Material.thin)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
        }
        .onAppear {
            store.send(.retrieveBingo)
        }
        .navigationTitle(store.bingo?.model.name ?? "")
        .sheet(
            isPresented: $store.enterMatchErrorDisplayed.sending(\.enterMatchErrorDisplayed)
        ) {
            ErrorView {
                store.send(.enterMatch)
            }
            .presentationDetents([.fraction(0.4)])
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    store.send(.stepChanged(.back), animation: .easeInOut)
                } label: {
                    Label(
                        "Voltar",
                        systemImage: store.stepState.stepStack.count > 1 ? "chevron.left" : "xmark"
                    )
                        .labelStyle(.iconOnly)
                }
            }
        })
        .navigationBarBackButtonHidden()
        .animatedBackground()
    }

    @ViewBuilder
    private var steps: some View {
        let store = store.scope(state: \.stepState, action: \.stepChanged)

        switch store.step {
        case .name:
            NameStep(store: store) {
                self.store.send(.enterMatch)
            }
            .transition(.push(from: .trailing).animation(.easeInOut))
        case .search:
            SearchMatchStep(store: store)
                .transition(.push(from: .trailing).animation(.easeInOut))
        case .create:
            CreateMatchStep(store: store)
                .transition(.push(from: .trailing).animation(.easeInOut))
        case .select:
            SelectionStep(store: store)
                .transition(.push(from: .trailing).animation(.easeInOut))
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(
            store: Store(
                initialState: DetailFeature.State(id: "dm7Pmecx31VTkCKQcFA1", enterMatchErrorDisplayed: true),
                reducer: { DetailFeature() }
            )
        )
    }
}
