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
    var enterMatch: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Button {
                store.send(.back, animation: .easeInOut)
            } label: {
                Label("Voltar", systemImage: "chevron.left")
                    .labelStyle(.iconOnly)
            }
            
            Spacer()
            DetailHeader(
                title: "¡bingo!",
                description: "escolha um emoji e um apelido para te representar"
            )

            Spacer().frame(height: 32)

            HStack {
                Button {
                    store.send(.changeEmoji)
                } label: {
                    Text(store.emoji)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)

                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .buttonBorderShape(.capsule)
                TextField("apelido", text: $store.nickname.sending(\.valueDidChange))
                    .textFieldStyle(DetailTextFieldStyle())
            }

            Spacer().frame(height: 96)

            DetailButton(
                text: "entrar no jogo",
                tint: Color.secondaryAccent,
                foregroundColor: Color.accent
            ) {
                enterMatch()
            }
            .disabled(store.roomId.isEmpty || store.nickname.isEmpty)
            .shadow(radius: 3)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .padding(.bottom, 8)
    }
}

struct DetailTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(.clear)
                .clipShape(Capsule(style: .circular))
                .background(Capsule().stroke(style: .init()))
        }
}

#Preview {
    NameStep(
        store: Store(initialState: StepperFeature.State(), reducer: StepperFeature.init)
    ) {}
    .background(Image("BackgroundExample"))
}
