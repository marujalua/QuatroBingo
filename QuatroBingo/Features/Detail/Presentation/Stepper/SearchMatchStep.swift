//
//  SearchMatchStep.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import SwiftUI
import ComposableArchitecture

struct SearchMatchStep: View {
    @Bindable var store: StoreOf<StepperFeature>
    @FocusState var isInputActive: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()

            DetailHeader(
                title: "¡bingo!",
                description: "compartilhe o código para convidar seus amigos"
            )

            Spacer().frame(height: 32)
            TextField("Código da partida", text: $store.roomId.sending(\.roomIdDidChange))
                .textFieldStyle(DetailTextFieldStyle())
                .focused($isInputActive)

            Spacer().frame(height: 32)

            DetailButton(text: "proximo", tint: .secondaryAccent, foregroundColor: Color.accent) {
                store.send(.confirmMatch, animation: .easeInOut)
            }
            .disabled(store.roomId.isEmpty)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .padding(.bottom, 8)
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
