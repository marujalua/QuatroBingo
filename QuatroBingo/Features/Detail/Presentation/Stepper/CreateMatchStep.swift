//
//  CreateMatchStep.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import SwiftUI
import ComposableArchitecture

struct CreateMatchStep: View {
    @Bindable var store: StoreOf<StepperFeature>

    var body: some View {
        VStack(alignment: .leading) {
            Button {
                store.send(.back, animation: .easeInOut)
            } label: {
                Label(
                    "Voltar",
                    systemImage: store.stepStack.count > 1 ? "chevron.left" : "xmark"
                )
                    .labelStyle(.iconOnly)
            }

            Spacer()

            DetailHeader(
                title: "¡bingo!",
                description: "compartilhe o código para convidar seus amigos"
            )

            Spacer().frame(height: 32)

            TextField("Código da partida", text: .constant(store.roomId))
                .textFieldStyle(DetailTextFieldStyle())

            ShareViewHolder(
                store: Store(
                    initialState: ShareFeature.State(ids: .init(bingo: "", player: "", match: store.roomId)),
                    reducer: {
                        ShareFeature()
                    })
            ) { store in
                    HStack {
                        DetailButton(text: "copiar") { store.send(.copy(\.match)) }
                        Spacer().frame(width: 16)
                        DetailButton(text: "compartilhar") { store.send(.share) }
                    }
                }

            Spacer().frame(height: 32)

            DetailButton(text: "proximo", tint: .secondaryAccent, foregroundColor: Color.accent) {
                store.send(.confirmMatch, animation: .easeInOut)
            }
            .disabled(store.roomId.isEmpty)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .padding(.bottom, 8)
    }
}
