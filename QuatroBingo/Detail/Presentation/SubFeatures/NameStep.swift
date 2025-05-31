//
//  NameStep.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import SwiftUI
import ComposableArchitecture

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
