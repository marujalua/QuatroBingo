//
//  ShareView.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 06/06/25.
//
import ComposableArchitecture
import SwiftUI

struct ShareView: View {
    @Bindable var store: StoreOf<ShareFeature>

    var body: some View {
        VStack {
            Text(store.ids.match)
                .font(.title.bold())
            HStack {
                DetailButton(text: "️✍ copiar") { store.send(.copy(\.match))
                }
                Spacer().frame(width: 32)
                DetailButton(text: "🚚️ compartilhar") { store.send(.share)
                }
            }
            .padding(.horizontal, 64)
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    ShareViewHolder(store: Store(initialState: ShareFeature.State(ids: IDs(bingo: "", player: "", match: "9ee0e60c-dc87-4519-83ef-02272bdc4ab9"), shareCode: nil), reducer: {
        ShareFeature()
    }), content: { store in
        ShareView(store: store)
    })
        .fontDesign(.rounded)
        .animatedBackground()
}
