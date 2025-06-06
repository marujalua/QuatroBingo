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
        word.isSelected ? .black : .white
    }

    private var backgroundColor: Color {
        word.isSelected ? .white : .black.opacity(0.3)
    }

    var body: some View {
        VStack {
            Text("\(word.isSelected ? "✅" : "") \(word.value)")
                .foregroundStyle(foregroundColor)
                .lineLimit(3)
                .font(.system(size: 10))
        }
        .padding(.horizontal, 6)
        .frame(width: 100, height: 70, alignment: .center)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
