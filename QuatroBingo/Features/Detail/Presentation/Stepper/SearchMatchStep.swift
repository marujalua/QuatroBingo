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
        VStack {
            TextField("Código da partida", text: $store.roomId.sending(\.roomIdDidChange))
                .textFieldStyle(.roundedBorder)
                .focused($isInputActive)

            Button {
                store.send(.searchMatch, animation: .linear)
            } label: {
                Text("Buscar partida")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            .disabled(store.nickname.isEmpty || store.roomId.isEmpty)

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
