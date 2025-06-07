//
//  SelectionStep.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 01/06/25.
//

import SwiftUI
import ComposableArchitecture

struct SelectionStep: View {
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
            Text("¡bingo!")
                .font(.largeTitle)
                .fontWeight(.black)

            Text("se divirta assistindo a WWDC com seus amigos")
                .font(.title3)

            Spacer().frame(height: 32)

            DetailButton(text: "criar sala") {
                store.send(.createMatch, animation: .easeInOut)
            }

            DetailButton(text: "buscar sala") {
                store.send(.searchMatch, animation: .easeInOut)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .padding(.bottom, 8)
    }
}


#Preview {
    SelectionStep(
        store: Store(initialState: StepperFeature.State(), reducer: StepperFeature.init)
    )
    .background(Image("BackgroundExample"))
}
