//
//  DetailButton.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 01/06/25.
//

import SwiftUI

struct DetailButton: View {
    let text: String
    let tint: Color = .white
    let foregroundColor: Color = .accent
    var action: () -> Void

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
