//
//  DetailButton.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 01/06/25.
//

import SwiftUI

struct DetailButton: View {
    let text: String
    let tint: Color
    let foregroundColor: Color
    var action: () -> Void

    init(
        text: String,
        tint: Color = .white,
        foregroundColor: Color = .accent,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.tint = tint
        self.foregroundColor = foregroundColor
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(text)
                .padding(.vertical, 4)
                .font(.body.bold())
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(foregroundColor)
        }
        .buttonStyle(.borderedProminent)
        .tint(tint)
        .buttonBorderShape(.capsule)
    }
}
