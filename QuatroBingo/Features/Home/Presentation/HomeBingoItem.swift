//
//  HomeBingoItem.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import SwiftUI

struct HomeBingoItem: View {
    let bingo: BingoViewModel

    var body: some View {
        VStack {
            Text(bingo.name)
                .font(.title2.bold())
            HStack {
                ForEach(Array(bingo.wordsPreview.enumerated()), id: \.offset) { _, word in
                    Text(word)
                        .multilineTextAlignment(.center)
                        .frame(width: 96, height: 96, alignment: .center)
                        .background {
                            Color.white.opacity(0.15)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            Spacer().frame(height: 16)
            HStack {
                Text("\(bingo.wordCount) palavras")
                    .font(.subheadline)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .padding()

        .background(Color.accentColor.opacity(0.6))
        .background(Material.ultraThin)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    HomeBingoItem(
        bingo: BingoViewModel(
            id: "1234",
            name: "WWDC",
            wordsPreview: ["iOS 26", "Craig Federighi", "Xcode no iPad"],
            wordCount: 120
        )
    )
    .fontDesign(.rounded)
        .padding()
        .animatedBackground()
}
