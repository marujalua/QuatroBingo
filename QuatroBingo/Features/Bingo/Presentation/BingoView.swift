//
//  BingoView.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 29/05/25.
//
import ComposableArchitecture
import SwiftUI

struct BingoView: View {
    @State var store: StoreOf<BingoFeature>

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(0..<10) { i in
                            HStack(alignment: .center) {
                                Text("🥇")
                                Spacer().frame(width: 8)
                                Text("Paula selecionou uma palavra \(i % 2 == 0 ? "que tem no maximo" : "")")
                                    .foregroundStyle(Color.black)
                                    .font(.system(size: 12))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                    }
                }
                HStack {
                    Text("WWDC")
                        .font(.system(size: 36))
                        .fontWeight(.black)
                        .foregroundStyle(.white)

                    Spacer().frame(width: 16)

                    Button {} label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .tint(.white)
                }
            }
            Spacer()

            BoardView(
                store: store.scope(
                    state: \.board,
                    action: \.board
                )
            )
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]),
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            )
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        BingoView(
            store: Store(
                initialState: BingoFeature.State(
                    ids: .init(bingo: "", player: "", match: "")
                ),
                reducer: BingoFeature.init
            )
        )
    }
}
