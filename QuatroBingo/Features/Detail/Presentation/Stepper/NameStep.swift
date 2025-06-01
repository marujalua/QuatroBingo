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
            

            Spacer().frame(height: 32)

            DetailButton(text: "criar sala") {
                store.send(.createMatch, animation: .linear)
            }

            DetailButton(text: "buscar sala") {
                store.send(.searchMatch, animation: .linear)
            }
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
