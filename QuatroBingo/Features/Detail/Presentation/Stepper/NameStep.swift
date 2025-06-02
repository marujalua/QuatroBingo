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

    var body: some View {
        VStack(alignment: .leading) {
            DetailHeader(
                title: "¡bingo!",
                description: "escolha um emoji e um apelido para te representar"
            )

            Spacer().frame(height: 32)



            DetailButton(
                text: "entrar no jogo",
                tint: Color.secondaryAccent,
                foregroundColor: Color.accent
            ) {
                store.send(.searchMatch, animation: .linear)
            }
            .shadow(radius: 3)
        }
        .foregroundStyle(.white)
        .fontDesign(.rounded)
        .frame(maxWidth: .infinity)
        .padding()
        .padding(.bottom, 8)
    }
}

#Preview {
    NameStep(
        store: Store(initialState: StepperFeature.State(), reducer: StepperFeature.init)
    )
    .background(Image("BackgroundExample"))
}
