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
    var enterMatch: () -> Void

    var body: some View {
        VStack {
            TextField("Código da partida", text: .constant(store.roomId))
                .textFieldStyle(.roundedBorder)

            Button {
                enterMatch()
            } label: {
                Text("Criar partida")
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
    }
}
