//
//  DetailButton.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 01/06/25.
//

import SwiftUI

struct DetailButton: View {
    let text: String
    let tint: Color?
    let foregroundColor: Color
    var action: () -> Void

    init(
        text: String,
        tint: Color? = nil,
        foregroundColor: Color = .white,
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
                .font(.body.bold())
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(foregroundColor)
        }
        .padding(8)
        .glassEffect(.regular.interactive().tint(tint))
    }
}
