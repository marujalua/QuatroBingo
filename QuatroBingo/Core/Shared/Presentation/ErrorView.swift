//
//  ErrorView.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import SwiftUI

struct ErrorView: View {
    var tryAgain: () -> Void

    var body: some View {
        VStack {
            Image(systemName: "x.circle.fill")
                .foregroundStyle(Color.red)
                .tint(.red)
                .font(.system(size: 72))
            Spacer().frame(height: 24)
            Text("Ocorreu um erro, por favor tente novamente!")
                .font(.title3)
                .multilineTextAlignment(.center)
            Spacer().frame(height: 16)
            Button(action: tryAgain) {
                Label("Tentar novamente", systemImage: "arrow.counterclockwise")
                    .frame(maxWidth: .infinity)
            }
            .tint(.red)
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    ErrorView {}
}
