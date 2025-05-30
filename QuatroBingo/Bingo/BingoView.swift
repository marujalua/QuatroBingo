//
//  BingoView.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 29/05/25.
//

import SwiftUI

struct BingoView: View {
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
            Grid(alignment: .center, horizontalSpacing: 4, verticalSpacing: 4) {
                ForEach(0 ..< 5) { _ in
                    GridRow {
                        ForEach(0 ..< 5) { i in
                            VStack {
                                Text("Textinho \(i % 2 == 0 ? "que tem no maximo" : "") 3 linhas no máximo")
                                    .foregroundStyle(Color.white)
                                    .lineLimit(3)
                                    .fontDesign(.serif)
                                    .font(.system(size: 10))
                            }
                            .padding(.horizontal, 6)
                            .frame(width: 100, height: 70, alignment: .center)
                            .background(Color.black.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
            }
            .gridCellUnsizedAxes(.horizontal)
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
        BingoView()
    }
}
