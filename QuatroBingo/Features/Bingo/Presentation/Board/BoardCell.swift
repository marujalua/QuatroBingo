//
//  BoardCell.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//

import SwiftUI

struct BoardCell: View {
    let word: BingoTable.Word

    private var foregroundColor: Color {
        .black
    }

    private var backgroundColor: Color? {
        word.isSelected ? .white : nil
    }

    var body: some View {
        VStack {
            Text("\(word.isSelected ? "✅" : "") \(word.value)")
                .foregroundStyle(foregroundColor)
                .lineLimit(3)
                .font(.system(size: 10))
        }
        .padding(.horizontal, 6)
        .preferredColorScheme(.light)
        .frame(width: 100, height: 70, alignment: .center)
        .glassEffect(
            .regular.interactive().tint(backgroundColor),
            in: RoundedRectangle(cornerRadius: 6)
        )
    }
}
